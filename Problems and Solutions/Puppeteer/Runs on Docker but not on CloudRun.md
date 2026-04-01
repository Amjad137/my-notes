Yep — this one is **100% expected on Cloud Run** and has nothing to do with your routing logic.
You’re hitting the **classic Puppeteer-on-serverless problem**.

Let’s fix it cleanly.

---

## What’s actually happening (plain English)

Your error says:

```
Could not find Chrome (ver. 144.0.7559.96)
cache path: /home/api/.cache/puppeteer
```

Meaning:

* Puppeteer is trying to launch **Chrome**
* Your container **does NOT have Chrome installed**
* Cloud Run images **do not include a browser**
* Puppeteer **does not auto-download Chrome in production**

Locally it works because:

* Chrome exists on your machine
* Or Puppeteer downloaded it earlier

In Cloud Run:

* Fresh container
* No Chrome
* Read-only filesystem (mostly)
* Boom 💥

---

## The ONLY two correct ways to run Puppeteer on Cloud Run

### 🟢 Option A (Recommended): **Use `puppeteer-core` + system Chrome**

This is the **production-grade** approach.

### 🟡 Option B: Let Puppeteer download Chrome during build (works, but heavier)

I’ll show **Option A**, because it’s the right one for SaaS.

---

## ✅ Correct solution (Option A – do this)

### 1️⃣ Switch to `puppeteer-core`

In your API package:

```bash
pnpm remove puppeteer
pnpm add puppeteer-core
```

---

### 2️⃣ Install Chrome inside the Docker image

Add this to your **Dockerfile** (IMPORTANT section):

```dockerfile
# --- Install Chromium dependencies ---
RUN apk add --no-cache \
  chromium \
  nss \
  freetype \
  harfbuzz \
  ca-certificates \
  ttf-freefont
```

On Alpine:

* Chrome binary path = `/usr/bin/chromium-browser` or `/usr/bin/chromium`

---

### 3️⃣ Launch Puppeteer correctly in code

Update your PDF code:

```ts
import puppeteer from "puppeteer-core";

const browser = await puppeteer.launch({
  executablePath: "/usr/bin/chromium-browser",
  args: [
    "--no-sandbox",
    "--disable-setuid-sandbox",
    "--disable-dev-shm-usage",
    "--disable-gpu",
    "--no-zygote",
    "--single-process"
  ],
});
```

☝️ **These flags are mandatory on Cloud Run**

---

### 4️⃣ Set cache dir (important for Cloud Run)

Cloud Run allows writes only to `/tmp`.

Before launching Puppeteer:

```ts
process.env.PUPPETEER_CACHE_DIR = "/tmp/puppeteer";
```

Or in Dockerfile:

```dockerfile
ENV PUPPETEER_CACHE_DIR=/tmp/puppeteer
```

---

## Why your current setup fails (so you trust the fix)

* Puppeteer expects Chrome in:

  ```
  /home/api/.cache/puppeteer
  ```
* That path:

  * Doesn’t exist
  * Isn’t writable
* Cloud Run **kills the browser launch**

---

## Common mistakes to avoid (important)

❌ Using `puppeteer` (full) in Cloud Run
❌ Relying on auto-download in prod
❌ Not passing `--no-sandbox`
❌ Using default cache path
❌ Assuming Chrome exists in Node images

---

## Memory & CPU recommendation (PDF generation)

PDF rendering is heavy.

Set for **API service**:

* **Memory:** 1 GiB (minimum)
* **CPU:** 1 vCPU (2 if PDFs are large)

Otherwise you’ll get random crashes.

---

## TL;DR (do these 5 things)

1. Use `puppeteer-core`
2. Install `chromium` in Dockerfile
3. Use `executablePath`
4. Pass `--no-sandbox` flags
5. Set cache dir to `/tmp`

After this:

* PDF generation works
* No Chrome errors
* Cloud Run stable

---

If you want, paste:

* your **PDF generation function**
* or your **API Dockerfile**

I’ll patch it **line-by-line** so you don’t miss anything.
