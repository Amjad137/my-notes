## Blogora – Technical Submission

This document explains the project implementation against the assignment deliverables. The repository contains two apps: `blogora-api` (NestJS) and `blogora-fe` (Next.js App Router). The solution is production‑ready with strong typing, validation, logging, and CI/CD friendly scripts.

### 1) Overview

- **Goal**: A modern blog platform with user management, content authoring, and interactive features.
- **Stacks**:
  - **Backend**: NestJS 11, TypeScript, MongoDB (Mongoose), JWT, Swagger, Pino logging, class‑validator, AWS S3 client.
  - **Frontend**: Next.js 15 (App Router), React 19 RC, TypeScript, TailwindCSS, Radix/shadcn UI, TanStack Query & Table, Axios, Zustand.
- **Repo structure**:
  - `blogora-api/` – API server
  - `blogora-fe/` – Web client

### 2) Features mapping to requirements

- **User Authentication**: Register, login, logout, refresh token, get current user, change/reset password with DTO validation and guards.
- **Blog Management**: Create, edit, delete, publish posts (with draft/published states).
- **Content Features**: Image uploads supported via AWS S3 pre‑signed URLs. Rich editor on FE (implementation hooks ready; can integrate Quill/editor component).
- **User Interactions**: Likes and comments with replies (threaded comment model), optimistic UI on FE via React Query.
- **User Profiles**: Basic profile and role. Author’s posts list and analytics hooks.
- **Search & Filter**: FE table utilities provide search/sort; APIs expose list endpoints with pagination and query params.
- **Responsive Design**: Tailwind + Radix primitives; dark mode ready.
- **State Management**: Zustand for auth/table; React Query for server cache.

### 3) Local setup

#### Prerequisites

- Node.js >= 20 for API, >= 18 for FE (both tested on Node 20)
- Yarn 1.x
- MongoDB instance

#### Clone

```bash
git clone <your-repo-url>
cd NestJS
```

#### Backend (`blogora-api`)

```bash
cd blogora-api
yarn
cp .env.local .env    # or use provided env: yarn env:copy:local
yarn start:local       # dev with watch
# or
yarn build && yarn start:prod
```

Required environment variables (examples):

- `NODE_ENV=development`
- `APP_HOST=localhost`
- `APP_PORT=8000`
- `APP_GLOBAL_PREFIX=api`
- `APP_URL_VERSION_ENABLE=true`
- `APP_URL_VERSION_PREFIX=v`
- `APP_URL_VERSION=1`
- `DATABASE_URL=mongodb://localhost:27017/blogora`
- `AUTH_JWT_SECRET=supersecret`
- `AUTH_JWT_EXPIRES_IN=15m`
- `AUTH_REFRESH_COOKIE_KEY=blogora_refresh`
- `AUTH_COOKIE_SECURE=false` (true in prod)
- `AWS_REGION=ap-south-1`
- `AWS_S3_BUCKET=your-bucket`

Helpful scripts:

- `yarn test` (Jest e2e base), `yarn lint`, `yarn lint:fix`, `yarn spell`, `yarn deadcode` (ts‑prune)

#### Frontend (`blogora-fe`)

```bash
cd blogora-fe
yarn
cp .env.development .env.local    # or yarn env:copy:dev
yarn dev
```

Required environment variables:

- `NEXT_PUBLIC_API_BASE_URL=http://localhost:8000/api`
- `NEXT_PUBLIC_API_VERSION=v1`
- `NEXT_PUBLIC_S3_BUCKET_NAME=your-bucket`
- `NEXT_PUBLIC_AWS_REGION=ap-south-1`

Build/start:

```bash
yarn build && yarn start
```

### 4) Architecture

#### Backend (NestJS)

- Modular design under `src/modules` for `auth`, `user`, `post`, `comment`, `like`, `s3`, `health`, `session`.
- `@nestjs/config` driven configuration with typed DTO validation of environment in `main.ts`.
- `nestjs-pino` for structured logging; compression and cookie parsing enabled.
- API versioning via URI (`/api/v1/...`) and configurable `globalPrefix`.
- Swagger docs served at `/api/docs` in non‑production.
- MongoDB via Mongoose with schemas registered in a shared `DatabaseModule`.

#### Frontend (Next.js)

- App Router with provider composition in `src/app/layout.tsx`:
  - `ReactQueryProvider` for server cache
  - `AuthProvider` using Zustand store
  - Global `Toaster` and top route loader
- Typed DTOs and services in `src/dto` and `src/services` using Axios. Error normalization and toast feedback.
- UI system: Tailwind theme tokens, Radix primitives, reusable components under `src/components/ui`.

