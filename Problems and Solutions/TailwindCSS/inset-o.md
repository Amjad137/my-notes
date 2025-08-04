## 🔹 `inset-0`

### 👉 What it means:

`inset-0` is a **shorthand utility** that applies:

```css
top: 0;
right: 0;
bottom: 0;
left: 0;
```

It stretches the element to cover its entire positioned parent.

### ✅ Use Case:

Used when you want an element (like an overlay, background, or absolute child) to fill its container completely.

### ✅ Example:

```jsx
<div className="relative w-64 h-64 bg-gray-300">
  <div className="absolute inset-0 bg-black/50" />
</div>
```

📌 This creates a semi-transparent black overlay **that fills the entire parent div**.