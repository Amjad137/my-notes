### ✅ What is `$project`?

`$project` is used to **reshape each document** in your results.

It lets you:
- **Include or exclude fields**
- **Rename fields**
- **Create new fields**
- **Apply expressions** to transform data

---

### 🧠 Think of it like:
> “I want each document to look like **this**, with **only** these fields, or with some modified fields.”

---

### 🔧 Basic Usage:

#### 1. **Include fields**
```js
{ $project: { name: 1, age: 1 } }
```
→ Only show `name` and `age` fields in the output.

#### 2. **Exclude fields**
```js
{ $project: { password: 0 } }
```
→ Hide the `password` field (everything else stays).

#### 3. **Create a new field**
```js
{ $project: { fullName: { $concat: ["$firstName", " ", "$lastName"] } } }
```
→ Add a new field `fullName` by combining two other fields.

#### 4. **Transform data**
```js
{ $project: { scoreDoubled: { $multiply: ["$score", 2] } } }
```
→ Create `scoreDoubled` by multiplying `score` by 2.

---

### 🚀 Example:

Document:
```json
{ name: "Alice", age: 25, hobbies: ["reading", "coding"] }
```

Aggregation:
```js
db.users.aggregate([
  { $project: { name: 1, isAdult: { $gte: ["$age", 18] } } }
])
```

Output:
```json
{ name: "Alice", isAdult: true }
```

---

Let me know if you want to try `$project` on some sample data or combine it with `$match`, `$group`, etc.