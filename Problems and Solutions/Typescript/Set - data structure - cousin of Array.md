Alright, let’s talk about **`Set`** in TypeScript — it’s like the cousin of `Array`, but with a few quirks that make it super useful 👇

---

## 🎯 What is a `Set`?

A **`Set`** is a collection of **unique values**.

> ✅ No duplicates allowed  
> 🔄 Maintains **insertion order**

---

## 🧱 Basic Syntax

```ts
const mySet = new Set<Type>();
```

Example:

```ts
const numbers = new Set<number>();

numbers.add(1);
numbers.add(2);
numbers.add(2); // ignored (duplicate)

console.log(numbers); // Set { 1, 2 }
```

---

## 🧠 Set Methods

| Method            | What it does                           |
|------------------|----------------------------------------|
| `.add(value)`     | Add a value (if not already there)     |
| `.has(value)`     | Check if a value exists                |
| `.delete(value)`  | Remove a value                         |
| `.clear()`        | Remove all values                      |
| `.size`           | Get number of elements in the set      |
| `.forEach()`      | Loop through the Set                   |
| `for...of` loop   | Iterate like an array                  |

---

## 🔁 Example: Working with Sets

```ts
const names = new Set<string>();

names.add('Alice');
names.add('Bob');
names.add('Alice'); // ignored

console.log(names.has('Bob')); // true
console.log(names.size); // 2

for (const name of names) {
  console.log(name);
}
```

---

## ✨ Why use Set instead of Array?

Let’s say you're trying to store a list of **unique tags**:

```ts
const tags = new Set(['math', 'science', 'math', 'history']);

console.log([...tags]); // ['math', 'science', 'history']
```

This avoids having to manually filter duplicates like you would with arrays.

---

## ⚙️ Convert between Set and Array

```ts
const arr = ['a', 'b', 'a', 'c'];
const set = new Set(arr); // remove duplicates

const uniqueArr = [...set]; // back to array
```

---

## 🧩 Use Case Examples

- ✅ Removing duplicates from an array
- 📚 Tracking selected items in a UI
- 🔄 Ensuring no repeated API calls
- 🧠 Memoizing inputs for optimization

---

### Want a real example?

Let me know what context you're in (e.g., form validation, roles, filters, etc.), and I’ll show how `Set` can simplify it 🔧