FROM node:21-slim

RUN apt-get update && apt-get install -y curl && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY compile_page.sh /compile_page.sh
RUN chmod +x /compile_page.sh

# Install dos2unix for parsing the .sh properly
RUN apt-get update && apt-get install -y dos2unix
RUN dos2unix compile_page.sh

WORKDIR /home/user/nextjs-app

# Create Next.js app
RUN npx --yes create-next-app@15.3.3 . --yes

# Install deps
RUN npm install

# Setup shadcn
RUN npx --yes shadcn@2.6.3 init --yes -b neutral --force
RUN npx --yes shadcn@2.6.3 add --all --yes

# Install required deps for utils
RUN npm install clsx tailwind-merge

# Install animation plugin
RUN npm install tailwindcss-animate

# 🔥 Ensure /lib/utils.ts exists (important)
RUN mkdir -p ./lib && printf '%s\n' \
'import { clsx } from "clsx";' \
'import { twMerge } from "tailwind-merge";' \
'' \
'export function cn(...inputs: any[]) {' \
'  return twMerge(clsx(inputs));' \
'}' \
> ./lib/utils.ts

# 🔥 FIX BROKEN TAILWIND IMPORT
RUN find /home/user -type f -name "globals.css" -exec sed -i \
's/@import "tw-animate-css";/@plugin "tailwindcss-animate";/g' {} +

# (Optional) ensure plugin exists in config
RUN sed -i 's/plugins: \\[/plugins: [require("tailwindcss-animate"), /' tailwind.config.* || true

# Move app
RUN mv /home/user/nextjs-app/* /home/user/ && rm -rf /home/user/nextjs-app