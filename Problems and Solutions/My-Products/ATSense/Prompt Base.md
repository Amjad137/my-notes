
# 🚀 **MASTER PROMPT FOR CLAUDE (SUPASTARTER APP BUILD)**

**You are an expert senior full-stack engineer who specializes in:**

* Next.js 15 (App Router)
* Tailwind CSS
* Shadcn/UI
* Prisma
* Server Actions
* Vercel deployment
* AI integrations
* File upload systems
* PDF parsing
* Creem (Payment provider)
* Clean, modular architecture

You will help me build an AI-powered web app using my existing **Next.js Supastarter template**.

---

# 📌 **📁 PROJECT DESCRIPTION — "ATSense: AI CV Match & Analyzer"**

This is a **web-first SaaS** that allows job seekers to:

1. Upload their **CV (PDF/DOCX)**
2. Paste a **Job Description (JD)** or the Job URL
3. Get:

   * AI Match Score
   * Skill Gap Analysis
   * Weak bullet points
   * Suggested rewritten bullet points
   * ATS readability score
   * Overall suitability insights

This is the **core MDP**.

Laser-focused AI tool.

---

# 🧠 **CORE FEATURES TO IMPLEMENT**

## **1. Authentication (Already in Supastarter - BetterAuth)**

* Use existing auth system
* Users must be logged in to scan
* Track scan count per user

---

## **2. File Upload System**

Add a **CV Upload Component**:

* Accept PDF + DOCX (max 5MB)
* Extract text using a python script (let's discuss this deeply and separately, use a placeholdeer for now)
* Store original file in s3 storage
* Store extracted text in DB

---

## **3. Job Description Input**

- Use tab trigger to switch between Job url and the Job description
* Large textarea for JD
* Typical input for Url
* Auto-detect job title
* Validate minimum length

---

## **4. AI Processing Pipeline**

Build `/api/ats/analyze` (or server action):

Inputs:

* CV text
* Job Description text

Outputs (JSON):

* `matchScore` (0–100)
* `skillsMatched`
* `skillsMissing`
* `experienceRelevanceScore`
* `bulletWeaknesses`
* `rewrittenBullets`
* `atsReadabilityScore`
* `recommendations`

The AI should respond structurally, not free text.

---

## **5. UI: Dashboard**

Under `/dashboard`, include:

### **A. Upload CV → Step 1**

Component: `CVUploader.tsx`

* Drag & drop
* File preview
* Replace file

### **B. Paste JD → Step 2**

Component: `JDInput.tsx`

* Paste JD
* Show word count
* Real-time validation

### **C. Results → Step 3**

Component: `ATSResults.tsx`

Include:

* Circular Match Score
* Skill Gap Panel
* Weak Bullets Panel
* AI Rewrite Output
* ATS Score
* Download PDF (Pro only)
* Copy suggestions
* Save Scan

### **D. History Page**

Component: `ScanHistory.tsx`

* Paginated list
* Scan date
* Match score
* View details

---

## **6. Subscription Paywall**

Use Creem.

Tiers:

### **Free**

* 3 scans/day
* No export
* Limited AI depth

### **Pro**

* Unlimited scans
* Full rewriting
* Download PDF CV
* Priority AI

Ensure:
* middleware protects Pro features
* show paywall modal

---

## **7. Database Schema (Postgres / Prisma)**

### **User table**

### **CVs**

```
id
user_id
file_url
text_extracted
created_at
```

### **scans**

```
id
user_id
cv_id
jd_text
match_score
ats_score
skills_missing jsonb
skills_matched jsonb
rewritten_bullets jsonb
recommendations text
created_at
```

---

# 🏗 **CODE STRUCTURE (STRICT)**

```
app/
  dashboard/
    page.tsx
    upload/
    analyze/
    history/
  api/
    ats/
      analyze/route.ts
components/
  CVUploader.tsx
  JDInput.tsx
  ScoreCard.tsx
  ATSResults.tsx
  ScanHistory.tsx
lib/
  ai/
    parseCV.ts
    analyzeJD.ts
    scoringEngine.ts
  utils/
    extractText.ts
db/
  schema.prisma
```

---

# 💡 **AI Scoring Logic (Implement exactly)**

Match Score =

```
40% Skills Match  
30% Experience Relevance  
15% JD Keyword Coverage  
15% ATS Readability  
```

Return a structured JSON object.

---

# ✔ **DEVELOPMENT REQUIREMENTS**

* Learn the repo well and follow the existing coding pattern and practice everywhere
* Use **Server Actions** for secure AI calls
* Use **Zod** for input validation
* Use **Shadcn** components (Card, Input, Button, Progress, Dialog)
* All pages must be responsive
* Dashboard must be minimal and clean
* Code must be modular and production-ready
* No spaghetti components
* Follow modular approach everywhere, no lengthy files, break them down

---

# 📣 **FINAL INSTRUCTION TO YOU (CLAUDE)**

Your job is to:

1. Generate full code files
2. Use Supastarter’s existing layout & auth
3. Build everything in a real folder structure
4. Give exact components with no placeholders
5. Provide only clean, working code
6. Guide me to have proper ENV variables
7. Ensure everything runs without modification
8. Build the entire MVP end-to-end
