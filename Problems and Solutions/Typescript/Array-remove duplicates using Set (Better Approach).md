Here’s the **cleanest, modern, most readable** way to remove duplicates 👇

---

# ✅ **Using Set (recommended)**

```js
const trustedOrigins = [...new Set([appUrl, ...externalUrls])];
```

### Why this is better:

* No filter callback
* No `indexOf` logic
* Faster + cleaner
* Instantly removes duplicates
* Very readable

---

# 🔍 Breakdown

### Step 1 — Combine values

```js
[appUrl, ...externalUrls]
```

### Step 2 — Put into a Set

```js
new Set([...])
```

* A Set **cannot contain duplicates**
* So duplicates are automatically removed

### Step 3 — Convert back to array

```js
[...new Set(...)]
```

---

# 🎯 Final result

`trustedOrigins` becomes an array of **unique values**.

---

# ⭐ If you want even more readable code

```js
const combined = [appUrl, ...externalUrls];
const uniqueOrigins = [...new Set(combined)];
```

Or even:

```js
const toUniqueArray = (arr) => [...new Set(arr)];

const trustedOrigins = toUniqueArray([appUrl, ...externalUrls]);
```

---

If you want, I can also explain **why the original `filter()` trick is still used**, and which one is more efficient (with real-world examples).
