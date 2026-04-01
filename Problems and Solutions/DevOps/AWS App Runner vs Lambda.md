## AWS Cost Comparison: App Runner vs Lambda at Scale

### Assumptions:
- **API response time:** 200ms average
- **Cold starts:** 10% of Lambda requests (2s duration)
- **Memory:** 2GB (typical for Prisma + Node.js)
- **Region:** US East (N. Virginia)

---

## **Small Scale: 100K requests/month**

### **Lambda + RDS Proxy:**
```
Lambda invocations: 100,000
Average duration: 220ms (200ms + 10% cold starts)
Memory: 2048MB

Lambda costs:
- Requests: 100,000 × $0.20/1M = $0.02
- Duration: 100,000 × 0.22s × (2048/1024) × $0.0000166667 = $0.73
- RDS Proxy: $0.015/hour × 730 hours = $10.95

TOTAL: ~$11.70/month
```

### **App Runner:**
```
1 instance × 2GB RAM, 1 vCPU
Running 24/7

Compute: $0.064/vCPU-hour × 730 = $46.72
Memory: $0.007/GB-hour × 2GB × 730 = $10.22

TOTAL: ~$57/month
```

**Winner: Lambda** 📉 ($11.70 vs $57)

---

## **Medium Scale: 1M requests/month**

### **Lambda + RDS Proxy:**
```
Lambda invocations: 1,000,000
Average duration: 220ms

Lambda costs:
- Requests: 1,000,000 × $0.20/1M = $0.20
- Duration: 1,000,000 × 0.22s × 2 × $0.0000166667 = $7.33
- RDS Proxy: $0.015/hour × 730 hours = $10.95

TOTAL: ~$18.50/month
```

### **App Runner:**
```
2 instances × 2GB RAM, 1 vCPU (auto-scaling)
Running 24/7

Compute: $0.064/vCPU-hour × 2 × 730 = $93.44
Memory: $0.007/GB-hour × 4GB × 730 = $20.44

TOTAL: ~$114/month
```

**Winner: Lambda** 📉 ($18.50 vs $114)

---

## **Large Scale: 10M requests/month**

### **Lambda + RDS Proxy:**
```
Lambda invocations: 10,000,000
Average duration: 220ms

Lambda costs:
- Requests: 10,000,000 × $0.20/1M = $2.00
- Duration: 10,000,000 × 0.22s × 2 × $0.0000166667 = $73.33
- RDS Proxy (2 instances): $0.015 × 2 × 730 = $21.90

TOTAL: ~$97/month
```

### **App Runner:**
```
4 instances × 2GB RAM, 1 vCPU (auto-scaling)
Running 24/7

Compute: $0.064/vCPU-hour × 4 × 730 = $186.88
Memory: $0.007/GB-hour × 8GB × 730 = $40.88

TOTAL: ~$228/month
```

**Winner: Lambda** 📉 ($97 vs $228)

---

## **Very Large Scale: 100M requests/month**

### **Lambda + RDS Proxy:**
```
Lambda invocations: 100,000,000
Average duration: 220ms

Lambda costs:
- Requests: 100,000,000 × $0.20/1M = $20.00
- Duration: 100,000,000 × 0.22s × 2 × $0.0000166667 = $733.33
- RDS Proxy (5 instances): $0.015 × 5 × 730 = $54.75

TOTAL: ~$808/month
```

### **App Runner:**
```
10 instances × 2GB RAM, 1 vCPU (auto-scaling)
Running 24/7

Compute: $0.064/vCPU-hour × 10 × 730 = $467.20
Memory: $0.007/GB-hour × 20GB × 730 = $102.20

TOTAL: ~$569/month
```

**Winner: App Runner** 📈 ($569 vs $808)

---

## **Extreme Scale: 500M requests/month**

### **Lambda + RDS Proxy:**
```
Lambda invocations: 500,000,000
Average duration: 220ms

Lambda costs:
- Requests: 500,000,000 × $0.20/1M = $100.00
- Duration: 500,000,000 × 0.22s × 2 × $0.0000166667 = $3,666.67
- RDS Proxy (10 instances): $0.015 × 10 × 730 = $109.50

TOTAL: ~$3,876/month
```

### **App Runner:**
```
30 instances × 2GB RAM, 1 vCPU (auto-scaling)
Running 24/7

Compute: $0.064/vCPU-hour × 30 × 730 = $1,401.60
Memory: $0.007/GB-hour × 60GB × 730 = $306.60

TOTAL: ~$1,708/month
```

**Winner: App Runner** 📈 ($1,708 vs $3,876)

---

## Summary Table:

| Requests/Month | Lambda + RDS Proxy | App Runner | Winner |
|----------------|-------------------|------------|---------|
| 100K           | $11.70           | $57        | Lambda  |
| 1M             | $18.50           | $114       | Lambda  |
| 10M            | $97              | $228       | Lambda  |
| **100M**       | **$808**         | **$569**   | **App Runner** |
| 500M           | $3,876           | $1,708     | App Runner |

---

## **The Hidden Costs of Lambda:**

1. **RDS Proxy is mandatory** ($11-110/month depending on scale)
2. **Cold starts hurt UX** (not reflected in $$)
3. **Connection pooling complexity** (engineering time)
4. **Monitoring/debugging overhead** (CloudWatch costs not included)
5. **Lambda timeout risks** for long operations

---

## **Recommendation:**

**For your medical SaaS:**
- **Start with App Runner** even at low scale because:
  - ✅ Predictable costs
  - ✅ Better user experience (no cold starts)
  - ✅ Simpler architecture
  - ✅ Scales naturally to 100M+ requests
  - ✅ Less engineering complexity

**Lambda makes sense if:**
- ❌ Sporadic traffic (not typical for SaaS)
- ❌ Under 1M requests/month AND cost is critical
- ❌ Already using serverless architecture everywhere

**TL;DR:** Lambda is cheaper until ~50-100M requests/month, but **App Runner is better value** considering engineering time, user experience, and predictability. At large scale (100M+), App Runner becomes cheaper too.