Read [](file:///d%3A/Amjath/My%20Projects/WEB%20Projects/Unwir/docremark-mono/apps/api/package.json)

Read [](file:///d%3A/Amjath/My%20Projects/WEB%20Projects/Unwir/docremark-mono/apps/api/src/index.ts)

Read [](file:///d%3A/Amjath/My%20Projects/WEB%20Projects/Unwir/docremark-mono/packages/api/src/app.ts)

Read [](file:///d%3A/Amjath/My%20Projects/WEB%20Projects/Unwir/docremark-mono/packages/api/src/routes)

Read [](file:///d%3A/Amjath/My%20Projects/WEB%20Projects/Unwir/docremark-mono/packages/database/prisma/schema.prisma#1-1), lines 1 to 50

Read [](file:///d%3A/Amjath/My%20Projects/WEB%20Projects/Unwir/docremark-mono/packages/payments/provider/creem/index.ts#1-1), lines 1 to 50

Read [](file:///d%3A/Amjath/My%20Projects/WEB%20Projects/Unwir/docremark-mono/packages/api/src/routes/webhooks.ts)

Read [](file:///d%3A/Amjath/My%20Projects/WEB%20Projects/Unwir/docremark-mono/packages/auth/auth.ts#1-1), lines 1 to 100

Searched for text `engineType` (`**/*.prisma`), 1 result

Read [](file:///d%3A/Amjath/My%20Projects/WEB%20Projects/Unwir/docremark-mono/packages/storage/provider)

Read [](file:///d%3A/Amjath/My%20Projects/WEB%20Projects/Unwir/docremark-mono/packages/api/src/middleware/cors.ts)

Searched for text `process.env` (`**/packages/api/src/**`), no results

Searched for files matching `**/*Dockerfile`, 2 matches

Read [](file:///d%3A/Amjath/My%20Projects/WEB%20Projects/Unwir/docremark-mono/packages/utils/lib)

Read [](file:///d%3A/Amjath/My%20Projects/WEB%20Projects/Unwir/docremark-mono/apps/api/Dockerfile)

Read [](file:///d%3A/Amjath/My%20Projects/WEB%20Projects/Unwir/docremark-mono/packages/utils/lib/base-url.ts)

Searched for text `node:crypto` (`**/packages/payments/**/*.ts`), 2 results

Perfect! I've thoroughly analyzed your codebase. Here's the **specific** roadmap for deploying YOUR Hono API to AWS Lambda:

---

## 🚨 **Critical Issues Found in Your Codebase:**

### **1. Node.js `crypto` Module (BLOCKER)**
Your payment webhooks use `node:crypto`:
- **index.ts**: Line 1 - `import { createHmac } from "node:crypto"`
- **index.ts**: Line 1 - `import { createHmac, timingSafeEqual } from "node:crypto"`

**Lambda doesn't support `node:` prefix imports** - must use Web Crypto API.

### **2. Prisma Engine Type (BLOCKER)**
Your schema.prisma has:
```prisma
engineType = "binary"
```
Lambda requires `engineType = "library"` or Prisma Data Proxy.

### **3. @hono/node-server Dependency**
index.ts uses:
```typescript
import { serve } from "@hono/node-server";
```
This won't work in Lambda - needs Lambda adapter.

---

## 📋 **Step-by-Step Deployment Guide**

### **Phase 1: Code Modifications**

**Step 1.1: Replace node:crypto with Web Crypto API**
```typescript
// BEFORE (packages/payments/provider/creem/index.ts):
import { createHmac } from "node:crypto";

// AFTER:
// Use Web Crypto API
async function createHmac(algorithm: string, key: string, data: string) {
  const encoder = new TextEncoder();
  const keyData = encoder.encode(key);
  const messageData = encoder.encode(data);
  
  const cryptoKey = await crypto.subtle.importKey(
    'raw',
    keyData,
    { name: 'HMAC', hash: algorithm },
    false,
    ['sign']
  );
  
  const signature = await crypto.subtle.sign('HMAC', cryptoKey, messageData);
  return Buffer.from(signature).toString('hex');
}
```
Apply same fix to index.ts.

**Step 1.2: Change Prisma Engine Type**

Option A: Use library engine (increases bundle size):
```prisma
generator client {
  provider = "prisma-client-js"
  engineType = "library"  // Changed from "binary"
}
```

Option B: Use Prisma Accelerate (recommended, costs $29/month):
```bash
# Sign up at https://www.prisma.io/data-platform/accelerate
# Get connection string like: prisma://accelerate.prisma-data.net/?api_key=...

# In .env.local:
DATABASE_URL="prisma://accelerate.prisma-data.net/?api_key=YOUR_KEY"
DIRECT_URL="postgresql://postgres:Test@123@your-supabase.com:5432/docremark"
```

**Step 1.3: Add Lambda Handler**

Install adapter:
```bash
pnpm add @hono/aws-lambda --filter @repo/api-app
```

Create `apps/api/src/lambda.ts`:
```typescript
import { handle } from '@hono/aws-lambda';
import { app } from '@repo/api';

export const handler = handle(app);
```

**Step 1.4: Update package.json Build**
```json
// apps/api/package.json
{
  "scripts": {
    "build:lambda": "esbuild ./src/lambda.ts --bundle --platform=node --target=node20 --outfile=dist/lambda.js --minify --external:@prisma/client --external:prisma"
  }
}
```

---

### **Phase 2: Database Connection Pooling**

**Critical:** Lambda creates NEW connections per invocation. Options:

**Option A: Prisma Accelerate (Recommended)**
- Handles connection pooling automatically
- Caches queries
- Cost: $29/month
- Setup: Change `DATABASE_URL` as shown in Step 1.2

**Option B: AWS RDS Proxy**
- Sits between Lambda and PostgreSQL
- Cost: ~$11-15/month + data transfer
- Setup required in AWS Console

**Option C: Supabase Pooler**
- If using Supabase, enable connection pooler
- Get pooler URL from Supabase dashboard
- Change `DATABASE_URL` to pooler URL
- **FREE** with Supabase

For your Supabase setup, **use Option C** (pooler URL):
```bash
# Change from:
DATABASE_URL="postgresql://postgres:Test@123@db.xxx.supabase.co:5432/postgres"

# To (get from Supabase dashboard > Project Settings > Database):
DATABASE_URL="postgresql://postgres:Test@123@db.xxx.supabase.co:6543/postgres?pgbouncer=true"
```

---

### **Phase 3: Lambda Deployment Configuration**

**Step 3.1: Create SAM Template**

Create `apps/api/template.yaml`:
```yaml
AWSTemplateFormatVersion: '2010-09-09'
Transform: AWS::Serverless-2016-10-31

Globals:
  Function:
    Timeout: 30
    MemorySize: 2048
    Runtime: nodejs20.x
    Environment:
      Variables:
        DATABASE_URL: !Ref DatabaseUrl
        BETTER_AUTH_SECRET: !Ref BetterAuthSecret
        CREEM_API_KEY: !Ref CreemApiKey
        CREEM_WEBHOOK_SECRET: !Ref CreemWebhookSecret
        RESEND_API_KEY: !Ref ResendApiKey
        R2_ACCOUNT_ID: !Ref R2AccountId
        R2_ACCESS_KEY_ID: !Ref R2AccessKeyId
        R2_SECRET_ACCESS_KEY: !Ref R2SecretAccessKey
        BUCKET_NAME: !Ref BucketName
        # Add all other env vars...

Parameters:
  DatabaseUrl:
    Type: String
    NoEcho: true
  BetterAuthSecret:
    Type: String
    NoEcho: true
  # Define all parameters...

Resources:
  DocremarkApi:
    Type: AWS::Serverless::Function
    Properties:
      CodeUri: dist/
      Handler: lambda.handler
      Events:
        ApiEvent:
          Type: Api
          Properties:
            Path: /api/{proxy+}
            Method: ANY
      Policies:
        - AWSLambdaBasicExecutionRole

Outputs:
  ApiUrl:
    Value: !Sub "https://${ServerlessRestApi}.execute-api.${AWS::Region}.amazonaws.com/Prod/api"
```

**Step 3.2: Build and Deploy Commands**
```bash
# Build
cd apps/api
pnpm run build:lambda

# Copy Prisma client
cp -r ../../node_modules/.prisma dist/
cp -r ../../node_modules/@prisma dist/

# Deploy with SAM
sam deploy --guided \
  --parameter-overrides \
    DatabaseUrl="your-pooler-url" \
    BetterAuthSecret="your-secret" \
    # ... all other params
```

---

### **Phase 4: Frontend Integration**

Update .env.local:
```bash
# Replace localhost API URL with Lambda URL
NEXT_PUBLIC_API_URL="https://xxx.execute-api.us-east-1.amazonaws.com/Prod/api"
```

---

### **Phase 5: Environment Variables**

Your app reads these (from base-url.ts and config):
```bash
# Required in Lambda:
DATABASE_URL=""              # Pooler URL
DIRECT_URL=""                # Direct PostgreSQL (for migrations only)
BETTER_AUTH_SECRET=""
NEXT_PUBLIC_SITE_URL=""      # Your frontend URL for CORS
NEXT_PUBLIC_EXTERNAL_URLS="" # Comma-separated for CORS
CREEM_API_KEY=""
CREEM_WEBHOOK_SECRET=""
CREEM_USE_PRODUCTION_API=""
RESEND_API_KEY=""
R2_ACCOUNT_ID=""
R2_ACCESS_KEY_ID=""
R2_SECRET_ACCESS_KEY=""
BUCKET_NAME=""               # No longer NEXT_PUBLIC!
PRODUCT_ID_*=""              # All 6 product IDs
LOG_LEVEL=""
```

Store in **AWS Systems Manager Parameter Store** or **Secrets Manager**.

---

## **Estimated Timeline & Costs:**

| Task | Time | Monthly Cost |
|------|------|--------------|
| Fix node:crypto code | 2-3 hours | - |
| Change Prisma engine + Supabase pooler | 1 hour | FREE |
| Create Lambda handler | 30 min | - |
| SAM template setup | 1-2 hours | - |
| Deploy + test | 2-3 hours | - |
| Lambda runtime (100K req/month) | - | ~$12 |
| **TOTAL** | **7-10 hours** | **~$12/month** |

If using Prisma Accelerate instead: +$29/month

---

## **My Honest Recommendation:**

Given the code changes required (node:crypto refactor, Prisma changes), **I still recommend AWS App Runner**:
- Your code works as-is (no refactoring)
- $57/month predictable
- No connection pooling headaches
- Better for your medical SaaS (consistent performance)

But if cost is critical and you have time for refactoring, Lambda is viable!