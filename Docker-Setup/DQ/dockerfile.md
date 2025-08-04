# ---- Base image with pnpm enabled ----
FROM node:22-slim AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

# ---- Dependencies: install only production deps ----
FROM base AS prod-deps
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
# Use BuildKit cache for pnpm store (if supported)
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --prod --frozen-lockfile --ignore-scripts

# ---- Build: install all deps and build the app ----
FROM base AS build
WORKDIR /app
COPY . .
# Use BuildKit cache for pnpm store (if supported)
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile
RUN pnpm build

# ---- Production image: copy only necessary files ----
FROM base AS runner
WORKDIR /app
ENV NODE_ENV=production
ARG DATABASE_URL
ARG BETTER_AUTH_SECRET
ARG RESEND_API_KEY
ARG NCLOUD_ACCESS_KEY_ID
ARG NCLOUD_SECRET_ACCESS_KEY

ENV DATABASE_URL=$DATABASE_URL
ENV BETTER_AUTH_SECRET=$BETTER_AUTH_SECRET
ENV RESEND_API_KEY=$RESEND_API_KEY
ENV NCLOUD_ACCESS_KEY_ID=$NCLOUD_ACCESS_KEY_ID
ENV NCLOUD_SECRET_ACCESS_KEY=$NCLOUD_SECRET_ACCESS_KEY

# Copy production node_modules
COPY --from=prod-deps /app/node_modules ./node_modules
# Copy built Next.js output and public assets
COPY --from=build /app/.next ./.next
COPY --from=build /app/public ./public
COPY --from=build /app/package.json ./package.json
# Copy next.config.js if present
COPY --from=build /app/next.config.js ./next.config.js

EXPOSE 5173

CMD ["pnpm", "start", "--", "-p", "5173"]