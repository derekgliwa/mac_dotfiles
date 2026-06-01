import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { writeFileSync } from "node:fs";
import { join } from "node:path";

const CONVERSE_SYSTEM = `
You are in CONVERSE mode — a brainstorming and thinking partner.
You can use web_search and fetch_content to research ideas and explore approaches.
Do NOT write code, run commands, or edit files.
Your job is to ask clarifying questions, explore the problem space,
surface assumptions, suggest approaches, and help the user think.
When the user is ready to commit, they can type /go.
`;

const CONVERSE_TOOLS = ["read", "grep", "find", "ls", "web_search", "fetch_content"];

export default function (pi: ExtensionAPI) {
  let conversing = false;
  let activeToolNames: string[] = [];
  let converseStartEntryId: string | null = null;

  const formatForSave = (entries: any[], startId: string): string => {
    const blocks: string[] = [`# Brainstorm Session — ${new Date().toISOString().slice(0, 10)}\n`];
    let started = false;

    for (const entry of entries) {
      if (entry.id === startId) {
        started = true;
        continue;
      }
      if (!started) continue;
      if (entry.type === "message" && entry.role === "user") {
        const text = entry.content?.map((c: any) => c.text || "").join(" ") || "";
        blocks.push(`## You\n\n${text}\n`);
      } else if (entry.type === "message" && entry.role === "assistant") {
        const text = entry.content?.map((c: any) => c.text || "").join(" ") || "";
        blocks.push(`## Assistant\n\n${text}\n`);
      }
    }

    return blocks.join("\n---\n\n");
  };

  const setConverseMode = (on: boolean, notify: (msg: string, level?: string) => void) => {
    conversing = on;
    if (on) {
      activeToolNames = pi.getAllTools().map((t) => t.name);
      pi.setActiveTools(CONVERSE_TOOLS);
      notify("Converse mode on — think + research. Use /go to resume.", "info");
    } else {
      pi.setActiveTools(activeToolNames);
      activeToolNames = [];
      notify("Converse mode off — tools restored.", "info");
    }
  };

  pi.registerCommand("converse", {
    description: "Enter brainstorm mode — think and research before coding",
    handler: async (args, ctx) => {
      converseStartEntryId = ctx.sessionManager.getLeafId();
      setConverseMode(true, ctx.ui.notify);
      if (args) {
        await ctx.sendMessage(args);
      }
    },
  });

  pi.registerCommand("go", {
    description: "Exit converse mode, optionally save brainstorm, restore tools",
    handler: async (args, ctx) => {
      setConverseMode(false, ctx.ui.notify);

      // Ask if they want to save the brainstorm conversation
      if (converseStartEntryId && ctx.hasUI) {
        const shouldSave = await ctx.ui.confirm(
          "Save brainstorm?",
          "Write a summary of this conversation to a file?"
        );
        if (shouldSave) {
          const filename = await ctx.ui.input(
            "Filename",
            "Path for brainstorm notes (relative to cwd)",
            `BRAINSTORM-${new Date().toISOString().slice(0, 10)}.md`
          );
          if (filename) {
            const entries = ctx.sessionManager.getEntries();
            const body = formatForSave(entries, converseStartEntryId);
            const filePath = join(ctx.cwd, filename);
            writeFileSync(filePath, body, "utf-8");
            ctx.ui.notify(`Brainstorm saved to ${filename}`, "success");
          }
        }
      }

      converseStartEntryId = null;

      if (args) {
        await ctx.sendMessage(args);
      }
    },
  });

  pi.on("before_agent_start", async (event, ctx) => {
    if (conversing) {
      return { systemPrompt: CONVERSE_SYSTEM };
    }
  });

  pi.registerShortcut("ctrl+shift+b", {
    description: "Toggle converse/brainstorm mode",
    handler: async (ctx) => {
      if (!conversing) {
        converseStartEntryId = ctx.sessionManager.getLeafId();
      }
      setConverseMode(!conversing, ctx.ui.notify);
    },
  });
}
