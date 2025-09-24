# [...rest] and [[[[...res]]]]

Great question 👍 — this comes straight from **Next.js App Router routing syntax**.

---

## 1. `[param]` → Dynamic Segment

* Matches **a single part of the URL**.

```tsx
// file: app/[id]/page.tsx
// URL: /123 → params.id = "123"
```

---

## 2. `[...rest]` → Catch-all Segment

* Matches **one or more segments** of the URL.
* Params become an **array**.

```tsx
// file: app/[...rest]/page.tsx
// URL: /a → params.rest = ["a"]
// URL: /a/b/c → params.rest = ["a","b","c"]
```

---

## 3. `[[...rest]]` → Optional Catch-all Segment

* Same as `[...rest]`, **but optional**.
* If no segment is provided, it still matches (with `undefined`).

```tsx
// file: app/[[...rest]]/page.tsx
// URL: / → params.rest = undefined
// URL: /x → params.rest = ["x"]
// URL: /x/y → params.rest = ["x","y"]
```

---

## ⚡ Difference between `[...rest]` and `[[...rest]]`

| Syntax        | Matches `/` (root)? | Example URLs | Resulting Params          |
| ------------- | ------------------- | ------------ | ------------------------- |
| `[...rest]`   | ❌ No                | `/a/b/c`     | `{ rest: ["a","b","c"] }` |
| `[[...rest]]` | ✅ Yes               | `/`          | `{ rest: undefined }`     |
|               |                     | `/a`         | `{ rest: ["a"] }`         |

---

## Your Example

* `apps\web\app\(saas)\app\[...rest]\page.tsx`
  → This page **requires at least one segment** (e.g. `/app/foo/bar`).

* `apps\web\app\api\[[...rest]]\route.ts`
  → This API route works at `/api` directly **and** at `/api/foo/bar/...`.

---

✅ Rule of Thumb:

* Use **`[...rest]`** when you want a **mandatory catch-all** (never `/`).
* Use **`[[...rest]]`** when you want it to also match the **root (optional)**.

---

Do you want me to show you a **real example where both are useful in a SaaS app** (e.g. multi-tenant dashboard with `/app/[...rest]` and API routing with `/api/[[...rest]]`)?
