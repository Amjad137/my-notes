In JavaScript, object keys can be defined using **bracket notation (`[]`)** when the key is **dynamic** (i.e., a variable or an expression). Let's break down why brackets are used in this context.

---

### **1️⃣ Basic Object Property Definition (Dot vs. Bracket Notation)**

Normally, we define object properties like this:

```js
const obj = {
  key1: "value1",
  key2: "value2",
};
console.log(obj.key1); // "value1"
```

Here, `"key1"` and `"key2"` are **static keys**.

However, **if the key needs to be dynamic (based on a variable or expression), we must use bracket notation (`[]`)**:

```js
const dynamicKey = "userRole";
const obj = {
  [dynamicKey]: "Admin",
};
console.log(obj.userRole); // "Admin"
```

Without brackets (`[dynamicKey]`), JavaScript would treat `"dynamicKey"` as a **literal property name**, not as a variable.

---

### **2️⃣ Applying This to Your Code**

In your case, the `routesMapping` object is created with **computed properties**:

```js
const routesMapping = {
  [UserRole.MERCHANT]: userState.isNewUser ? '/auth/change-password' : '/',
  [UserRole.ADMIN]: isAdminWithAccountSubRole
    ? userState.isNewUser
      ? '/auth/change-password'
      : '/admin/reports'
    : '/admin/merchants',
  [UserRole.SUPER_ADMIN]: userState.isNewUser ? '/auth/change-password' : '/admin/merchants',
  ['']: '/auth/login', // Default case for an empty userRole
};
```

Here:

- `[UserRole.MERCHANT]`, `[UserRole.ADMIN]`, and `[UserRole.SUPER_ADMIN]` are **computed keys**.
- The values of `UserRole.MERCHANT`, `UserRole.ADMIN`, etc., are **variables**, not static strings.
- The key `['']` (empty string) is explicitly set as a fallback.

---

### **3️⃣ Why Not Use a Normal Key?**

If we wrote:

```js
const routesMapping = {
  UserRole.MERCHANT: '/auth/change-password', // ❌ Wrong!
};
```

JavaScript would think `"UserRole.MERCHANT"` is a **literal string**, not a variable.

Instead, using **bracket notation (`[]`)** allows JavaScript to evaluate `UserRole.MERCHANT` and use its actual value as the key.

---

### **4️⃣ Dynamic Key Access**

Later, when we retrieve a value using:

```js
const route = routesMapping[userState.userRole ?? ''];
```

- `userState.userRole` dynamically determines the **key**.
- If `userState.userRole` is `"MERCHANT"`, then it fetches `routesMapping["MERCHANT"]`.

This works only because the object was **defined with computed keys (`[]`)**.

---

### **Conclusion**

🔹 **Brackets (`[]`) allow us to use variables or expressions as object keys instead of static strings.**  
🔹 Without `[]`, JavaScript treats the key as a **literal string** instead of evaluating its value.  
🔹 It is necessary when working with dynamic property names in objects.