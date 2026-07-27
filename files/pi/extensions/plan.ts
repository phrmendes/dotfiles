import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { Key } from "@earendil-works/pi-tui";
import { appendFileSync, readFileSync, realpathSync } from "node:fs";
import { join } from "node:path";
import { parse as parseShell } from "shell-quote";
import { marked } from "marked";

let PLAN_SKILL: string;
try {
    PLAN_SKILL = readFileSync(join(realpathSync(__dirname), "..", "skills", "plan", "SKILL.md"), "utf8");
} catch (err) {
    throw new Error(`plan extension: could not load SKILL.md — ${err}`);
}
const WRITE_TOOLS = new Set(["edit", "write"]);

const SAFE_TOOLS = new Set(["awk", "bat", "cat", "cd", "curl", "date", "df", "diff", "du", "echo", "eza", "false", "fd", "file", "find", "grep", "head", "id", "jira", "jq", "less", "ls", "more", "ps", "pwd", "readlink", "rg", "sort", "stat", "tail", "tree", "true", "type", "uname", "uniq", "wc", "which", "whoami", "xargs"]);

const SAFE_SUBCOMMANDS: Record<string, string[]> = {
    git: ["status", "log", "diff", "show", "branch", "remote", "ls-files", "ls-tree"],
    kubectl: ["get", "describe", "logs", "top", "explain", "version", "cluster-info", "api-resources", "api-versions", "events", "auth", "config", "diff", "rollout"],
    gcloud: ["version", "info", "config", "list", "describe"],
    nix: ["eval", "search", "show-config", "path-info", "why-depends", "log", "flake", "repl"],
};

const PLAN_SUBCOMMANDS = [
    { value: "create", label: "create — ask the agent to draft the formal plan" },
    { value: "approve", label: "approve — approve the plan and begin implementation" },
    { value: "disable", label: "disable — exit plan mode without starting implementation" },
    { value: "save", label: "save — export current plan to todo.txt" },
];

const CHAIN_OPS = new Set(["|", "||", "&&", ";"]);
const BLOCK_OPS = new Set(["&", ">&", "<&", "<(", ">", ">>"]);

/**
 * Returns true if the first word of a shell segment is an allowed read-only
 * command, or an allowed subcommand of a known tool (e.g. `git status`).
 */
function isCommandSafe(words: string[]): boolean {
    const [cmd, sub] = words;
    if (!cmd) return false;
    if (SAFE_TOOLS.has(cmd)) return true;
    const allowed = SAFE_SUBCOMMANDS[cmd];
    return allowed != null && sub != null && allowed.includes(sub);
}

/**
 * Returns true if every segment of a shell command is safe to run in plan mode.
 *
 * Operator behaviour:
 * - Backtick substitution: blocked before tokenisation (shell-quote does not flag it)
 * - {@link BLOCK_OPS} — `&`, `>&`, `<&`, `<(`, `>`, `>>`: immediately blocked
 * - {@link CHAIN_OPS} — `|`, `||`, `&&`, `;`: split into independently checked segments
 * - Read redirect `<` and glob patterns: passed through
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

interface PlanStep {
    step: number;
    text: string;
}

/**
 * Extracts the title from a plan step list item.
 * Handles the `**Title** — description` format produced by the plan skill,
 * falling back to the text before ` —` for non-bold items.
 */
function extractBoldTitle(text: string): string | null {
    if (text.startsWith("**")) {
        const close = text.indexOf("**", 2);
        if (close > 2) return text.slice(2, close).trim();
    }
    const fallback = text.split(" —")[0].trim();
    return fallback.length > 0 ? fallback : null;
}

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

function formatTodoTxt(steps: PlanStep[], taskId: string, date: string): string {
    return steps
        .map(s => `${date} ${s.text} +plan id:${taskId}-step${s.step} status:planning parent:${taskId}`)
        .join("\n");
}

