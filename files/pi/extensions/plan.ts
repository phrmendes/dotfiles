import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { Key } from "@earendil-works/pi-tui";
import { readFileSync, realpathSync } from "node:fs";
import { join } from "node:path";

const WRITE_TOOLS = new Set(["edit", "write"]);

const SAFE_TOOLS = new Set([
    "cat", "head", "tail", "less", "more",
    "ls", "find", "grep", "rg", "fd",
    "wc", "sort", "uniq", "diff", "stat", "du", "df", "tree", "file", "readlink",
    "pwd", "echo", "which", "type", "cd",
    "uname", "whoami", "id", "date", "ps",
    "jq", "awk", "bat", "eza", "curl", "true", "false",
]);

const SAFE_SUBCOMMANDS: Record<string, string[]> = {
    git: ["status", "log", "diff", "show", "branch", "remote", "ls-files", "ls-tree"],
    kubectl: ["get", "describe", "logs", "top", "explain", "version", "cluster-info", "api-resources", "api-versions", "events", "auth"],
    gcloud: ["version", "info", "config", "list", "describe"],
    nix: ["eval", "search", "show-config", "path-info", "why-depends", "log", "flake", "repl"],
};

const PLAN_SKILL = readFileSync(join(realpathSync(__dirname), "..", "skills", "plan", "SKILL.md"), "utf8");

function isSafe(command: string): boolean {
    // Strip quoted strings so operators/metacharacters inside them are ignored
    const bare = command.replace(/"(?:[^"\\]|\\.)*"|'[^']*'/g, "");
    if (/[&`$()]/.test(bare)) return false;
    return bare.split(/\|\||&&|[|;]/).every(segment => {
        const [tool, sub] = segment.trim().split(/\s+/);
        if (!tool) return false;
        if (SAFE_TOOLS.has(tool)) return true;
        const allowed = SAFE_SUBCOMMANDS[tool];
        return allowed !== undefined && sub !== undefined && allowed.includes(sub);
    });
}

export default function planMode(pi: ExtensionAPI): void {
    let enabled = false;
    let savedTools: string[] | undefined;
    let skillLoaded = false;

    function enable(ctx: ExtensionContext): void {
        if (enabled) return;
        enabled = true;
        skillLoaded = false;
        savedTools = pi.getActiveTools();
        pi.setActiveTools(savedTools.filter((t) => !WRITE_TOOLS.has(t)));
        ctx.ui.setStatus("plan", "plan: enabled");
        ctx.ui.notify("Plan mode on — write tools disabled.");
    }

    function disable(ctx: ExtensionContext): void {
        if (!enabled) {
            ctx.ui.notify("Not in plan mode.", "warning");
            return;
        }
        enabled = false;
        pi.setActiveTools(savedTools ?? pi.getActiveTools());
        savedTools = undefined;
        ctx.ui.setStatus("plan", undefined);
        ctx.ui.notify("Plan approved — switching to dev mode.");
    }

    const SUBCOMMANDS = [
        { value: "create", label: "create  — ask the agent to draft the formal plan" },
        { value: "approve", label: "approve — approve the plan and begin implementation" },
        { value: "disable", label: "disable — exit plan mode without starting implementation" },
    ];

    pi.registerCommand("plan", {
        description: "Plan mode: enable, or run a subcommand (create / approve / disable)",
        getArgumentCompletions: (prefix: string) => {
            const matches = SUBCOMMANDS.filter(s => s.value.startsWith(prefix));
            return matches.length > 0 ? matches : null;
        },
        handler: async (args, ctx) => {
            switch (args?.trim()) {
                case "create":
                    if (!enabled) { ctx.ui.notify("Not in plan mode.", "warning"); return; }
                    pi.sendUserMessage("Produce the formal plan now.");
                    break;
                case "approve":
                    disable(ctx);
                    pi.sendUserMessage("The plan is approved. Begin implementation now.");
                    break;
                case "disable":
                    disable(ctx);
                    break;
                default:
                    enable(ctx);
            }
        },
    });

    pi.registerShortcut(Key.ctrlAlt("p"), {
        description: "Toggle plan mode",
        handler: async (ctx) => enabled ? disable(ctx) : enable(ctx),
    });

    pi.registerShortcut(Key.ctrl("tab"), {
        description: "Cycle between plan and dev mode",
        handler: async (ctx) => enabled ? disable(ctx) : enable(ctx),
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

    pi.on("session_start", (_event, ctx) => enable(ctx));

    pi.on("before_agent_start", () => {
        if (!enabled || skillLoaded) return;
        skillLoaded = true;
        return {
            message: {
                customType: "plan-skill",
                content: PLAN_SKILL,
                display: false,
            },
        };
    });
}
