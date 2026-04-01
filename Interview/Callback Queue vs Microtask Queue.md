
# 🧠 First: Why are there TWO queues?

JavaScript doesn’t treat all async tasks equally.

👉 It prioritizes some tasks over others.

That’s why we have:

- **Callback Queue (Macrotask Queue)**
- **Microtask Queue**

---

# 🧩 1. Callback Queue (Macrotask Queue)

👉 Contains:

- `setTimeout`
- `setInterval`
- DOM events (event handlers)
- I/O operations

---

## 🧠 Think:

> “Normal async tasks”

---

# 🧩 2. Microtask Queue (HIGH PRIORITY)

👉 Contains:

- `Promise.then()`
- `Promise.catch()`
- `queueMicrotask()`

---

## 🧠 Think:

> “Urgent async tasks (run ASAP after current code)”

---

# ⚡ Key Difference (VERY IMPORTANT)

> 🥇 **Microtask queue has higher priority than callback queue**

---

# 🔁 Execution Order

Event loop follows this order:

1. Execute call stack
2. Check **microtask queue** → run ALL of them
3. Then take ONE task from **callback queue**
4. Repeat

---

# 💻 Example (INTERVIEW FAVORITE)

```js
console.log("Start");

setTimeout(() => {
  console.log("Timeout");
}, 0);

Promise.resolve().then(() => {
  console.log("Promise");
});

console.log("End");
```

---

## 👉 Output:

```id="2l28rr"
Start
End
Promise
Timeout
```

---

## 🧠 Why?

- `Start` → sync
- `End` → sync
- Promise → **microtask (runs first)**
- setTimeout → **callback queue (runs later)**

---

# 🎯 Interview Answer (clean version)

If they ask:

> “Difference between callback queue and microtask queue?”

---

You say:

> “The callback queue, also known as the macrotask queue, holds tasks like setTimeout, setInterval, and I/O operations. The microtask queue holds higher priority tasks such as Promise callbacks. The event loop always processes all microtasks before taking tasks from the callback queue, which is why Promise callbacks execute before setTimeout even if the delay is zero.”

---

# 🔥 Why this matters

This question is a **filter question**

If you answer this well: 👉 Interviewer knows you understand **JavaScript deeply**

---

# 🚀 Now your turn (important)

Explain this in your own words:

> Why does `Promise.then()` execute before `setTimeout(..., 0)`?

Don’t try to be perfect—just try. I’ll refine it.