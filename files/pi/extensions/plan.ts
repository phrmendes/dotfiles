import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { Key } from "@earendil-works/pi-tui";
import { appendFileSync, readFileSync, realpathSync } from "node:fs";
import { join } from "node:path";

const PLAN_SKILL = readFileSync(join(realpathSync(__dirname), "..", "skills", "plan", "SKILL.md"), "utf8");
const WRITE_TOOLS = new Set(["edit", "write"]);
const CHAIN_OPERATORS = /\|\||&&|[|;\n]/;
const QUOTED_STRING = /"(?:[^"\\]|\\.)*"|'[^']*'/g;
const SHELL_METACHARS = /[&`$()]/;

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

const REDIRECT_MERGE = /[12]>&[12]\b/g;
const DEFAULT_PLAN_MODEL = process.env.PLAN_MODEL ?? "anthropic/claude-haiku-4-5";

function isSegmentSafe(segment: string): boolean {
    const [tool, subcommand] = segment.trim().split(/\s+/);
    if (!tool) return false;
    if (SAFE_TOOLS.has(tool)) return true;
    const allowed = SAFE_SUBCOMMANDS[tool];
    return allowed !== undefined && subcommand !== undefined && allowed.includes(subcommand);
}

function isSafe(command: string): boolean {
    const unquoted = command.replace(QUOTED_STRING, "").replace(REDIRECT_MERGE, "");
    return unquoted.split(CHAIN_OPERATORS).every(segment =>
        !SHELL_METACHARS.test(segment) && isSegmentSafe(segment)
    );
}

interface PlanStep {
    step: number;
    text: string;
    completed: boolean;
}

function extractPlanSteps(message: string): PlanStep[] {
    const items: PlanStep[] = [];
    const headerMatch = message.match(/\*{0,2}Plan:\*{0,2}\s*\n/i);
    if (!headerMatch) return items;
    const planSection = message.slice(message.indexOf(headerMatch[0]) + headerMatch[0].length);
    const numberedPattern = /^\s*(\d+)[.)]\s+\*{0,2}([^*\n]+)/gm;
    for (const match of planSection.matchAll(numberedPattern)) {
        const text = match[2].trim().replace(/\*{1,2}$/, "").trim();
        if (text.length > 3) items.push({ step: items.length + 1, text, completed: false });
    }
    return items;
}

function extractDoneSteps(text: string): number[] {
    return [...text.matchAll(/\[DONE:(\d+)\]/gi)].map(m => Number(m[1])).filter(n => Number.isFinite(n));
}

function markCompletedSteps(text: string, steps: PlanStep[]): number {
    const doneSteps = extractDoneSteps(text);
    let count = 0;
    for (const step of doneSteps) {
        const item = steps.find(t => t.step === step);
        if (item && !item.completed) { item.completed = true; count++; }
    }
    return count;
}

function formatTodoTxt(steps: PlanStep[], taskId: string, date: string): string {
    return steps
        .map(s => {
            const prefix = s.completed ? `x ${date} ` : "";
            return `${prefix}${date} ${s.text} +plan id:${taskId}-step${s.step} status:planning parent:${taskId}`;
        })
        .join("\n");
}

export default function planMode(pi: ExtensionAPI): void {
    let enabled = false;
    let executing = false;
    let steps: PlanStep[] = [];
    let savedTools: string[] | undefined;
    let savedModel: { provider: string; id: string } | undefined;
    let savedThinkingLevel: string | undefined;
    let skillLoaded = false;

    function today(): string {
        return new Date().toISOString().slice(0, 10);
    }

    function persistState(): void {
        pi.appendEntry("plan-mode", { enabled, executing, steps });
    }

    function updateStatus(ctx: ExtensionContext): void {
        if (executing && steps.length > 0) {
            ctx.ui.setStatus("plan", `plan: ${steps.filter(s => s.completed).length}/${steps.length}`);
        } else if (enabled) {
            ctx.ui.setStatus("plan", "plan: enabled");
        } else {
            ctx.ui.setStatus("plan", undefined);
        }
    }

    async function switchToPlanModel(ctx: ExtensionContext): Promise<void> {
        const [provider, modelId] = DEFAULT_PLAN_MODEL.split("/");
        if (!provider || !modelId) return;
        const planModel = ctx.modelRegistry.find(provider, modelId);
        if (!planModel) return;
        if (ctx.model) {
            savedModel = { provider: ctx.model.provider, id: ctx.model.id };
        }
        savedThinkingLevel = pi.getThinkingLevel();
        await pi.setModel(planModel);
    }

    async function restoreModel(ctx: ExtensionContext): Promise<void> {
        if (savedModel) {
            const model = ctx.modelRegistry.find(savedModel.provider, savedModel.id);
            if (model) await pi.setModel(model);
            savedModel = undefined;
        }
        if (savedThinkingLevel) {
            pi.setThinkingLevel(savedThinkingLevel as "off" | "minimal" | "low" | "medium" | "high" | "xhigh" | "max");
            savedThinkingLevel = undefined;
        }
    }

    async function enable(ctx: ExtensionContext): Promise<void> {
        if (enabled) return;
        enabled = true;
        executing = false;
        skillLoaded = false;
        steps = [];
        savedTools = pi.getActiveTools();
        pi.setActiveTools(savedTools.filter(t => !WRITE_TOOLS.has(t)));
        await switchToPlanModel(ctx);
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
        executing = false;
        steps = [];
        pi.setActiveTools(savedTools ?? pi.getActiveTools());
        savedTools = undefined;
        await restoreModel(ctx);
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
                    pi.sendUserMessage("Produce the formal plan now.");
                    break;
                case "approve":
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

    pi.registerShortcut(Key.ctrl("tab"), {
        description: "Cycle between plan and dev mode",
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

    pi.on("turn_end", async (event, ctx) => {
        if (!executing || steps.length === 0) return;
        const msg = event.message as { role?: string; content?: Array<{ type?: string; text?: string }> };
        if (msg.role !== "assistant" || !Array.isArray(msg.content)) return;

        const text = msg.content.filter(b => b.type === "text").map(b => b.text ?? "").join("\n");
        const completed = markCompletedSteps(text, steps);
        if (completed > 0) updateStatus(ctx);
        persistState();
    });

    pi.on("agent_end", async (event, ctx) => {
        if (executing && steps.length > 0 && steps.every(s => s.completed)) {
            executing = false;
            steps = [];
            updateStatus(ctx);
            persistState();
            return;
        }

        if (!enabled || executing || !ctx.hasUI) return;
        const msgs = event.messages as Array<{ role?: string; content?: Array<{ type?: string; text?: string }> }>;
        const last = msgs.reverse().find(m => m.role === "assistant" && Array.isArray(m.content));
        if (!last?.content) return;
        const text = last.content.filter(b => b.type === "text").map(b => b.text ?? "").join("\n");
        const extracted = extractPlanSteps(text);
        if (extracted.length === 0) return;
        steps = extracted;
        persistState();
    });

    pi.on("session_start", async (_event, ctx) => {
        const entries = ctx.sessionManager.getEntries() as Array<{ type: string; customType?: string; data?: unknown }>;
        const planEntry = entries
            .filter(e => e.type === "custom" && e.customType === "plan-mode")
            .pop() as { data?: { enabled?: boolean; executing?: boolean; steps?: PlanStep[] } } | undefined;

        if (planEntry?.data) {
            enabled = planEntry.data.enabled ?? false;
            executing = planEntry.data.executing ?? false;
            steps = planEntry.data.steps ?? [];
        } else {
            await enable(ctx);
            return;
        }

        if (executing && steps.length > 0) {
            let execIdx = -1;
            for (let i = entries.length - 1; i >= 0; i--) {
                if (entries[i].customType === "plan-execute") { execIdx = i; break; }
            }
            let text = "";
            for (let i = execIdx + 1; i < entries.length; i++) {
                const e = entries[i] as Record<string, unknown>;
                if (e.type === "message" && e.message) {
                    const m = e.message as { role?: string; content?: Array<{ type?: string; text?: string }> };
                    if (m.role === "assistant" && Array.isArray(m.content)) {
                        text += m.content.filter(b => b.type === "text").map(b => b.text ?? "").join("\n") + "\n";
                    }
                }
            }
            markCompletedSteps(text, steps);
        }

        if (enabled) {
            savedTools = pi.getActiveTools();
            pi.setActiveTools(savedTools.filter(t => !WRITE_TOOLS.has(t)));
        }
        updateStatus(ctx);
    });
}