export default function planMode(pi: ExtensionAPI): void {
    let enabled = false;
    let steps: PlanStep[] = [];
    let savedTools: string[] | undefined;
    let skillLoaded = false;
    let creating = false;

    function today(): string {
        return new Date().toISOString().slice(0, 10);
    }

    function persistState(): void {
        pi.appendEntry("plan-mode", { enabled, creating, skillLoaded, steps });
    }

    function updateStatus(ctx: ExtensionContext): void {
        if (enabled) {
            ctx.ui.setStatus("plan", "plan: enabled");
        } else {
            ctx.ui.setStatus("plan", undefined);
        }
    }

    async function enable(ctx: ExtensionContext): Promise<void> {
        if (enabled) return;
        enabled = true;
        creating = false;
        skillLoaded = false;
        steps = [];
        savedTools = pi.getActiveTools();
        pi.setActiveTools(savedTools.filter(t => !WRITE_TOOLS.has(t)));
        updateStatus(ctx);
        ctx.ui.notify("Plan mode on — write tools disabled.");
        persistState();
    }

    async function disable(ctx: ExtensionContext, reason: "approve" | "disable" = "disable"): Promise<void> {
        if (!enabled) {
            ctx.ui.notify("Not in plan mode.", "warning");
            return;
        }
        enabled = false;
        creating = false;
        steps = [];
        pi.setActiveTools(savedTools ?? pi.getActiveTools());
        savedTools = undefined;
        updateStatus(ctx);
        ctx.ui.notify(reason === "approve"
            ? "Plan approved — switching to dev mode."
            : "Plan mode disabled.");
        persistState();
    }

    pi.registerCommand("plan", {
        description: "Plan mode: enable, or run a subcommand (create / approve / disable / save)",
        getArgumentCompletions: (prefix: string) => {
            const matches = PLAN_SUBCOMMANDS.filter(s => s.value.startsWith(prefix));
            return matches.length > 0 ? matches : null;
        },
        handler: async (args, ctx) => {
            switch (args?.trim()) {
                case "create":
                    if (!enabled) { ctx.ui.notify("Not in plan mode.", "warning"); return; }
                    creating = true;
                    pi.sendUserMessage("Produce the formal plan now.");
                    break;
                case "approve":
                    if (steps.length === 0) {
                        ctx.ui.notify("No plan to approve — run /plan create first.", "warning");
                        return;
                    }
                    await disable(ctx, "approve");
                    pi.sendUserMessage("The plan is approved. Begin implementation now.");
                    break;
                case "disable":
                    await disable(ctx, "disable");
                    break;
                case "save":
                    if (steps.length === 0) { ctx.ui.notify("No plan to save.", "warning"); return; }
                    try {
                        const txt = formatTodoTxt(steps, `plan-${today()}`, today());
                        appendFileSync(join(ctx.cwd, "todo.txt"), "\n" + txt + "\n", "utf-8");
                        ctx.ui.notify(`Plan saved to todo.txt (${steps.length} steps).`, "info");
                    } catch (err) {
                        ctx.ui.notify(`Failed to save plan: ${err}`, "error");
                    }
                    break;
                default:
                    await enable(ctx);
            }
        },
    });

    pi.registerShortcut(Key.ctrlAlt("p"), {
        description: "Toggle plan mode",
        handler: async (ctx) => enabled ? await disable(ctx) : await enable(ctx),
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
        if (!enabled || skillLoaded) return;
        skillLoaded = true;
        return { message: { customType: "plan-context", content: PLAN_SKILL, display: false } };
    });

    pi.on("agent_end", async (event, ctx) => {
        if (!enabled || !creating || !ctx.hasUI) return;
        type Msg = { role?: string; content?: Array<{ type?: string; text?: string }> };
        const last = (event.messages as Msg[]).findLast(m => m.role === "assistant" && Array.isArray(m.content));
        if (!last?.content) return;
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

    pi.on("session_start", async (_event, ctx) => {
        const entries = ctx.sessionManager.getEntries() as Array<{ type: string; customType?: string; data?: unknown }>;
        const planEntry = entries
            .filter(e => e.type === "custom" && e.customType === "plan-mode")
            .pop() as { data?: { enabled?: boolean; creating?: boolean; skillLoaded?: boolean; steps?: PlanStep[] } } | undefined;

        if (planEntry?.data) {
            enabled = planEntry.data.enabled ?? false;
            creating = planEntry.data.creating ?? false;
            skillLoaded = planEntry.data.skillLoaded ?? false;
            steps = planEntry.data.steps ?? [];
        } else {
            await enable(ctx);
            return;
        }

        if (enabled) {
            savedTools = pi.getActiveTools();
            pi.setActiveTools(savedTools.filter(t => !WRITE_TOOLS.has(t)));
        }
        updateStatus(ctx);
    });
}
