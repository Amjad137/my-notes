
## **Your Stripe Webhook Command**

```bash
stripe listen --forward-to http://localhost:3000/api/webhooks/payments
```

### **How It Works**

Your route structure:
- `@repo/api` app uses `.basePath("/api")` → all routes start with `/api`
- `webhooksRouter` defines `/webhooks/payments` → final path is `/api/webhooks/payments`
- route.ts catches all `/api/*` requests and forwards to `@repo/api`

So the full path is: **`http://localhost:3000/api/webhooks/payments`**

---

### **After Running the Command**

```bash
stripe listen --forward-to http://localhost:3000/api/webhooks/payments
```

You'll see:
```
> Ready! Your webhook signing secret is whsec_test_... [copy this]
> Forwarding events to http://localhost:3000/api/webhooks/payments
```

Copy that signing secret and add it to your .env.local:
```
STRIPE_WEBHOOK_SECRET=whsec_test_...
```

---

### **Test It**

```bash
stripe trigger payment_intent.succeeded
```

This will send a test webhook to your local endpoint, and your index.ts `webhookHandler` will process it.