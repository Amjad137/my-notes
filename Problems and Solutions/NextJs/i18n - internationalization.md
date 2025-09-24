Good question 👍 Let’s break it down.

---

## 🌍 What is **i18n**?

* **i18n** stands for **internationalization**.

  * It’s shorthand:

    * The word "internationalization" has **18 letters** between `i` and `n`. → `i18n`.
* It’s a **concept + practice**, not just a single package.

---

## 🧩 In development context

* It means **making your app support multiple languages, regions, and formats**.
* Includes:

  * Translating UI text.
  * Formatting **dates, times, numbers, currencies** based on locale.
  * Handling **right-to-left (RTL)** languages (like Arabic, Hebrew).
  * Managing **pluralization rules** (e.g., "1 item" vs. "2 items").

---

## 📦 Is it an npm package?

* **No — i18n itself is not a package.**
* But there are **npm libraries** that implement i18n in different frameworks:

  * `i18next` → most popular i18n library for React/Next.js/Node.
  * `next-intl` → i18n solution made for Next.js.
  * `react-intl` → for React apps, uses FormatJS.
  * `@nestjs/i18n` → for NestJS backend apps.

So, i18n is the **concept**, and these packages are **tools** to implement it.

---

## 🔑 Related Terms

* **l10n (localization):** Applying i18n to a specific locale (e.g., Sinhala, Tamil, English).
* **g11n (globalization):** The bigger strategy — supporting worldwide users.

---

✅ **Summary:**

* i18n = **concept/practice** of internationalization.
* Not an npm package by itself.
* You use **libraries** (like `i18next`) to implement it in your code.

---

Do you want me to show you how **Next.js handles i18n** out of the box (since you’re building with Next)?
