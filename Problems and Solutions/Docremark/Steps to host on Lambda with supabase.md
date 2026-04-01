
---

## **Alternative to `node:crypto` for Lambda**

Use **`@noble/hashes`** - a pure JavaScript crypto library that works in Lambda:

```bash
pnpm add @noble/hashes --filter @repo/payments
```

**Why @noble/hashes:**
- ✅ Works in Lambda (no Node.js dependencies)
- ✅ Drop-in replacement for HMAC operations
- ✅ Constant-time comparison (safe)
- ✅ Smaller bundle size than node:crypto polyfills

---

## **Exact Steps to Deploy YOUR App on Lambda**

### **STEP 1: Fix Webhook Signature Verification**

**File: index.ts**

Replace:
```typescript
import { createHmac } from "node:crypto";
```

With:
```typescript
import { hmac } from '@noble/hashes/hmac';
import { sha256 } from '@noble/hashes/sha256';

function createHmac(algorithm: string, secret: string): {
  update: (data: string) => { digest: (encoding: string) => string };
} {
  return {
    update: (data: string) => ({
      digest: (encoding: string) => {
        const secretBytes = new TextEncoder().encode(secret);
        const dataBytes = new TextEncoder().encode(data);
        const hash = hmac(sha256, secretBytes, dataBytes);
        return Array.from(hash).map(b => b.toString(16).padStart(2, '0')).join('');
      }
    })
  };
}
```

**File: index.ts**

Replace:
```typescript
import { createHmac, timingSafeEqual } from "node:crypto";
```

With:
```typescript
import { hmac } from '@noble/hashes/hmac';
import { sha256 } from '@noble/hashes/sha256';

function createHmac(algorithm: string, secret: string): {
  update: (data: string) => { digest: (encoding: string) => Buffer };
} {
  return {
    update: (data: string) => ({
      digest: (encoding: string) => {
        const secretBytes = new TextEncoder().encode(secret);
        const dataBytes = new TextEncoder().encode(data);
        const hash = hmac(sha256, secretBytes, dataBytes);
        const hex = Array.from(hash).map(b => b.toString(16).padStart(2, '0')).join('');
        return Buffer.from(hex, 'utf8');
      }
    })
  };
}

function timingSafeEqual(a: Buffer, b: Buffer): boolean {
  if (a.length !== b.length) return false;
  let result = 0;
  for (let i = 0; i < a.length; i++) {
    result |= a[i] ^ b[i];
  }
  return result === 0;
}
```

---

### **STEP 2: Configure Prisma for Lambda**

**Option A: Use Supabase Connection Pooler (FREE)**

1. Get pooler URL from Supabase dashboard:
   - Go to: Project Settings → Database → Connection Pooling
   - Copy "Transaction" mode URL

2. Update .env.local:
```bash
# Replace:
DATABASE_URL="postgresql://postgres:Test@123@localhost:5432/test"

# With pooler URL (port 6543):
DATABASE_URL="postgresql://postgres.[PROJECT-REF].supabase.co:6543/postgres?pgbouncer=true"
DIRECT_URL="postgresql://postgres.[PROJECT-REF].supabase.co:5432/postgres"
```

3. Update schema.prisma:
```prisma
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
  directUrl = env("DIRECT_URL")  # Add this for migrations
}

generator client {
  provider = "prisma-client-js"
  engineType = "library"  # Changed from "binary"
}
```

4. Regenerate Prisma Client:
```bash
cd packages/database
pnpm prisma generate
```

---

### **STEP 3: Create Lambda Handler**

**Install adapter:**
```bash
pnpm add @hono/aws-lambda --filter @repo/api-app
```

**Create `apps/api/src/lambda.ts`:**
```typescript
import { handle } from '@hono/aws-lambda';
import { app } from '@repo/api';

export const handler = handle(app);
```

---

### **STEP 4: Update Build Configuration**

**File: package.json**

Add build script:
```json
{
  "scripts": {
    "build": "esbuild ./src/index.ts --bundle --platform=node --outfile=dist/index.js",
    "build:lambda": "esbuild ./src/lambda.ts --bundle --platform=node --target=node20 --outfile=dist/lambda.js --minify --external:@prisma/client --external:.prisma/client",
    "dev": "tsx --env-file=../../.env.local src/index.ts --watch",
    "start": "node dist/index.js",
    "type-check": "tsc --noEmit"
  }
}
```

---

### **STEP 5: Build Lambda Package**

