Great question! Let me explain how AWS Lambda executes your container:

## The Lambda Execution Flow

### 1. **Lambda Starts the Container**

When Lambda invokes your function, it:
1. Starts the container from your image
2. Looks for the handler specified in `CMD ["index.handler"]`

### 2. **What `CMD ["index.handler"]` Means**

```dockerfile
CMD ["index.handler"]
#     ^^^^^  ^^^^^^^
#     file   export name
```

This tells Lambda:
- Look for a file called `index.js` (or `index.cjs`) in `${LAMBDA_TASK_ROOT}/`
- Find the exported function named `handler`
- Call that function when events arrive

### 3. **Where Everything Lives**

```dockerfile
COPY --from=builder /app/apps/api/dist ${LAMBDA_TASK_ROOT}/
#                                       ^^^^^^^^^^^^^^^^^^^
#                                       /var/task (Lambda's working directory)
```

`${LAMBDA_TASK_ROOT}` = `/var/task/` (Lambda's default location for code)

So after the copy, you have:
```
/var/task/
├── index.js          ← Your built lambda handler
├── node_modules/     ← Dependencies
├── packages/         ← Workspace packages
└── config/           ← Config files
```

### 4. **Your Lambda Handler File**

Looking at your esbuild.config.mjs:

```javascript
// Builds to: dist/index.js
entryPoints: [isLambda ? "./src/lambda.ts" : "./src/index.ts"]
```

So when you run `pnpm build:lambda`, it compiles src/lambda.ts → `dist/index.js` 

Read [](file:///d%3A/Amjath/My%20Projects/WEB%20Projects/Unwir/docremark-mono/apps/api/src/lambda.ts)

Searched for text `lambdaHandler` (`**/packages/api/src/**/*.ts`), 1 result

Read [](file:///d%3A/Amjath/My%20Projects/WEB%20Projects/Unwir/docremark-mono/packages/api/src/lambda.ts)

Perfect! Now I can explain the complete flow:

## Complete Lambda Execution Flow

### 1. **Container Starts**
```dockerfile
FROM public.ecr.aws/lambda/nodejs:24
#    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#    This base image includes the Lambda Runtime API
```

The AWS Lambda base image contains:
- Node.js runtime
- **Lambda Runtime Interface Client (RIC)** - communicates with Lambda service
- Bootstrap script that reads `CMD` and executes your handler

### 2. **Lambda Looks for Your Handler**

```dockerfile
CMD ["index.handler"]
```

After container starts, Lambda runtime:
1. Reads this command
2. Requires `/var/task/index.js` (because of `LAMBDA_TASK_ROOT`)
3. Looks for the export named `handler`

But wait, your code exports `lambdaHandler`, not `handler`! Let me check the build config: 

Read [](file:///d%3A/Amjath/My%20Projects/WEB%20Projects/Unwir/docremark-mono/apps/api/esbuild.config.mjs#100-100), lines 100 to 117

The build outputs `index.js`, and your src/lambda.ts exports `lambdaHandler`. We need to fix the CMD to match: 

Using "Replace String in File"


```

```
Good catch! Now let me explain the complete flow:

## How Lambda Executes Your Container

```
┌──────────────────────────────────────────────────────────┐
│ 1. AWS Lambda Service receives HTTP request             │
│    (API Gateway → Lambda)                                │
└───────────────────────────┬──────────────────────────────┘
                            │
                            ▼
┌──────────────────────────────────────────────────────────┐
│ 2. Lambda Runtime starts your container                 │
│    - Pulls image from ECR                                │
│    - Starts container from public.ecr.aws/lambda/nodejs  │
│    - Lambda Runtime Interface Client (RIC) initializes   │
└───────────────────────────┬──────────────────────────────┘
                            │
                            ▼
┌──────────────────────────────────────────────────────────┐
│ 3. Runtime reads CMD ["index.lambdaHandler"]            │
│    - Looks in /var/task/ (LAMBDA_TASK_ROOT)             │
│    - Requires /var/task/index.js                        │
│    - Finds export: lambdaHandler                         │
└───────────────────────────┬──────────────────────────────┘
                            │
                            ▼
┌──────────────────────────────────────────────────────────┐
│ 4. Your Code: /var/task/index.js                        │
│    export const lambdaHandler = handle(app)              │
│                                  ^^^^^                    │
│                                  Hono's AWS Lambda adapter│
└───────────────────────────┬──────────────────────────────┘
                            │
                            ▼
┌──────────────────────────────────────────────────────────┐
│ 5. Lambda invokes: lambdaHandler(event, context)        │
│    event = {                                             │
│      rawPath: "/api/health",                             │
│      requestContext: { http: { method: "GET" } },        │
│      headers: { ... }                                    │
│    }                                                     │
└───────────────────────────┬──────────────────────────────┘
                            │
                            ▼
┌──────────────────────────────────────────────────────────┐
│ 6. Hono's handle() converts Lambda event → HTTP Request │
│    - Parses event.rawPath, event.headers                │
│    - Routes to your Hono app routes                      │
│    - Executes middleware chain                           │
│    - Runs route handler                                  │
└───────────────────────────┬──────────────────────────────┘
                            │
                            ▼
┌──────────────────────────────────────────────────────────┐
│ 7. Your Route Handler executes                          │
│    app.get('/api/health', (c) => c.json({ ok: true }))  │
└───────────────────────────┬──────────────────────────────┘
                            │
                            ▼
┌──────────────────────────────────────────────────────────┐
│ 8. Response flows back through Hono                     │
│    - Hono converts Response → Lambda response format     │
│    - Returns: { statusCode: 200, body: '{"ok":true}' }  │
└───────────────────────────┬──────────────────────────────┘
                            │
                            ▼
┌──────────────────────────────────────────────────────────┐
│ 9. Lambda Runtime returns response to API Gateway       │
│    Container stays warm for subsequent requests          │
└──────────────────────────────────────────────────────────┘
```

## Key Components

### **Lambda Runtime Interface Client (RIC)**
Built into `public.ecr.aws/lambda/nodejs:24` base image:
- Receives events from Lambda service
- Calls your handler function
- Returns responses back to Lambda

### **Hono's `handle()` Function**
```typescript
export const lambdaHandler = handle(app);
//                           ^^^^^^
//                           Converts between Lambda and HTTP
```

This adapter:
- **Input**: Lambda event object → Standard HTTP Request
- **Output**: HTTP Response → Lambda response format

### **When You Test Locally**

```bash
docker run -p 9000:8080 docremark-api:latest
```

The base image includes **Lambda Runtime Interface Emulator (RIE)**:
- Simulates the Lambda service
- Listens on port 8080
- Accepts Lambda-formatted events via HTTP
- Calls your handler exactly like real Lambda would

So `curl http://localhost:9000/2015-03-31/functions/function/invocations` mimics what API Gateway → Lambda does in production!

## Summary

1. **Container starts** → Lambda Runtime initializes
2. **Runtime reads CMD** → Finds `index.lambdaHandler`
3. **Loads your code** → `require('/var/task/index.js')`
4. **Waits for events** → Container stays warm
5. **Event arrives** → Calls `lambdaHandler(event, context)`
6. **Hono processes** → Routes to your handlers
7. **Response returns** → Container stays ready for next invocation

The container doesn't restart for each request - it stays running and Lambda just keeps calling your handler function!

Made changes.