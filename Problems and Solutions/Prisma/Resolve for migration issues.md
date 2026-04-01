# Prisma Migrate Resolve - Quick Notes

## Problem It Solves

**Scenario:** Your production database already has tables/data, but Prisma doesn't have migration history.

**Error:** `P3005 - The database schema is not empty`

**Why it happens:**
- Database was created manually or with `db push`
- Migrations were created later
- Prisma doesn't know which migrations are already applied

## How It Works

`prisma migrate resolve` marks migrations as "applied" in Prisma's tracking table (`_prisma_migrations`) **without actually running the migration SQL**.

**What it does:**
- ✅ Updates Prisma's internal migration tracking
- ✅ Does NOT modify your database structure
- ✅ Does NOT touch your data
- ✅ Only tells Prisma "this migration is already done"

**What it doesn't do:**
- ❌ Does NOT run the migration SQL
- ❌ Does NOT create/modify tables
- ❌ Does NOT change data

## How to Use

### Mark a migration as applied:
```bash
pnpm db:migrate:resolve --applied <migration-name>
```

### Example:
```bash
# Mark baseline migration as applied
pnpm db:migrate:resolve --applied 0_init

# Mark other migrations as applied
pnpm db:migrate:resolve --applied 20260201160356_add_candidate_name_to_scans
```

### Verify:
```bash
pnpm db:migrate:status:prod
# Should show: "Database schema is up to date!"
```

## When to Use

✅ **Use `migrate resolve` when:**
- Database structure **already matches** your Prisma schema
- You need to baseline an existing production database
- Migrations were created after database was set up
- **Example:** You used `db push` to create tables, then created migrations later

❌ **Don't use `migrate resolve` when:**
- Database structure **doesn't match** schema yet
- You want to **actually run** the migration SQL to make changes
- **Use `migrate deploy` instead** to apply the changes

## Critical Decision: Resolve vs Deploy

**Before using `resolve`, you MUST verify:**

1. **Check if your production DB already has the migration changes:**
   ```sql
   -- Connect to production DB and check:
   -- Does 'scan' table have 'candidateName' column?
   -- Does 'ats_scan' table have 'candidateName' column?
   -- Does 'cv' table NOT have 'candidateName' column?
   ```

2. **If YES (columns already exist in correct places):**
   - Use `migrate resolve` - just mark as applied
   - No database changes needed

3. **If NO (columns don't exist or are wrong):**
   - Use `migrate deploy` - actually run the SQL
   - This will make the changes to your database

## Important Notes

- **Safe for production** - only updates tracking, doesn't modify data
- **One-time operation** - use for initial baseline, then use `migrate deploy` for new migrations
- **Verify first** - make sure your database structure matches the schema before marking as applied

## Common Issues

**Timeout Error (P1002):**
- Wait 30-60 seconds between commands
- Verify `DIRECT_URL` is set correctly (not pooled connection)
- Retry the command

---

**TL;DR:** `migrate resolve` = "Tell Prisma this migration is done, but don't run it" (for baselining existing databases)
