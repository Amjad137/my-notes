## pnpm `--dir` for interactive terminal commands

**Problem:** In a pnpm workspace, running a package script from the root via `pnpm -w --filter <package> run <script>` can break interactive prompts. For example, `pnpm db:migrate` (which ran `prisma migrate dev`) would show the "Enter a name for the new migration" prompt but **stdin was not forwarded**, so the prompt hung or the command failed (e.g. in Git Bash).

**Cause:** Using `-w --filter` runs the script in a filtered workspace context; the way pnpm spawns the process can prevent stdin from reaching the child (Prisma’s interactive prompt).

**Fix:** Use `pnpm --dir <path-to-package> run <script>` instead. This runs the script **in that package’s directory** and keeps stdin attached, so interactive prompts work.

**In this repo:**
- Migration scripts that need a prompt use `--dir`:
  - `db:migrate` → `pnpm --dir packages/database run migrate`
  - `db:migrate:qa` → `pnpm --dir packages/database run migrate:qa`
  - `db:migrate:prod` → `pnpm --dir packages/database run migrate:production`
- Non-interactive DB scripts (push, studio) still use `pnpm -w --filter @repo/database run ...`; no change needed there.

**Rule of thumb:** If a script asks for input (migration name, confirmations, etc.), run it via `pnpm --dir <package-dir> run <script>` from the root instead of `pnpm -w --filter <package> run <script>`.
