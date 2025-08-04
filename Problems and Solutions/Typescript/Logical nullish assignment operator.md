Great question!

### `??=` in TypeScript (and JavaScript) is called the **logical nullish assignment operator**.

---

### 🔍 What does it do?

It only assigns a value **if the variable is `null` or `undefined`** (aka *nullish*).

```ts
foo ??= 'default';
```

This is roughly the same as:

```ts
if (foo === null || foo === undefined) {
  foo = 'default';
}
```

---

### ✅ Example

```ts
let name: string | undefined = undefined;

name ??= 'Guest';

console.log(name); // "Guest"
```

If `name` had been anything **other than** `null` or `undefined` (like an empty string `""`, `0`, `false`, etc.), the assignment would **not happen**.

---

### ⚠️ Compare with `||=`

```ts
let count = 0;
count ||= 10; // assigns 10 because 0 is falsy
```

```ts
let count = 0;
count ??= 10; // does NOT assign 10 because 0 is NOT null/undefined
```

So:
- `??=` → only applies if the value is `null` or `undefined`.
- `||=` → applies if the value is *falsy* (`false`, `0`, `''`, `null`, `undefined`, etc.).

---

### 🧠 Use Case

You’ll often use `??=` when assigning **defaults** without accidentally overriding valid but "falsy" values:

```ts
config.timeout ??= 3000;
```

This keeps `0` if it's intentionally set, but applies `3000` only if `timeout` was `undefined` or `null`.

---

Want to see a real-world use for it in a function or class setup?