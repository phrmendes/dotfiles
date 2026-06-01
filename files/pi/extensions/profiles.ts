import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
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
        } catch { }
    }

    if (existsSync(localPath)) {
        try {
            const local = JSON.parse(readFileSync(localPath, "utf-8"));
            Object.assign(profiles, local.profiles ?? {});
        } catch { }
    }

    return profiles;
}

export default function(pi: ExtensionAPI) {
    const profiles = loadProfiles(process.cwd());

    pi.on("tool_call", async (event, ctx) => {
        if (event.toolName !== "read") return;
        const path = (event.input as { filePath?: string })?.filePath ?? "";
        for (const [profile, model] of Object.entries(profiles)) {
            if (path.includes("/skills/" + profile + "/SKILL.md")) {
                pi.setModel(model);
                ctx.ui.notify(profile + " -> " + model, "info");
                break;
            }
        }
    });
}
