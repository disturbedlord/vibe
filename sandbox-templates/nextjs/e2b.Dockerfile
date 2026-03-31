FROM node:21-slim

RUN apt-get update && apt-get install -y curl && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY compile_page.sh /compile_page.sh
RUN chmod +x /compile_page.sh

WORKDIR /home/user/nextjs-app

# Create Next.js app
RUN npx --yes create-next-app@15.3.3 . --yes

# Install deps
RUN npm install

# Setup shadcn
RUN npx --yes shadcn@2.6.3 init --yes -b neutral --force
RUN npx --yes shadcn@2.6.3 add --all --yes

# Install animation plugin
RUN npm install tailwindcss-animate

# 🔥 FIX BROKEN IMPORT (critical)
RUN find /home/user -type f -name "globals.css" -exec sed -i \
's/@import "tw-animate-css";/@plugin "tailwindcss-animate";/g' {} +

# (Optional) ensure plugin exists in config (mostly unnecessary in v4)
RUN sed -i 's/plugins: \\[/plugins: [require("tailwindcss-animate"), /' tailwind.config.* || true

# Move app
RUN mv /home/user/nextjs-app/* /home/user/ && rm -rf /home/user/nextjs-app