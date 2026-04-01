# 🚀 **ATSense – Feature Expansion Master Prompt**

You are an **expert senior full-stack SaaS engineer** with deep experience in:

* Next.js 15 (App Router)
* Supastarter architecture
* BetterAuth (users, orgs, memberships, roles)
* Prisma + Postgres
* Tailwind + Shadcn/UI
* Server Actions
* AI-driven structured pipelines
* Subscription & entitlement systems
* Scalable, modular UI patterns

You will extend the existing **ATSense** application (AI CV Match & Analyzer).
Refer the Docremark repo for all the practice and patterns, specifically for Team management and multi tenant architecture

---

## 📌 **PROJECT CONTEXT (DO NOT REBUILD EXISTING FEATURES)**

ATSense already supports:

* Auth via **BetterAuth**
* Individual CV → Single JD analysis
* AI structured scoring pipeline
* Dashboard, scan history, paywall, subscriptions

Your task is to **ADD TWO MAJOR FEATURES**, not rewrite or break existing ones.

---

# 🧠 **FEATURE 1: One CV → Multiple Job Descriptions Matching**

### 🎯 Goal

Allow a user to upload **one CV** and compare it against **multiple Job Descriptions**, then:

* Automatically **rank all JDs**
* Generate **AI-written headlines per JD**
* Display results as **independent score cards**
* Clearly show **best match**

---

## 🔹 User Flow

1. User uploads **one CV**
2. User provides **multiple JDs** via:

   * Multiple pasted JDs
   * OR multiple Job URLs
3. User clicks **“Analyze All”**
4. AI processes **each JD independently**
5. Results are shown as **multiple cards**, sorted by match score

---

## 🔹 AI Responsibilities

For **each JD**, AI must return a **strict structured response**:

```ts
{
  jdTitle: string,               // AI-inferred or improved
  matchScore: number,            // 0–100
  skillsMatched: string[],
  skillsMissing: string[],
  experienceRelevanceScore: number,
  atsReadabilityScore: number,
  headline: string,              // AI-generated, e.g.:
                                  // "Strong Backend Match – Minor Skill Gaps"
  summaryInsight: string         // 1–2 sentence insight
}
```

### 🔢 Scoring Formula (MANDATORY)

```
40% Skills Match
30% Experience Relevance
15% JD Keyword Coverage
15% ATS Readability
```

---

## 🔹 UI Requirements

### Component: `MultiJDResults.tsx`

* Render **cards per JD**
* Each card includes:

  * Headline (AI-generated)
  * Circular Match Score
  * Top matched skills
  * Missing skills
  * “Best Match” badge for highest score
* Cards must be:

  * Responsive
  * Sortable
  * Visually comparable
* Clicking a card opens **full ATS analysis**

---

## 🔹 Database Changes

### New Table: `multi_scans`

```prisma
model MultiScan {
  id          String   @id @default(cuid())
  userId      String
  cvId        String
  createdAt  DateTime @default(now())

  results     Json     // array of JD analysis objects
}
```

---

## 🔹 Access Control

* **Free users**: max **3 JDs per batch**
* **Pro users**: unlimited JDs
* Enforce limits at **server action level**

---

# 🧠 **FEATURE 2: Community / Team Subscription (Org-Based)**

### 🎯 Goal

Enable **shared usage** through **organizations**, allowing users to:

* Subscribe once
* Invite friends
* Share scan limits & Pro benefits

This must **leverage Supastarter’s existing BetterAuth org system**.
Refer docremark-mono project for the architecture, patterns and practice
follow the same 100%

---

## 🔹 Core Concept

> One **Organization** = One **Subscription**

All members inherit entitlements from the org.

---

## 🔹 Roles (Use BetterAuth Roles)

| Role   | Capabilities                       |
| ------ | ---------------------------------- |
| OWNER  | Subscribe, manage members, billing |
| ADMIN  | Invite/remove users                |
| MEMBER | Use scans, view shared history     |

---

## 🔹 Subscription Logic

* Subscription is attached to **org_id**, not user_id
* Scan limits apply **per org**
* Scan history is:

  * Visible to all org members
  * Filterable by user

---

## 🔹 Invite Flow

### Component: `InviteMemberDialog.tsx`

* Email-based invite
* Assign role
* Pending invite state
* Accept / Reject flow

---

## 🔹 Shared Features

* Shared scan pool
* Shared CVs (optional toggle)
* Shared history dashboard

---

## 🔹 Database Additions

```prisma
model OrganizationSubscription {
  id        String   @id @default(cuid())
  orgId     String   @unique
  plan      String   // free | pro
  status    String
  createdAt DateTime @default(now())
}
```

---

## 🔹 Middleware Enforcement

* Protect:

  * Pro-only features
  * Multi-JD limits
  * Export actions
* Check entitlement via:

  * `org.subscription.plan`

---

# 🏗 **STRICT ARCHITECTURE RULES**

* Use **Server Actions only** for:

  * AI calls
  * Billing checks
  * Limit enforcement
* Use **Zod** everywhere for validation
* Use **Shadcn/UI only**
* No monolithic components
* No inline business logic in UI
* Follow Supastarter’s folder & auth patterns exactly

---

# 📦 **Expected Output FROM YOU**

You must:

1. Provide **production-ready code**
2. Respect existing Supastarter patterns
3. Extend Prisma schema safely
4. Build clean, modular components
5. Include entitlement logic
6. Ensure everything runs without hacks

---

## 🚫 HARD CONSTRAINTS

* No placeholder logic
* No vague explanations
* No breaking existing features
* No rewriting auth
* No free-text AI responses
* No UI bloat

---

## 🏁 FINAL NOTE

This is a **real SaaS**, not a prototype.
Code quality, architecture, and maintainability are **non-negotiable**.

