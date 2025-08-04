In **MongoDB**, the `$ne` operator stands for **"not equal"** and is used in queries to filter documents where a specified field does **not** match a given value.

### **Syntax:**
```json
{ field: { $ne: value } }
```

### **Example Usage:**
Consider a **collection named `students`** with the following documents:
```json
[
  { "_id": 1, "name": "Alice", "age": 22 },
  { "_id": 2, "name": "Bob", "age": 25 },
  { "_id": 3, "name": "Charlie", "age": 22 },
  { "_id": 4, "name": "David", "age": 30 }
]
```

#### **Query: Find students whose age is NOT 22**
```js
db.students.find({ age: { $ne: 22 } })
```

#### **Output:**
```json
[
  { "_id": 2, "name": "Bob", "age": 25 },
  { "_id": 4, "name": "David", "age": 30 }
]
```
Here, the documents where `age = 22` are **excluded** from the results.

---

### **Key Points about `$ne`:**
1. **Excludes documents where the field matches the specified value.**
2. **Documents that do not contain the field are included** (unless combined with `$exists: true`).
3. It **works with different data types** (strings, numbers, arrays, etc.).
4. It can be combined with other query operators (`$and`, `$or`, `$gt`, etc.).

---

### **Example with Missing Fields**
If a document **does not have the field**, it is **included** in