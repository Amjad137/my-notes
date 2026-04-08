# 🧠 Core Idea (Don’t memorize, understand this)

### ✅ `useMemo`

> “Cache a **value** so it doesn’t recompute”

### ✅ `useCallback`

> “Cache a **function** so it doesn’t get recreated”

---

# 🔥 The REAL difference (important)

| Hook          | Stores                   | Prevents                |
| ------------- | ------------------------ | ----------------------- |
| `useMemo`     | **Result of a function** | Expensive recalculation |
| `useCallback` | **Function itself**      | Unnecessary re-creation |

---

# 🧪 1. `useMemo` — Caching computed values

### ❌ Problem

```tsx
const expensiveValue = expensiveCalculation(data);
```

Every render → recalculates 😓

---

### ✅ Solution

```tsx
const expensiveValue = useMemo(() => {
  return expensiveCalculation(data);
}, [data]);
```

Now:

* Runs only when `data` changes
* Skips heavy computation

---

### 💡 Real-world example

```tsx
const filteredUsers = useMemo(() => {
  return users.filter(u => u.active);
}, [users]);
```

👉 Without `useMemo`, filtering runs on every render

---

# 🧪 2. `useCallback` — Caching functions

### ❌ Problem

```tsx
const handleClick = () => {
  console.log("clicked");
};
```

Every render → new function created 😓

This causes:

* child components to re-render
* `useEffect` dependencies to retrigger

---

### ✅ Solution

```tsx
const handleClick = useCallback(() => {
  console.log("clicked");
}, []);
```

Now:

* same function reference across renders

---

### 💡 Real-world example

```tsx
const handleDelete = useCallback((id) => {
  deleteUser(id);
}, []);
```

Useful when passing to:

```tsx
<Child onDelete={handleDelete} />
```

---

# ⚠️ SUPER IMPORTANT (Most people miss this)

### ❗ `useCallback` is actually built using `useMemo`

```tsx
useCallback(fn, deps)
// is basically:
useMemo(() => fn, deps)
```

So:

👉 `useCallback` = specialized `useMemo` for functions

---

# 🧠 When to use what (practical thinking)

## ✅ Use `useMemo` when:

* Expensive calculation
* Filtering / sorting large data
* Derived state

## ✅ Use `useCallback` when:

* Passing functions to child components
* Preventing unnecessary re-renders (React.memo)
* Stable dependency in `useEffect`

---

# 🚫 When NOT to use (very important for interviews)

### ❌ Don’t overuse

Bad:

```tsx
const x = useMemo(() => a + b, [a, b]);
```

👉 This is useless (cheap calculation)

---

### ❌ Don’t wrap everything in `useCallback`

It adds:

* memory overhead
* complexity

---

# 🧪 Small Combined Example

```tsx
const filtered = useMemo(() => {
  return users.filter(u => u.active);
}, [users]);

const handleSelect = useCallback((id) => {
  console.log(id);
}, []);

return <List data={filtered} onSelect={handleSelect} />;
```

---

# 🎯 Final Interview Answer (clean & powerful)

> `useMemo` is used to memoize computed values to avoid expensive recalculations, while `useCallback` is used to memoize function references to prevent unnecessary re-renders.
> Internally, `useCallback` is just a specialized version of `useMemo` for functions.

---

If you want, I can next explain:
👉 **React.memo + useCallback + useMemo combo (real optimization pattern)** — this is where interviews usually go deeper.
