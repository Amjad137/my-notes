# Image Proxy Pattern Guide

## Overview
The image-proxy pattern creates a secure, flexible layer between your frontend and cloud storage (S3/R2/GCS). Instead of exposing storage URLs directly, you route all image requests through your API.

## Architecture

```
Frontend Request
    ↓
/image-proxy/avatars/user-123.jpg
    ↓
Next.js API Route (validate, auth check)
    ↓
Generate signed URL from S3/R2
    ↓
302 Redirect to signed URL
    ↓
Browser fetches from S3/R2 directly
```

## Step-by-Step Implementation

### 1. Create the API Route

**Location:** `app/image-proxy/[...path]/route.ts` (Next.js App Router)

```typescript
import { getSignedUrl } from "@/lib/storage"; // Your storage helper
import { NextResponse } from "next/server";

export const GET = async (
  _req: Request,
  { params }: { params: Promise<{ path: string[] }> }
) => {
  const { path } = await params;
  
  // Parse URL: /image-proxy/avatars/user-123.jpg
  const [category, ...fileSegments] = path;
  const filePath = fileSegments.join("/");

  // Validation
  if (!(category && filePath)) {
    return new Response("Invalid path", { status: 400 });
  }

  // Optional: Category whitelist
  const allowedCategories = ["avatars", "posts", "thumbnails"];
  if (!allowedCategories.includes(category)) {
    return new Response("Invalid category", { status: 400 });
  }

  // Optional: Authentication check
  // const session = await getSession(req);
  // if (!session) {
  //   return new Response("Unauthorized", { status: 401 });
  // }

  // Construct full storage path
  const fullPath = `${category}/${filePath}`;

  // Generate signed URL (expires in 1 hour)
  const signedUrl = await getSignedUrl(fullPath, {
    bucket: process.env.S3_BUCKET_NAME!,
    expiresIn: 60 * 60, // 3600 seconds
  });

  // Redirect with caching
  return NextResponse.redirect(signedUrl, {
    headers: { 
      "Cache-Control": "public, max-age=3600, immutable" 
    },
  });
};
```

### 2. Create Storage Helper Function

**Location:** `lib/storage.ts`

```typescript
import { S3Client, GetObjectCommand } from "@aws-sdk/client-s3";
import { getSignedUrl as awsGetSignedUrl } from "@aws-sdk/s3-request-presigner";

const s3Client = new S3Client({
  region: process.env.AWS_REGION || "us-east-1",
  credentials: {
    accessKeyId: process.env.AWS_ACCESS_KEY_ID!,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY!,
  },
});

// For Cloudflare R2, use this instead:
// const s3Client = new S3Client({
//   region: "auto",
//   endpoint: `https://${process.env.R2_ACCOUNT_ID}.r2.cloudflarestorage.com`,
//   credentials: {
//     accessKeyId: process.env.R2_ACCESS_KEY_ID!,
//     secretAccessKey: process.env.R2_SECRET_ACCESS_KEY!,
//   },
// });

export async function getSignedUrl(
  key: string,
  options: {
    bucket: string;
    expiresIn?: number;
  }
): Promise<string> {
  const command = new GetObjectCommand({
    Bucket: options.bucket,
    Key: key,
  });

  return await awsGetSignedUrl(s3Client, command, {
    expiresIn: options.expiresIn || 3600,
  });
}
```

### 3. Frontend Usage

**In React/Next.js components:**

```tsx
// ❌ Old way: Direct S3 URL (exposed, inflexible)
<img src="https://mybucket.s3.amazonaws.com/avatars/user-123.jpg" />

// ✅ New way: Proxy URL (secure, controlled)
<img src="/image-proxy/avatars/user-123.jpg" />
```

**With dynamic data:**

```tsx
function UserAvatar({ user }: { user: User }) {
  // user.avatarPath = "user-123.jpg" (stored in DB)
  const avatarUrl = user.avatarPath 
    ? `/image-proxy/avatars/${user.avatarPath}`
    : "/default-avatar.png";
  
  return <img src={avatarUrl} alt={user.name} />;
}
```

### 4. Database Schema

Store only the **filename/path**, not the full URL:

```prisma
model User {
  id         String  @id
  name       String
  avatarPath String? // "user-123.jpg" NOT full URL
}
```

### 5. Environment Variables

```env
# AWS S3
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=your_key
AWS_SECRET_ACCESS_KEY=your_secret
S3_BUCKET_NAME=my-bucket

# OR Cloudflare R2
R2_ACCOUNT_ID=your_account_id
R2_ACCESS_KEY_ID=your_key
R2_SECRET_ACCESS_KEY=your_secret
R2_BUCKET_NAME=my-bucket
```

## Advanced Features

### Add Authentication

```typescript
import { getServerSession } from "next-auth";

