"use client";

import { useTRPC } from "@/trpc/client";
import { Button } from "@base-ui/react";
import { useMutation } from "@tanstack/react-query";
import { toast } from "sonner";

const Page = () => {
  const trpc = useTRPC();
  const invoke = useMutation(
    trpc.invoke.mutationOptions({
      onSuccess: () => {
        toast.success("Background job started");
      },
    }),
  );
  return (
    <div className="p-4 max-w-7xl mx-auto">
      <Button
        disabled={invoke.isPending}
        onClick={() => invoke.mutate({ text: "John" })}
        className="font-bold text-white bg-black p-4 rounded-2xl"
      >
        Invoke Background Job
      </Button>
    </div>
  );
};

export default Page;
