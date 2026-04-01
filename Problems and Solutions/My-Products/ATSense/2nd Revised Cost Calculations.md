Here is the full, detailed analysis using your fixed ATS scan caps and the correct Gemini 2.5 Flash pricing:

---

## 1. Gemini 2.5 Flash Pricing (Jan 2026)

- **Input:** $0.30 per 1M tokens ($0.0003 per 1K)
- **Output:** $2.50 per 1M tokens ($0.0025 per 1K)

---

## 2. Token Usage & Cost Per Scan

| Scan Type         | Input Tokens | Output Tokens | Input Cost         | Output Cost        | **Total Cost**   |
|-------------------|-------------|---------------|--------------------|--------------------|------------------|
| Full CV+JD        | 4,250       | 1,000         | $0.00128           | $0.00250           | $0.00378         |
| Multi-JD (3 JDs)  | 3,700       | 750           | $0.00111           | $0.00188           | $0.00299         |
| ATS-Only          | 1,800       | 400           | $0.00054           | $0.00100           | $0.00154         |

---

## 3. Plan Limits & Monthly Cost Calculations

### **Coffee Crunch ($3, 3 days)**
- **5 full scans/day** × 3 = 15
- **10 ATS/day** × 3 = 30
- **2 multi-JD/day** × 3 = 6

**Max AI Cost:**
- Full: 15 × $0.00378 = $0.0567
- ATS: 30 × $0.00154 = $0.0462
- Multi-JD: 6 × $0.00299 = $0.0179
- **Total AI:** $0.121
- Infra: $0.03
- **Total:** $0.151

**Revenue after Stripe:** $2.64  
**Profit:** $2.49  
**Margin:** 82%

---

### **Basic ($15/month)**
- **20 full scans/day** × 30 = 600
- **35 ATS/day** × 30 = 1,050
- **3 multi-JD/day** × 30 = 90

**Max AI Cost:**
- Full: 600 × $0.00378 = $2.27
- ATS: 1,050 × $0.00154 = $1.617
- Multi-JD: 90 × $0.00299 = $0.269
- **Total AI:** $4.156
- Infra: $1.90
- **Total:** $6.06

**Revenue after Stripe:** $14.26  
**Profit:** $8.20  
**Margin:** 57.5%

---

### **Pro ($29/month, ATS cap: 150/day)**
- **40 full scans/day** × 30 = 1,200
- **ATS scans/day:** 150 × 30 = 4,500
- **5 multi-JD/day** × 30 = 150

**Max AI Cost:**
- Full: 1,200 × $0.00378 = $4.54
- ATS: 4,500 × $0.00154 = $6.93
- Multi-JD: 150 × $0.00299 = $0.449
- **Total AI:** $11.92
- Infra: $3.50
- **Total:** $15.42

**Revenue after Stripe:** $27.86  
**Profit:** $12.44  
**Margin:** 44.7%

---

### **Enterprise ($199/month, ATS cap: 1,300/day)**
- **100 full scans/day** × 30 = 3,000
- **ATS scans/day:** 1,300 × 30 = 39,000
- **10 multi-JD/day** × 30 = 300

**Max AI Cost:**
- Full: 3,000 × $0.00378 = $11.34
- ATS: 39,000 × $0.00154 = $60.06
- Multi-JD: 300 × $0.00299 = $0.897
- **Total AI:** $72.30
- Infra: $20
- **Total:** $92.30

**Revenue after Stripe:** $193.22  
**Profit:** $100.92  
**Margin:** 52.2%

---

## 4. Summary Table

| Plan         | Price | Full/day | ATS/day | Multi-JD/day | Max Cost | Profit | Margin |
|--------------|-------|----------|---------|--------------|----------|--------|--------|
| Coffee       | $3    | 5        | 10      | 2            | $0.15    | $2.49  | 82%    |
| Basic        | $15   | 20       | 35      | 3            | $6.06    | $8.20  | 57.5%  |
| Pro          | $29   | 40       | 150     | 5            | $15.42   | $12.44 | 44.7%  |
| Enterprise   | $199  | 100      | 1,300   | 10           | $92.30   | $100.92| 52.2%  |

---

## 5. Key Insights

- **Coffee Crunch** remains highly profitable.
- **Basic** plan margin is now 57.5% at max usage (sustainable, but less room for discounts/support).
- **Pro** plan margin is 44.7% at max usage (acceptable for aggressive growth, but not SaaS-ideal).
- **Enterprise** plan margin is 52.2% at max usage (good for B2B, but not luxury).
- **All plans are now safe from bankruptcy at max abuse, but Pro is below the SaaS “sweet spot” margin.**

---

## 6. Recommendations

- If you want to restore 60%+ margins for Pro, consider:
  - Lowering ATS cap further (e.g., 100/day = $4.62/month for ATS, margin rises to 64%)
  - Raising price (e.g., $39/month = $37.46 after Stripe, margin rises to 58.8%)
- For Enterprise, you are in a safe margin zone for B2B.

---

**Let me know if you want a scenario with different caps or prices, or want this reflected in your config/rate limit logic!**