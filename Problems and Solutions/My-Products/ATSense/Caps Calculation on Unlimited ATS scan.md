Here are the new "unlimited" ATS scan caps for Pro and Enterprise, recalculated for both 50% and 30% margin targets using the correct Gemini 2.5 Flash pricing:

---

## 1. Pro Plan ($29/month)

- **Revenue after Stripe:** $27.86
- **Full + Multi-JD AI cost:** $4.99/month (Full: 1,200 × $0.00378 = $4.54, Multi-JD: 150 × $0.00299 = $0.45)
- **Fixed infrastructure:** $3.50/month
- **Budget for ATS scans:** Revenue - Infra - Full/Multi-JD AI

---

### **A. 50% Margin Target**

- **Target cost:** $13.93
- **ATS budget:** $13.93 - $3.50 - $4.99 = $5.44
- **Daily ATS budget:** $5.44 / 30 = $0.181
- **ATS scan cost:** $0.00154/scan
- **Max ATS scans/day:** $0.181 / $0.00154 ≈ 117 scans/day

---

### **B. 30% Margin Target**

- **Target cost:** $19.50 (70% of $27.86)
- **ATS budget:** $19.50 - $3.50 - $4.99 = $11.01
- **Daily ATS budget:** $11.01 / 30 = $0.367
- **Max ATS scans/day:** $0.367 / $0.00154 ≈ 238 scans/day

---

## 2. Enterprise Plan ($199/month)

- **Revenue after Stripe:** $193.22
- **Full + Multi-JD AI cost:** $12.24/month (Full: 3,000 × $0.00378 = $11.34, Multi-JD: 300 × $0.00299 = $0.90)
- **Fixed infrastructure:** $20/month

---

### **A. 50% Margin Target**

- **Target cost:** $96.61
- **ATS budget:** $96.61 - $20 - $12.24 = $64.37
- **Daily ATS budget:** $64.37 / 30 = $2.145
- **Max ATS scans/day:** $2.145 / $0.00154 ≈ 1,393 scans/day

---

### **B. 30% Margin Target**

- **Target cost:** $135.25 (70% of $193.22)
- **ATS budget:** $135.25 - $20 - $12.24 = $103.01
- **Daily ATS budget:** $103.01 / 30 = $3.434
- **Max ATS scans/day:** $3.434 / $0.00154 ≈ 2,230 scans/day

---

## **Summary Table**

| Plan        | Margin | ATS Cap/Day |
|-------------|--------|-------------|
| Pro         | 50%    | 117         |
| Pro         | 30%    | 238         |
| Enterprise  | 50%    | 1,393       |
| Enterprise  | 30%    | 2,230       |

---

**Note:**  
- These caps are for ATS-only scans per day, assuming max usage of all other features.
- If you want to adjust for different infra or AI costs, update those numbers accordingly.
- If you want to keep a safety buffer, round down the caps slightly.

Let me know if you want these numbers reflected in your backend config or rate limit logic!