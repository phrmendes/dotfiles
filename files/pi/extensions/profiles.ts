import type { ExtensionAPI, ToolCallEvent, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { readFileSync, existsSync } from "node:fs";
import { join } from "node:path";
import { homedir } from "node:os";

function loadProfiles(cwd: string): Record<string, string> {
    const globalPath = join(homedir(), ".pi/agent/models.json");
    const localPath = join(cwd, ".pi/models.json");

    let profiles: Record<string, string> = {};

    if (existsSync(globalPath)) {
        try {
            const global = JSON.parse(readFileSync(globalPath, "utf-8"));
            Object.assign(profiles, global.profiles ?? {});
        } catch (e) {
            console.warn("profiles: failed to parse global models.json:", e);
        }
    }

    if (existsSync(localPath)) {
        try {
            const local = JSON.parse(readFileSync(localPath, "utf-8"));
            Object.assign(profiles, local.profiles ?? {});
        } catch (e) {
            console.warn("profiles: failed to parse local models.json:", e);
        }
    }

    return profiles;
}

export default function(pi: ExtensionAPI) {
    const profiles = loadProfiles(process.cwd());

    pi.on("tool_call", async (event: ToolCallEvent, ctx: ExtensionContext) => {
        if (event.toolName !== "read") return;
        const path = (event.input as { path?: string })?.path ?? "";
        for (const [profile, model] of Object.entries(profiles)) {
            if (path.includes("/skills/" + profile + "/SKILL.md")) {
                pi.setModel(model);
                ctx.ui.notify(profile + " -> " + model, "info");
                break;
            }
        }
    });
}
