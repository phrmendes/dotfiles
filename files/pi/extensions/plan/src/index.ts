import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { Key } from "@earendil-works/pi-tui";
import { readFileSync } from "node:fs";
import { join } from "node:path";
import { parse as parseShell } from "shell-quote";
import { marked } from "marked";

const WRITE_TOOLS = new Set(["edit", "write"]);

const SAFE_TOOLS = new Set(["agent-browser", "bat", "cat", "cd", "curl", "date", "df", "diff", "du", "echo", "eza", "false", "fd", "file", "find", "grep", "head", "id", "jira", "jq", "less", "ls", "more", "ps", "pwd", "readlink", "rg", "sort", "stat", "tail", "tree", "true", "type", "uname", "uniq", "wc", "which", "whoami", "xargs"]);

const SAFE_SUBCOMMANDS: Record<string, string[]> = {
    git: ["status", "log", "diff", "show", "branch", "remote", "ls-files", "ls-tree"],
    kubectl: ["get", "describe", "logs", "top", "explain", "version", "cluster-info", "api-resources", "api-versions", "events", "auth", "config", "diff", "rollout"],
    gh: ["issue", "pr", "repo", "run", "search", "status", "auth", "browse", "label", "milestone", "project", "release", "gist", "codespace", "workflow", "extension"],
    gcloud: ["version", "info", "config", "list", "describe"],
    nix: ["eval", "search", "show-config", "path-info", "why-depends", "log", "flake", "repl"],
};

const PLAN_SUBCOMMANDS = [
    { value: "create", label: "create — ask the agent to draft the formal plan" },
    { value: "approve", label: "approve — approve the plan and begin implementation" },
    { value: "disable", label: "disable — exit plan mode without starting implementation" },
];

const CHAIN_OPS = new Set(["|", "||", "&&", ";"]);
const BLOCK_OPS = new Set(["&", ">&", "<&", "<(", ">", ">>"]);

interface PlanStep {
    step: number;
    text: string;
}

/**
 * Plan mode extension for pi coding agent.
 *
 * Restricts the agent to read-only operations for exploration and planning.
 * Supports subcommands: create, approve, disable.
 */
