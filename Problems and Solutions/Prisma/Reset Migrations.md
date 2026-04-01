```Bash
# 1. Reset local DB first (this drops and recreates it — local data will be lost)
cd packages/database
pnpm dotenv -c -e ../../.env -- prisma migrate reset --schema=./prisma/schema.prisma

# 2. Then create the fresh migration (should work cleanly now)
pnpm dotenv -c -e ../../.env -- prisma migrate dev --name initial_schema --schema=./prisma/schema.prisma

# 3. Then apply to production
cd ../..
pnpm db:migrate:production
```