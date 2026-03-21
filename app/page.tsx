import { caller } from "@/trpc/server";

const Page = async () => {
  const data = await caller.createAI({ text: "hi" });
  return <div className="font-bold">{JSON.stringify(data)}</div>;
};

export default Page;