```bash
# From root
cd apps/api

# Build Lambda handler
pnpm run build:lambda

# Create deployment package
mkdir -p lambda-package
cp dist/lambda.js lambda-package/

# Copy Prisma files (CRITICAL - Lambda needs these)
cp -r ../../node_modules/.prisma lambda-package/
cp -r ../../node_modules/@prisma lambda-package/node_modules/

# Create zip
cd lambda-package
zip -r ../lambda-deployment.zip .
cd ..
```

---

### **STEP 6: Create Lambda Function in AWS**

**AWS Console:**

1. **Create Function:**
   - Name: `docremark-api`
   - Runtime: Node.js 20.x
   - Architecture: x86_64
   - Memory: 2048 MB
   - Timeout: 30 seconds

2. **Upload Code:**
   - Upload `lambda-deployment.zip`

3. **Set Handler:**
   - Handler: `lambda.handler`

4. **Environment Variables** (exact from your .env.local):
```bash
DATABASE_URL=postgresql://postgres.[REF].supabase.co:6543/postgres?pgbouncer=true
DIRECT_URL=postgresql://postgres.[REF].supabase.co:5432/postgres
BETTER_AUTH_SECRET=
BETTER_AUTH_URL=https://your-frontend.com
CREEM_API_KEY=creem_test_6sYwhDkLRdPgUlLZhwfbr1
CREEM_WEBHOOK_SECRET=whsec_5QRrPd7D7Is035n84U6Xie
CREEM_USE_PRODUCTION_API=false
RESEND_API_KEY=
R2_ACCOUNT_ID=
R2_ACCESS_KEY_ID=
R2_SECRET_ACCESS_KEY=
BUCKET_NAME=my-object-storage
PRODUCT_ID_BASIC_MONTHLY=prod_SdpgrVztzz5p9bSwmEMmX
PRODUCT_ID_BASIC_YEARLY=prod_25Xasne8PGvBAFHWUPJtI2
PRODUCT_ID_PRO_MONTHLY=prod_31BdrixhC5KeyisWfdUjSf
PRODUCT_ID_PRO_YEARLY=prod_4JtpiNyd7XOl5GN4BinT2E
PRODUCT_ID_DOCTOR_ADDON_MONTHLY=prod_5Q8vjFoflBOwPkUPvRyyyU
PRODUCT_ID_DOCTOR_ADDON_YEARLY=prod_1M0DAn84e68qkPa4ldyLvR
LOG_LEVEL=5
NODE_ENV=production
NEXT_PUBLIC_SITE_URL=https://your-frontend.com
NEXT_PUBLIC_EXTERNAL_URLS=https://your-frontend.com
```

---

### **STEP 7: Create API Gateway**

1. **Create REST API:**
   - Name: `docremark-api-gateway`
   - Type: Regional

2. **Create Resource:**
   - Path: `/api/{proxy+}`
   - Enable CORS

3. **Create Method:**
   - Method: ANY
   - Integration: Lambda Function
   - Lambda: `docremark-api`
   - Use Lambda Proxy Integration: ✅

4. **Deploy API:**
   - Stage name: `prod`
   - Get URL: `https://[API-ID].execute-api.[REGION].amazonaws.com/prod`

---

### **STEP 8: Update Frontend**

**File: .env.local (or Amplify env vars):**
```bash
NEXT_PUBLIC_API_URL=https://[API-ID].execute-api.[REGION].amazonaws.com/prod/api
```

---

### **STEP 9: Test**

```bash
# Health check
curl https://[API-ID].execute-api.[REGION].amazonaws.com/prod/api/health

# Should return: {"status":"ok"}
```

---

## **Deployment Checklist:**

- [ ] Install `@noble/hashes` in payments package
- [ ] Replace `node:crypto` in index.ts
- [ ] Replace `node:crypto` in index.ts  
- [ ] Get Supabase pooler URL (port 6543)
- [ ] Update schema.prisma: `engineType = "library"`
- [ ] Run `pnpm prisma generate`
- [ ] Install `@hono/aws-lambda` in api-app
- [ ] Create `apps/api/src/lambda.ts`
- [ ] Add `build:lambda` script
- [ ] Build Lambda package with Prisma files
- [ ] Create Lambda function (2048MB, 30s timeout)
- [ ] Set all 23 environment variables
- [ ] Create API Gateway with `/api/{proxy+}`
- [ ] Update frontend `NEXT_PUBLIC_API_URL`
- [ ] Test deployment

**Total Time:** 4-6 hours  
**Monthly Cost:** ~$12-20 (Lambda) + FREE (Supabase pooler)