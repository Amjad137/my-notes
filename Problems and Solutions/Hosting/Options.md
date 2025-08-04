### **Estimated Cost Breakdown for Hosting on AWS (Amplify for Frontend, AWS for Backend, MongoDB Atlas for Database)**

Since you're using:  
✅ **AWS Amplify for the Next.js Frontend**  
✅ **AWS (Lambda, EC2, or App Runner) for the Hono.js Backend**  
✅ **MongoDB Atlas for Database Management**

I’ll divide the costs into **monthly and annual** estimates to give you a **clear financial expectation**.

---

### **💰 Estimated Monthly & Annual Cost Breakdown**

|**Service**|**Estimated Monthly Cost (LKR)**|**Estimated Monthly Cost (USD)**|**Estimated Annual Cost (LKR)**|**Estimated Annual Cost (USD)**|**Description**|
|---|---|---|---|---|---|
|**Frontend (AWS Amplify)**|**3,000 – 6,000**|**$10 – $20**|**36,000 – 72,000**|**$120 – $240**|**Covers hosting, bandwidth, and build minutes for Next.js.** Pricing varies based on app usage.|
|**Backend (AWS Lambda + API Gateway)**|**4,500 – 12,000**|**$15 – $40**|**54,000 – 144,000**|**$180 – $480**|**Serverless backend with pay-as-you-go pricing.** Pricing depends on API calls and execution time.|
|**MongoDB Atlas (Dedicated Cluster M10)**|**7,500 – 12,000**|**$25 – $40**|**90,000 – 144,000**|**$300 – $480**|**Managed NoSQL database. M10 is suitable for small-to-medium applications.**|
|**Cloud Storage (S3, if needed for file uploads)**|**1,500 – 3,000**|**$5 – $10**|**18,000 – 36,000**|**$60 – $120**|**Used for storing candidate resumes, contracts, and other documents.**|
|**Networking (AWS Route 53 for Domain & SSL)**|**1,500 – 3,000**|**$5 – $10**|**18,000 – 36,000**|**$60 – $120**|**Custom domain registration and SSL certificates.**|
|**Monitoring & Logging (AWS CloudWatch)**|**1,500 – 4,500**|**$5 – $15**|**18,000 – 54,000**|**$60 – $180**|**Monitoring and logging services for backend and frontend performance.**|
|**Support & Maintenance (Optional AWS Support Plan)**|**4,500 – 7,500**|**$15 – $25**|**54,000 – 90,000**|**$180 – $300**|**Basic support included in free tier, paid plans provide faster response times.**|
|**Total Estimated Cost (Monthly)**|**24,000 – 48,000**|**$80 – $160**|**Total Estimated Cost (Annually)**|**288,000 – 576,000**|**$960 – $1,920**|

---

### **📌 Key Insights on Cost Breakdown**

1. **AWS Amplify (Frontend) Costs**
    
    - **Starts at ~$10/month** for low traffic (~100k page loads).
    - Can **increase to $20–$30/month** if traffic scales (500k+ users).
2. **AWS Lambda + API Gateway (Backend) Costs**
    
    - **Pay-as-you-go model**, **cheaper than EC2 for moderate usage**.
    - **~$15/month** if API calls are low, **up to $40/month** if API calls increase.
3. **MongoDB Atlas Costs**
    
    - **M10 cluster (~$25/month)** is ideal for a small-to-medium manpower agency app.
    - Higher tiers (M20+) may be needed if query load increases.
4. **Cloud Storage & Networking Costs**
    
    - **If candidates upload resumes & contracts**, **S3 storage (~$5–10/month)** is required.
    - **Route 53 (domain + SSL) adds another $5–10/month.**
5. **Support Costs (Optional)**
    
    - Free support is **limited to community forums**.
    - **AWS Business Support starts at ~$15–$25/month**.

---

### **💡 Final Cost Summary**

- **Minimum Expected Cost:** **LKR 24,000/month (~$80)** → **LKR 288,000/year (~$960)**
- **Maximum Expected Cost (if usage grows):** **LKR 48,000/month (~$160)** → **LKR 576,000/year (~$1,920)**

✅ **Vercel is still cheaper (~$20/month for frontend), but AWS provides more control and scalability.**  
✅ **AWS is better if you need enterprise-grade security, custom networking, and compliance options.**

Would you like a **step-by-step AWS deployment guide for this setup?** 🚀