
```typescript
### **Understanding `Record<K, V>` in TypeScript**
The `Record<K, V>` utility type in TypeScript creates an object type where:
- **`K`** (key) is a string, number, or symbol.
- **`V`** (value) can be any type.

### **Example**
```ts
const filter: Record<string, any> = {};
```
This means `filter` is an object where:
- The **keys** must be of type `string`.
- The **values** can be of **any** type.

---

### **Practical Example**
```ts
const userRoles: Record<string, string> = {
  admin: "Full Access",
  user: "Limited Access",
  guest: "Read-Only",
};
```
✅ **Explanation**:
- The **keys** (`admin`, `user`, `guest`) are **strings**.
- The **values** (`"Full Access"`, `"Limited Access"`, `"Read-Only"`) are also **strings**.

---

### **Using `Record` with Custom Types**
```ts
type User = {
  name: string;
  age: number;
};

const users: Record<string, User> = {
  user1: { name: "Alice", age: 25 },
  user2: { name: "Bob", age: 30 },
};
```
✅ **Explanation**:
- The keys (`user1`, `user2`) are **strings**.
- The values are objects matching the `User` type `{ name: string; age: number }`.

---

### **When to Use `Record<K, V>`?**
1. When you want an **object with dynamic keys**.
2. When you want to **enforce a specific value type**.

```