export const GET = async (req: Request, { params }) => {
  const session = await getServerSession();
  
  if (!session) {
    return new Response("Unauthorized", { status: 401 });
  }
  
  // Optional: Check if user owns this resource
  const [category, userId, fileName] = path;
  if (category === "avatars" && userId !== session.user.id) {
    return new Response("Forbidden", { status: 403 });
  }
  
  // ... rest of the code
};
```

### Add Rate Limiting

```typescript
import { ratelimit } from "@/lib/rate-limit";

export const GET = async (req: Request) => {
  const ip = req.headers.get("x-forwarded-for") || "anonymous";
  
  const { success } = await ratelimit.limit(ip);
  if (!success) {
    return new Response("Too many requests", { status: 429 });
  }
  
  // ... rest of the code
};
```

### Add Access Logging

```typescript
import { logger } from "@/lib/logger";

export const GET = async (req: Request, { params }) => {
  const { path } = await params;
  
  logger.info("Image access", {
    path: path.join("/"),
    ip: req.headers.get("x-forwarded-for"),
    userAgent: req.headers.get("user-agent"),
  });
  
  // ... rest of the code
};
```

## Benefits vs Direct URLs

| Feature | Direct S3 URLs | Image Proxy |
|---------|---------------|-------------|
| **Security** | ❌ Exposes storage structure | ✅ Hides implementation |
| **Auth Control** | ❌ No per-request auth | ✅ Can check permissions |
| **Provider Switch** | ❌ URLs change | ✅ Same URLs work |
| **Rate Limiting** | ❌ Can't control | ✅ Easy to add |
| **Access Logs** | ❌ AWS logs only | ✅ Full control |
| **Performance** | ✅ Direct access | ⚠️ Extra redirect |
| **Complexity** | ✅ Simple | ⚠️ More code |

## Performance Considerations

### Caching Strategy

```typescript
// Short-lived content (profile pictures that change)
headers: { "Cache-Control": "public, max-age=3600" } // 1 hour

// Long-lived content (post images that don't change)
headers: { "Cache-Control": "public, max-age=31536000, immutable" } // 1 year

// Private content (user-specific documents)
headers: { "Cache-Control": "private, max-age=3600" }
```

### CDN Integration

Put a CDN (Cloudflare, Vercel) in front of your API:

```
Browser → CDN Cache → /image-proxy → S3
```

The redirect gets cached at CDN level, reducing latency.

### Alternative: Direct Signed URLs

For high-traffic public images, consider storing pre-signed URLs in your database:

```typescript
// On upload, generate long-lived signed URL
const signedUrl = await getSignedUrl(path, { expiresIn: 7 * 24 * 60 * 60 }); // 7 days

// Store in DB
await db.user.update({
  where: { id },
  data: { avatarUrl: signedUrl }, // Full URL, not just path
});

// Frontend: Direct use (no proxy needed)
<img src={user.avatarUrl} />
```

## Migration from Direct URLs

If you already have direct S3 URLs in your database:

```typescript
// Migration script
const users = await db.user.findMany();

for (const user of users) {
  if (user.avatarUrl?.includes('s3.amazonaws.com')) {
    // Extract path: https://bucket.s3.amazonaws.com/avatars/user-123.jpg
    //           → avatars/user-123.jpg
    const path = new URL(user.avatarUrl).pathname.slice(1);
    
    await db.user.update({
      where: { id: user.id },
      data: { avatarPath: path }, // New column with just the path
    });
  }
}
```

## Testing

```typescript
// Test the proxy route
describe("Image Proxy", () => {
  it("should redirect to signed URL", async () => {
    const response = await fetch("/image-proxy/avatars/test.jpg");
    
    expect(response.status).toBe(302);
    expect(response.headers.get("location")).toContain("amazonaws.com");
  });

  it("should reject invalid categories", async () => {
    const response = await fetch("/image-proxy/invalid/test.jpg");
    expect(response.status).toBe(400);
  });
});
```

## Packages Needed

```bash
npm install @aws-sdk/client-s3 @aws-sdk/s3-request-presigner
```

## Quick Setup Checklist

- [ ] Install AWS SDK packages
- [ ] Create `lib/storage.ts` with signed URL helper
- [ ] Create `app/image-proxy/[...path]/route.ts`
- [ ] Add environment variables
- [ ] Update database schema (store paths, not URLs)
- [ ] Update frontend components to use `/image-proxy/...`
- [ ] Configure S3/R2 CORS (if uploading from browser)
- [ ] Test with real images
- [ ] Add authentication if needed
- [ ] Add caching headers

---

**Pro tip:** Start with the basic implementation, then add auth/logging/rate-limiting as your needs grow. The redirect overhead is negligible for most use cases, and the flexibility is worth it.
