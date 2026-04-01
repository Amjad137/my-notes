I'll analyze the economics and help you define optimized pricing. Let me break down the numbers: 

Read [](file:///d%3A/Amjath/My%20Projects/WEB%20Projects/supa-starter-projects/atsense/config/index.ts)

Now let me provide you with a comprehensive pricing analysis and recommendations:

## 📊 **Cost & Pricing Analysis**

### **Variable Costs Per Scan:**

| Component | Cost | Notes |
|-----------|------|-------|
| **Gemini API** | $0.0005 | 4000 input + 750 output tokens @ $0.075/$0.3 per 1M |
| **Database ops** | $0.0002 | Prisma serverless queries, indexes |
| **Storage (S3)** | $0.00001 | ~1MB per CV @ $0.023/GB/month |
| **Compute/Edge** | $0.001 | Request processing, streaming |
| **Total Variable Cost** | **~$0.0017 per scan** | |

### **Fixed Infrastructure Costs (Monthly):**

| Component | Cost Range | Notes |
|-----------|-----------|-------|
| **Hosting** (Vercel) | $20-50 | Scales with usage, includes DB |
| **Prisma DB** | $15-40 | Serverless, scales with connections |
| **Email Service** | $10-20 | Transactional emails (Resend/SendGrid) |
| **Monitoring/Logs** | $10-15 | Error tracking, analytics |
| **CDN/Storage** | $10-30 | Global distribution, S3 egress |
| **Total Fixed** | **~$65-155/month baseline** | |

---

## 💰 **Recommended Pricing Structure**

### **Tier 1: FREE** (Current - Keep it)
```
Daily Limit: 3 scans/day = ~90 scans/month
Features:
  ✓ CV Upload
  ✓ Basic Match Score
  ✗ Advanced Rewriting
  ✗ Export Reports

Cost to You: ~$0.15 + $0.50 fixed allocation = $0.65/month
Margin: Loss leader (convert to paid)
```

### **Tier 2: PRO** (Optimize current)
```
Daily Limit: 10 scans/day = ~300 scans/month
Price: $12/month or $120/year (↓ from $15)
Features:
  ✓ CV Upload & Optimization
  ✓ Advanced Match Score
  ✓ Rewriting Suggestions
  ✓ Download Reports (PDF/DOCX)
  ✓ Scan History (30 days)

Cost to You: (300 × $0.0017) + $1.50 fixed = $1.01/month
Gross Margin: $10.99/month = 91% ✅ (Excellent)
```

**Why lower from $15?** Better conversion rate at $12, still extremely profitable. Yearly option incentivizes commitment.

### **Tier 3: PREMIUM** (NEW - High value)
```
Daily Limit: 50 scans/day = ~1,500 scans/month
Price: $29/month or $290/year
Target: Career coaches, recruiters, agencies
Features:
  ✓ Everything in Pro
  ✓ Priority Support (24h response)
  ✓ Batch CV Analysis (upload 5+ at once)
  ✓ Custom Keywords
  ✓ Scan History (90 days)
  ✓ Integration API (basic)

Cost to You: (1500 × $0.0017) + $2.00 fixed = $4.55/month
Gross Margin: $24.45/month = 84% ✅ (Very healthy)
```

### **Tier 4: ENTERPRISE** (Keep unlimited)
```
Daily Limit: Unlimited
Price: Custom ($499-2000+/month depending on volume)
Target: HR platforms, recruitment firms, universities
Features:
  ✓ Everything in Premium
  ✓ Dedicated Support
  ✓ Custom Integrations
  ✓ White-label Options
  ✓ SSO/SAML
  ✓ Usage Analytics
  ✓ Custom Training

Estimated Cost: $10-50/month (volume negotiated)
Gross Margin: 75-90% (negotiated per deal)
```

---

## 📈 **Financial Projections**

Assuming **1000 users** at launch phase:

| Metric | Free | Pro | Premium | Enterprise | **Total** |
|--------|------|-----|---------|------------|----------|
| **Users** | 600 | 300 | 80 | 20 | 1000 |
| **MRR** | $0 | $3,600 | $2,320 | $7,500* | **$13,420** |
| **Variable Cost** | $306 | $153 | $204 | $1,000* | **$1,663** |
| **Fixed Cost** | $500 | $500 | $500 | $500 | **$2,000** |
| **Gross Profit** | -$806 | $2,947 | $1,616 | $6,000 | **$9,757** |
| **Margin %** | - | 81% | 69% | 80% | **73%** |

*Enterprise assumes $500-1500/month average

---

## 🎯 **Implementation Strategy**

```typescript
// Update config/index.ts payments.plans:
{
  free: {
    isFree: true,
    features: {
      dailyScans: 3,
      enableExport: true,
      enableAdvancedRewriting: false,
      historyDays: 7,
    },
  },
  pro: {
    recommended: true,
    features: {
      dailyScans: 10,
      enableExport: true,
      enableAdvancedRewriting: true,
      historyDays: 30,
    },
    prices: [
      {
        type: "recurring",
        productId: process.env.NEXT_PUBLIC_PRICE_ID_PRO_MONTHLY,
        interval: "month",
        amount: 12,  // ↓ reduced for better conversion
        currency: "USD",
        trialPeriodDays: 7,
      },
      {
        type: "recurring",
        productId: process.env.NEXT_PUBLIC_PRICE_ID_PRO_YEARLY,
        interval: "year",
        amount: 120,  // 2 months free
        currency: "USD",
        trialPeriodDays: 7,
      },
    ],
  },
  premium: {  // NEW
    features: {
      dailyScans: 50,
      enableExport: true,
      enableAdvancedRewriting: true,
      enableBatchAnalysis: true,
      enableCustomKeywords: true,
      historyDays: 90,
      prioritySupport: true,
    },
    prices: [
      {
        type: "recurring",
        productId: process.env.NEXT_PUBLIC_PRICE_ID_PREMIUM_MONTHLY,
        interval: "month",
        amount: 29,
        currency: "USD",
        trialPeriodDays: 14,  // Longer trial for higher tier
      },
      {
        type: "recurring",
        productId: process.env.NEXT_PUBLIC_PRICE_ID_PREMIUM_YEARLY,
        interval: "year",
        amount: 290,
        currency: "USD",
        trialPeriodDays: 14,
      },
    ],
  },
  enterprise: {
    isEnterprise: true,
    features: {
      dailyScans: -1,  // unlimited
      enableExport: true,
      enableAdvancedRewriting: true,
      enableBatchAnalysis: true,
      enableAPI: true,
      enableWhiteLabel: true,
      enableSSO: true,
      prioritySupport: true,
    },
  },
}
```

---

## 🌍 **Global Launch Considerations**

1. **Regional Pricing** - Add 20-30% markup for non-USD regions (VAT, payment fees, market rates)
2. **Payment Methods** - Support Stripe (US/EU), Razorpay (India), local gateways
3. **Free Trial** - 7 days for Pro, 14 days for Premium reduces friction
4. **Annual Discount** - 17% discount ($10/month) incentivizes commitment & reduces churn

**Would you like me to update the config with the new tier structure?**