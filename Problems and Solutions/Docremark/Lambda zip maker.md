```Bash
set -e

# 1) Build the Lambda bundle
pnpm --filter @repo/api-app build:lambda

# 2) Stage deploy artifacts
cd apps/api
rm -rf lambda-deploy lambda-deployment.zip
mkdir -p lambda-deploy/node_modules

# 3) Copy compiled output and package manifest
cp dist/index.js lambda-deploy/
cp package.json lambda-deploy/

# 4) Install prod deps for Lambda runtime (Amazon Linux x64)
cd lambda-deploy
pnpm install --prod --no-frozen-lockfile

# 5) Include Prisma engines and client
cp -R ../node_modules/.prisma node_modules/
cp -R ../node_modules/@prisma node_modules/

# 6) Zip it up
zip -r ../lambda-deployment.zip .

# 7) Return to repo root
cd ../..
```

```Powershell
Compress-Archive -Path "apps/api/lambda-deploy/*" -DestinationPath "apps/api/lambda-deployment.zip" -Force
```