### 5) Authentication flow

1. User registers/logs in (`POST /v1/auth/register`, `POST /v1/auth/login`).
2. API issues access token (bearer) and sets refresh token in HTTP‑only cookie (`auth.refreshTokenCookieKey`).
3. Protected routes use `JwtAuthGuard` and `RolesGuard`.
4. FE stores minimal user profile in Zustand; bearer sent via Axios config.
5. When access token expires, FE calls `POST /v1/auth/refresh` to rotate tokens using the cookie; unauthorized responses trigger sign‑out.
6. Password flows: change (`/v1/auth/change-password`), forgot/reset with token (`/v1/auth/forgot-password`, `/v1/auth/reset-password`).

### 6) API design

- RESTful routes grouped by resource: `auth`, `users`, `posts`, `comments`, `likes`.
- Common response envelope `{ data, message, meta? }` on FE expectations; DTO classes document schemas.
- Pagination via query params (`page`, `limit`, `sort`, optional filters like author/tags). Cursor or offset styles pluggable; current implementation uses page/limit.
- Swagger/OpenAPI with tags for quick discovery; JSON is emitted to `swagger.json` during boot in dev.

### 7) Database schema (MongoDB)

- `users`: auth credentials, role, profile fields, password hash, timestamps.
- `posts`: title, content (rich), status (draft/published), author ref, tags, cover image, counts, timestamps.
- `comments`: post ref, author ref, body, parent ref (for threads), timestamps, moderation flags.
- `likes`: entity ref and user ref to support post/comment likes (implemented under `like` module).
- Indexing: ensured on common lookups like `author`, `createdAt`, and relation fields via Mongoose schema options.

### 8) File storage

- Upload flow uses AWS S3 pre‑signed URLs from API (`s3` module) and FE utility helpers to PUT files directly to S3, keeping API stateless for large payloads.
- Next.js image component permits S3 and Unsplash domains via `next.config.ts` remote patterns.

### 9) Pagination and caching

- Backend endpoints accept `page`/`limit` and sorting options.
- FE uses TanStack Query with `staleTime` defaults to cache lists and details; background refetch keeps UI fresh.

### 10) Error handling

- Backend: class‑validator ensures DTOs; centralized message service formats validation errors; guards throw `UnauthorizedException` where relevant; Pino logs request/response with correlation.
- Frontend: Axios error interceptor normalized by `ErrorHandler`, surfaced via `toast` with destructive variant for critical errors; unauthorized clears auth state.

### 11) Security hardening

- HTTP‑only refresh cookie, configurable `secure`, `sameSite`, `domain`, `maxAge`.
- Access tokens signed with configurable secret and expiry.
- CORS, Helmet, and rate limiting are wired at module level; compression enabled.
- Input validation and transformation with class‑validator/transformer; explicit DTOs prevent over‑posting.

### 12) Testing

- API includes Jest setup for e2e (`test/app.e2e-spec.ts`, `test/jest.json`), and utilities.
- Suggested scenarios: auth flows, posts CRUD, comments thread creation, like toggling, permissions enforcement.
- FE: component and integration testing can be added with Testing Library and Playwright; current focus is strong typing and runtime guards.

### 13) Deployment

- **Backend**: Dockerfile present; compatible with Railway/Render. Cloud Build YAML included for CI builds. Exposes port, reads env from platform. Start with `yarn start:prod` after `nest build`.
- **Frontend**: Next.js build ready for Vercel. Ensure envs are configured (S3 variables are required at build, as enforced in `next.config.ts`).

### 14) How to run end‑to‑end locally

1. Start MongoDB locally.
2. Configure `.env` files for API and FE as listed above.
3. In `blogora-api`, run `yarn start:local` (server at `http://localhost:8000`).
4. In `blogora-fe`, set `NEXT_PUBLIC_API_BASE_URL=http://localhost:8000/api` and run `yarn dev` (web at `http://localhost:3000`).
5. Visit API docs at `http://localhost:8000/api/docs` (non‑prod).

### 15) Notes and trade‑offs

- Chosen React 19 RC and Next.js 15 for modern features; can downgrade to stable if required by hosting constraints.
- Logging is verbose in development for observability. Replace any `console.log` statements with structured logs in production builds.
- Editor integration: UI and service hooks are ready to host a Quill/TipTap editor; integration can be swapped based on preference.

### 16) Repository hygiene

- Husky with lint‑staged, ESLint + Prettier, commitlint, cspell, ts‑prune, and typed configs across both apps.
- Scripts to bump versions and export FE `src/version.ts` on release.

— End —
