import { Agent, openai, createAgent } from "@inngest/agent-kit";
import { inngest } from "./client";
import { Sandbox } from "@e2b/code-interpreter";
import { getSandbox } from "./utils";

export const helloWorld = inngest.createFunction(
  { id: "hello-world", triggers: [{ event: "test/hello.world" }] },
  async ({ event, step }) => {
    const sandboxId = await step.run("get-sandbox-id", async () => {
      const sandbox = await Sandbox.create(
        "todisturbedlord/vibe-nextjs-test-1-avi",
      );
      return sandbox.sandboxId;
    });

    const codeAgent = createAgent({
      name: "code-agent",
      system:
        "You are an expert next.js developer. You write readable,maintainable code.You write simple next.js & react snippets. IMPORTANT !!! do not give any additional text apart from code",
      model: openai({ model: "gpt-4o" }),
    });

    const { output } = await codeAgent.run(
      `Write the following snippets: ${event.data.value}`,
    );

    const sandboxUrl = await step.run("get-sandbox-url", async () => {
      const sandbox = await getSandbox(sandboxId);
      const host = sandbox.getHost(3000);

      return `https://${host}`;
    });

    const finalResult = await step.run("final-result", async () => {
      return {
        output,
        sandboxUrl,
      };
    });

    return finalResult;
  },
);
