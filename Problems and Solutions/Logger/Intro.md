Great question! Let me teach you the logger concept comprehensively:

---

## 📚 **Understanding Logging vs Console.log**

### **Why NOT to use `console.log` in production:**

```javascript
// ❌ BAD - Console.log in production
console.log("User created:", user);  // Always prints, clutters logs
console.log("Debug info:", data);    // No way to filter
console.error("Error:", err);        // Mixed with everything else
```

**Problems:**
- ❌ Always prints (can't turn off)
- ❌ No severity levels
- ❌ Hard to filter/search
- ❌ No timestamps
- ❌ No structured data
- ❌ Performance impact

### **Why USE a Logger (like `@repo/logs`):**

```javascript
// ✅ GOOD - Structured logging
logger.debug("User created:", user);   // Only in debug mode
logger.info("Payment processed:", id); // Important events
logger.warn("Rate limit approaching"); // Warnings
logger.error("Payment failed:", err);  // Errors only
```

**Benefits:**
- ✅ Control what prints (by level)
- ✅ Structured output
- ✅ Timestamps included
- ✅ Easy to search/filter
- ✅ Can send to monitoring tools
- ✅ Better performance

---

## 🎯 **Log Levels Explained**

[1 tool called]

Your project uses **Consola** (a modern logging library). Let me explain how it works:

### **Log Levels (from least to most severe):**

```javascript
logger.debug("Detailed info for debugging");    // Level 0 - Most verbose
logger.info("Important business events");       // Level 1 - Normal
logger.warn("Something unusual happened");      // Level 2 - Warning
logger.error("Something failed");               // Level 3 - Error
logger.fatal("Critical failure, app crashing"); // Level 4 - Fatal
```

### **How Log Levels Work:**

```bash
# Set LOG_LEVEL environment variable
LOG_LEVEL=debug   # Shows: debug, info, warn, error, fatal (EVERYTHING)
LOG_LEVEL=info    # Shows: info, warn, error, fatal (default in dev)
LOG_LEVEL=warn    # Shows: warn, error, fatal (production default)
LOG_LEVEL=error   # Shows: error, fatal only (strict production)
```

**Visual Example:**

```
LOG_LEVEL=debug:
  🔍 DEBUG: Subscription already exists, updating
  ℹ️  INFO: Creating new subscription purchase
  ⚠️  WARN: Deleting subscription due to cancellation
  ❌ ERROR: Failed to create purchase

LOG_LEVEL=info:
  ℹ️  INFO: Creating new subscription purchase
  ⚠️  WARN: Deleting subscription due to cancellation
  ❌ ERROR: Failed to create purchase

LOG_LEVEL=warn:
  ⚠️  WARN: Deleting subscription due to cancellation
  ❌ ERROR: Failed to create purchase

LOG_LEVEL=error:
  ❌ ERROR: Failed to create purchase
```

---

## 🖥️ **Where Do Logs Appear?**

### **Development (Local):**
```bash
npm run dev
# Logs appear in YOUR TERMINAL where you ran the command
```

**Example:**
```
@repo/web:dev: ℹ️ Creem: Creating new subscription purchase
@repo/web:dev: ⚠️ Creem: Deleting subscription sub_xxx
```

### **Production (Deployed):**

Logs go to different places depending on your hosting:

| Platform | Where Logs Go |
|----------|---------------|
| **Vercel** | Vercel Dashboard → Functions → Logs |
| **Railway** | Railway Dashboard → Deployments → Logs |
| **AWS** | CloudWatch Logs |
| **Docker** | `docker logs <container-id>` |
| **PM2** | `pm2 logs` |

---

## 🔧 **How to Configure Log Levels**

### **Option 1: Environment Variable (Recommended)**

```bash
# .env.local (development)
LOG_LEVEL=debug

# .env.production (production)
LOG_LEVEL=warn
```

### **Option 2: Programmatically**

[4 tools called]

Perfect! Now let me create a comprehensive guide:

---

## ✅ **Updated Logger Configuration**

Your logger now automatically adjusts based on environment:

```typescript
// Development (npm run dev)
LOG_LEVEL = 1 (info)  // Shows: info, warn, error

// Production (deployed)
LOG_LEVEL = 2 (warn)  // Shows: warn, error only
```

---

## 📖 **Complete Usage Guide**

### **1. Basic Usage**

```typescript
import { logger } from "@repo/logs";

// Debugging (only in debug mode)
logger.debug("Processing webhook payload:", payload);
logger.debug("Subscription check:", { id, status });

// Information (normal operations)
logger.info("User registered:", userId);
logger.info("Payment processed:", { amount, currency });

// Warnings (unusual but handled)
logger.warn("Rate limit approaching:", { remaining: 10 });
logger.warn("Deprecated API used:", endpoint);

// Errors (failures)
logger.error("Payment failed:", error);
logger.error("Database connection lost");

// Fatal (app-breaking)
logger.fatal("Cannot connect to database, shutting down");
```

### **2. Structured Logging (Best Practice)**

```typescript
// ✅ GOOD - Structured data
logger.info("Subscription created", {
  subscriptionId: "sub_123",
  userId: "user_456",
  plan: "monthly",
  amount: 29.99
});

// ❌ BAD - String concatenation
logger.info(`Subscription ${id} created for user ${userId}`);
```

**Why?** Structured logs can be parsed by monitoring tools (Datadog, Sentry, etc.)

### **3. Conditional Logging**

```typescript
// Only log in development
if (process.env.NODE_ENV === "development") {
  logger.debug("Full request body:", req.body);
}

// Or use debug level (automatically filtered in production)
logger.debug("Full request body:", req.body);
```

---

## 🎮 **Practical Examples**

### **Example 1: Debugging a Webhook**

```typescript
// Development: LOG_LEVEL=debug
logger.debug("Webhook received:", {
  event: payload.eventType,
  subscriptionId: payload.object.id,
  timestamp: new Date().toISOString()
});

// Terminal output:
// 🔍 DEBUG: Webhook received: { event: 'subscription.active', ... }
```

### **Example 2: Tracking Business Events**

```typescript
// Production: LOG_LEVEL=warn (but info still shows)
logger.info("New subscription", {
  subscriptionId: "sub_123",
  plan: "yearly",
  revenue: 299.99
});

// Terminal/Dashboard output:
// ℹ️ INFO: New subscription { subscriptionId: 'sub_123', ... }
```

### **Example 3: Error Tracking**

```typescript
try {
  await createPurchase(data);
} catch (error) {
  logger.error("Failed to create purchase", {
    error: error.message,
    data: data,
    stack: error.stack
  });
  // This ALWAYS shows in production
}

// Terminal/Dashboard output:
// ❌ ERROR: Failed to create purchase { error: 'Foreign key constraint', ... }
```

---

## 🔍 **How to View Logs**

### **Development (Your Machine):**

```bash
# Terminal 1: Run your app
npm run dev

# Watch logs in real-time in the same terminal
# ℹ️ INFO: Creating subscription...
# ⚠️ WARN: Deleting subscription...

# To see debug logs:
LOG_LEVEL=0 npm run dev
# or
LOG_LEVEL=debug npm run dev
```

### **Production (Deployed):**

**Vercel:**
```
Dashboard → Project → Functions → Select Function → Logs tab
```

**Railway:**
```
Dashboard → Project → Deployments → View Logs
```

**Docker:**
```bash
docker logs -f <container-name>
```

---

## 🎯 **Best Practices Summary**

| Do ✅ | Don't ❌ |
|------|----------|
| Use `logger.debug()` for detailed flow | Use `console.log()` |
| Use `logger.info()` for business events | Log sensitive data (passwords, tokens) |
| Use `logger.warn()` for unusual situations | Log on every request (too noisy) |
| Use `logger.error()` for failures | Mix log levels incorrectly |
| Use structured objects | Use string concatenation |
| Set appropriate LOG_LEVEL in production | Leave LOG_LEVEL=debug in production |

---

## 🚀 **Quick Reference**

```typescript
// Consola Log Levels (numeric)
0 = debug   // Most verbose
1 = info    // Default development
2 = warn    // Default production
3 = error   // Errors only
4 = fatal   // Critical failures

// Environment Variables
LOG_LEVEL=0     # or "debug"
LOG_LEVEL=1     # or "info"
LOG_LEVEL=2     # or "warn"
LOG_LEVEL=3     # or "error"

// Your terminal shows logs in real-time
// No need to check browser console for server-side logs!
```

Now you understand why loggers are better than `console.log` and how to use them effectively! 🎓