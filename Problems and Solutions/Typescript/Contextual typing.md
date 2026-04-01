
# 🧠 Contextual Typing in TypeScript

## 📌 What is Contextual Typing?

**Contextual typing** is when TypeScript **automatically infers the type of a variable or parameter based on where it is used (the context)**.

👉 Instead of you explicitly writing types, TypeScript “figures it out” from the surrounding code.

---

## 🎯 Simple Definition

> Contextual typing means:
> **“The expected type of an expression is determined by its surrounding context.”**

---

# 🔍 Example 1 – Function Parameter Inference

```ts
type Listener = (event: { type: string }) => void;

function subscribe(listener: Listener) {}

subscribe((event) => {
  console.log(event.type);
});
```

### ✅ What’s happening?

* `subscribe` expects a function of type `Listener`
* So TypeScript infers:

  ```ts
  event: { type: string }
  ```

👉 You didn’t write the type — TypeScript inferred it from context.

---

# 🔍 Example 2 – Array Methods

```ts
const numbers = [1, 2, 3];

numbers.map((num) => {
  return num * 2;
});
```

### ✅ Here:

* `numbers` is `number[]`
* So `num` is inferred as `number`

👉 This is contextual typing from the array.

---

# 🔍 Example 3 – Event Handlers (Very Common)

```ts
document.addEventListener("click", (event) => {
  console.log(event.clientX);
});
```

### ✅ Here:

* TypeScript knows `"click"` → `MouseEvent`
* So `event` is inferred as `MouseEvent`

---

# 🔍 Example 4 – Your Event Bus Case

```ts
type Listener = (event: WebhookEvent) => void;

subscribe((event) => {
  console.log(event.type);
});
```

👉 TypeScript infers:

```ts
event: WebhookEvent
```

---

# 🔁 Without Contextual Typing

If contextual typing didn’t exist, you’d have to write:

```ts
subscribe((event: WebhookEvent) => {
  console.log(event.type);
});
```

👉 More verbose, less clean.

---

# ⚠️ When Contextual Typing DOESN’T Work

If TypeScript **can’t infer the context**, you must provide types manually:

```ts
const fn = (event) => {
  console.log(event.type);
};
```

❌ Error: `event` is `any`

✅ Fix:

```ts
const fn = (event: WebhookEvent) => {
  console.log(event.type);
};
```

---

# 🧠 Key Rules to Remember

* Works best with:

  * Function arguments
  * Callbacks (`map`, `filter`, `subscribe`)
  * Event handlers

* Doesn’t work when:

  * Function is standalone (no context)
  * Type cannot be inferred

---

# 🚀 Why Contextual Typing is Powerful

* Reduces boilerplate
* Improves readability
* Keeps code clean
* Still provides strong type safety

---

# 🎯 Interview-Ready Answer

> “Contextual typing in TypeScript is when the type of a variable or function parameter is inferred based on its surrounding context, such as when passing a callback to a function that expects a specific type. This allows us to write less explicit type annotations while still maintaining type safety.”

---

# 🔥 Final Mental Model

👉 Think of it like this:

> “I don’t tell TypeScript the type —
> TypeScript figures it out based on where I use it.”
