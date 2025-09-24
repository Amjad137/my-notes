Good question 👌

In **Zod**, `z.coerce.*` is used when you expect the input to come in as a **different type (usually a string, like from query params or JSON) but want to automatically convert it into the correct type** instead of rejecting it.

---

### In your case:

#### `skip` / `limit`

```ts
skip: z.coerce.number().min(0).default(0),
limit: z.coerce.number().min(1).max(100).default(10),
```

* Query params in HTTP requests are always **strings** (`?skip=5&limit=20`).
* Without `coerce`, Zod would reject `"5"` because it’s a string, not a number.
* With `z.coerce.number()`, `"5"` → `5` automatically.

---

#### `lastVisit`

```ts
lastVisit: z.coerce.date().optional(),
```

* Dates also come as strings in JSON or query params (e.g., `"2025-09-15T10:00:00Z"`).
* Without `coerce`, Zod would throw a validation error because it expects a `Date` object.
* With `z.coerce.date()`, `"2025-09-15T10:00:00Z"` → `new Date("2025-09-15T10:00:00Z")`.

---

### 🚀 Why is this useful?

* **Developer-friendly APIs**: You don’t have to manually parse `Number(req.query.skip)` or `new Date(req.body.lastVisit)`.
* **Cleaner code**: Validation + coercion handled in one place.
* **Safety**: Still runs validation (e.g., non-numeric strings like `"abc"` will fail).

---

👉 In short:
You’re using `coerce` because **HTTP request data is stringly-typed**, and `z.coerce` makes Zod smart enough to **convert strings into numbers/dates automatically** while still validating.

Do you want me to also show you the difference between using `z.number()` vs `z.coerce.number()` with an example request?