export default function planMode(pi: ExtensionAPI): void {
    let enabled = false;
    let creating = false;
    let steps: PlanStep[] = [];
    let savedTools: string[] | undefined;
    let skillContent: string | null = null;

    /** Writes current plan-mode state to the session entry. */
    function persistState(): void {
        pi.appendEntry("plan-mode", { enabled, creating, steps });
    }

    /**
     * Returns true if the first word is a known safe tool or a known
     * subcommand of a restricted tool (e.g. `git status`).
     */
    function isCommandSafe(words: string[]): boolean {
        const [cmd, sub] = words;
        if (!cmd) return false;
        if (SAFE_TOOLS.has(cmd)) return true;
        const allowed = SAFE_SUBCOMMANDS[cmd];
        return allowed != null && sub != null && allowed.includes(sub);
    }

    /**
     * Returns true if every segment of a shell command is safe.
     * Blocks backticks and {@link BLOCK_OPS}. Splits on {@link CHAIN_OPS}
     * and checks each segment independently.
     */
    function isSafe(command: string): boolean {
        if (command.includes("`")) return false;
        const tokens = parseShell(command);
        const segments: string[][] = [[]];
        for (const tok of tokens) {
            if (typeof tok === "string") {
                segments[segments.length - 1].push(tok);
            } else if ("op" in tok) {
                if (BLOCK_OPS.has(tok.op)) return false;
                if (CHAIN_OPS.has(tok.op)) segments.push([]);
            }
        }
        return segments.every(isCommandSafe);
    }

    /**
     * Extracts the title from a markdown list item.
     * Handles `**Title** — description`, falls back to text before ` —`.
     */
    function extractBoldTitle(text: string): string | null {
        if (text.startsWith("**")) {
            const close = text.indexOf("**", 2);
            if (close > 2) return text.slice(2, close).trim();
        }
        const fallback = text.split(" —")[0].trim();
        return fallback.length > 0 ? fallback : null;
    }

    /**
     * Parses a markdown message for an ordered list under a `## Steps` heading.
     * Returns an array of {@link PlanStep} with incrementing step numbers.
     */
    function extractPlanSteps(message: string): PlanStep[] {
        const tokens = marked.lexer(message);
        const items: PlanStep[] = [];
        let inSteps = false;

        for (const tok of tokens) {
            if (tok.type === "heading" && tok.depth <= 3
                && tok.text.trim().toLowerCase() === "steps") {
                inSteps = true;
                continue;
            }
            if (inSteps && tok.type === "heading") break;
            if (!inSteps || tok.type !== "list" || !tok.ordered) continue;

            for (const item of tok.items) {
                const title = extractBoldTitle(item.text);
                if (title && title.length > 3)
                    items.push({ step: items.length + 1, text: title });
            }
            break;
        }
        return items;
    }

    /**
     * Loads the plan mode SKILL.md from disk.
     * Returns null if the file is missing or cannot be read.
     */
    function loadSkillContent(): string | null {
        try {
            const agentHome = join(process.env.HOME!, ".pi", "agent");
            return readFileSync(join(agentHome, "skills", "plan", "SKILL.md"), "utf8");
        } catch {
            return null;
        }
    }

    /** Enables plan mode: disables write tools, sets status, persists state. */
    function enable(ctx: ExtensionContext): void {
        if (enabled) return;
        enabled = true;
        creating = false;
        steps = [];
        savedTools = pi.getActiveTools();
        pi.setActiveTools(savedTools.filter(t => !WRITE_TOOLS.has(t)));
        ctx.ui.setStatus("plan", "plan: enabled");
        ctx.ui.notify("Plan mode on — write tools disabled.");
        persistState();
    }

    /** Disables plan mode: restores tools, clears status, persists state. */
    function disable(ctx: ExtensionContext, reason: "approve" | "disable"): void {
        if (!enabled) { ctx.ui.notify("Not in plan mode.", "warning"); return; }
        enabled = false;
        creating = false;
        steps = [];
        pi.setActiveTools(savedTools ?? pi.getActiveTools());
        savedTools = undefined;
        ctx.ui.setStatus("plan", undefined);
        ctx.ui.notify(reason === "approve"
            ? "Plan approved — switching to dev mode."
            : "Plan mode disabled.");
        persistState();
    }

    const subcommandHandlers: Record<string, (ctx: ExtensionContext) => void> = {
        create(ctx) {
            if (!enabled) { ctx.ui.notify("Not in plan mode.", "warning"); return; }
            creating = true;
            pi.sendUserMessage("Produce the formal plan now.");
            persistState();
        },
        approve(ctx) {
            if (steps.length === 0) { ctx.ui.notify("No plan to approve.", "warning"); return; }
            disable(ctx, "approve");
            pi.sendUserMessage("The plan is approved. Begin implementation now.");
        },
        disable: (ctx) => disable(ctx, "disable"),
    };

    pi.registerCommand("plan", {
        description: "Plan mode: enable, or run a subcommand (create / approve / disable)",
        getArgumentCompletions: (prefix: string) => {
            const matches = PLAN_SUBCOMMANDS.filter(s => s.value.startsWith(prefix));
            return matches.length > 0 ? matches : null;
        },
        handler: async (args, ctx) => {
            if (!args?.trim()) { enable(ctx); return; }
            const handler = subcommandHandlers[args.trim()];
            if (!handler) { ctx.ui.notify(`Unknown subcommand: ${args}`, "warning"); return; }
            handler(ctx);
        },
    });

    pi.registerShortcut(Key.ctrlAlt("p"), {
        description: "Toggle plan mode",
        handler: (ctx) => enabled ? disable(ctx, "disable") : enable(ctx),
    });

    pi.on("tool_call", (event) => {
        if (!enabled || event.toolName !== "bash") return;
        const command = event.input.command;
        if (typeof command !== "string" || !isSafe(command)) {
            return {
                block: true,
                reason: `Plan mode: blocked — not a read-only command.\n${command}`,
            };
        }
    });

    pi.on("before_agent_start", () => {
        if (!enabled || !creating) return;
        const content = skillContent ?? loadSkillContent();
        if (!content) return;
        skillContent = content;
        return { message: { customType: "plan-context", content, display: false } };
    });

    pi.on("agent_end", (event, ctx) => {
        if (!enabled || !creating || !ctx.hasUI) return;
        type Msg = { role?: string; content?: Array<{ type?: string; text?: string }> };
        const last = (event.messages as Msg[]).findLast(m => m.role === "assistant" && Array.isArray(m.content));
        if (!last?.content) { creating = false; return; }
        const text = last.content.filter(b => b.type === "text").map(b => b.text ?? "").join("\n");
        const extracted = extractPlanSteps(text);
        creating = false;
        if (extracted.length === 0) {
            ctx.ui.notify("No plan steps found — try /plan create again.", "warning");
            persistState();
            return;
        }
        steps = extracted;
        persistState();
    });

    pi.on("session_start", (_event, ctx) => {
        const entries = ctx.sessionManager.getEntries() as Array<{ type: string; customType?: string; data?: unknown }>;
        const planEntry = entries
            .filter(e => e.type === "custom" && e.customType === "plan-mode")
            .pop() as { data?: { enabled?: boolean; creating?: boolean; skillLoaded?: boolean; steps?: PlanStep[] } } | undefined;

        if (planEntry?.data) {
            enabled = planEntry.data.enabled ?? false;
            creating = planEntry.data.creating ?? false;
            steps = planEntry.data.steps ?? [];
        } else {
            enable(ctx);
            return;
        }

        if (enabled) {
            savedTools = pi.getActiveTools();
            pi.setActiveTools(savedTools.filter(t => !WRITE_TOOLS.has(t)));
            ctx.ui.setStatus("plan", "plan: enabled");
        }
    });
}
