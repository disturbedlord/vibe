import { createTRPCRouter } from "../init";
import { messageRouter } from "@/modules/message/server/procedures";

export const appRouter = createTRPCRouter({
  messages: messageRouter,
});
// export type definition of API
export type AppRouter = typeof appRouter;
