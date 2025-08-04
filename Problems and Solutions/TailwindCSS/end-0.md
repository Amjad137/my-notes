
## 🔹 `end-0`

### 👉 What it means:

`end-0` is a **logical positioning utility** that applies:

```css
inset-inline-end: 0;
```

### 📘 Translation:

It sets the **inline end** (which depends on text direction: left-to-right or right-to-left) to `0`. In **LTR (left-to-right)** languages (like English), this means **`right: 0`**.

In RTL (e.g., Arabic), it becomes **`left: 0`**.

### 🧠 Logical properties:

- `start` → left (in LTR)
    
- `end` → right (in LTR)
    
- These adjust automatically if text direction changes.
    

### ✅ Example:

```jsx
<div className="relative">
  <div className="absolute end-0 top-0 bg-red-500 w-4 h-4" />
</div>
```

📌 This places the red box at the **top-right corner** (or top-left in RTL layout).

---


---

## 🔁 Summary Table

| Class     | Effect                                 | Use Case                       |     |
| --------- | -------------------------------------- | ------------------------------ | --- |
| `end-0`   | `inset-inline-end: 0`                  | Positioning at inline-end edge |     |
| `inset-0` | `top: 0; right: 0; bottom: 0; left: 0` | Full stretch (absolute/fixed)  |     |
|           |                                        |                                |     |
