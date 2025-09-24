Great question 👍 Let’s break down **`.lean()` in Mongoose (MongoDB ODM)** in **simple terms**.

---

## 🔹 What is `.lean()`?

When you query MongoDB with **Mongoose**, by default it returns a **Mongoose Document**.

* A **Mongoose Document** is not just plain JSON—it’s an object with **extra methods and features** (like `.save()`, virtuals, getters/setters, middleware hooks).
* `.lean()` tells Mongoose:
  👉 “Don’t give me a full Mongoose Document, just return plain JavaScript objects directly from MongoDB.”

---

## 🔹 Why use `.lean()`?

* **Performance** 🚀: Skips building the Mongoose Document wrapper → queries run faster, less memory used.
* **Read-only results**: Since you don’t need `.save()` or other Mongoose methods, a plain object is enough.
* **Lightweight**: Best when fetching lots of records, like for APIs or reporting.

---

## 🔹 Example

```js
// Without lean()
const user = await User.findOne({ email: "test@example.com" });
console.log(user instanceof mongoose.Document); // true
console.log(user.save); // exists (method from Mongoose)

// With lean()
const user = await User.findOne({ email: "test@example.com" }).lean();
console.log(user instanceof mongoose.Document); // false
console.log(user.save); // undefined (just a plain object)
```

---

## 🔹 When NOT to use `.lean()`

* If you need **Mongoose features**:

  * Virtuals
  * Getters/setters
  * Default values
  * Middleware hooks
  * `.save()` method

Then don’t use `.lean()`.

---

✅ **Summary**:
`.lean()` = “Give me plain objects, skip the Mongoose overhead.”
Best for **read-heavy queries** where you don’t modify and save the documents later.

---

👉 Do you want me to also explain **`.lean()` vs `.toObject()`**, since both give you plain objects but are used differently?
