import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.registerCommand("clear", {
    description: "Clear the context by starting a new session",
    handler: async (_args, ctx) => {
      await ctx.waitForIdle();
      await ctx.newSession();
    },
  });
}
