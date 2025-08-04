The `$in` operator in MongoDB is used to match documents where a field's value is **equal to any value in a specified array** — similar to SQL's `IN` clause.

---

### 🔹 Syntax:

```js
{ field: { $in: [ value1, value2, ... ] } }
```

It returns documents where the field matches **any one** of the values in the array.

---

### 📦 Example:

Suppose you have a `users` collection:

```json
{ "_id": 1, "name": "Alice", "role": "admin" }
{ "_id": 2, "name": "Bob", "role": "user" }
{ "_id": 3, "name": "Charlie", "role": "moderator" }
{ "_id": 4, "name": "David", "role": "user" }
```

To find all users whose role is either `"admin"` or `"moderator"`:

```js
db.users.find({
  role: { $in: ["admin", "moderator"] }
})
```

### 📄 Result:

```json
{ "_id": 1, "name": "Alice", "role": "admin" }
{ "_id": 3, "name": "Charlie", "role": "moderator" }
```

---

### 🧠 Notes:

* `$in` can be used with arrays too. If the field is an array, `$in` checks if **any element** matches.

Example:

```json
{ name: "Tom", tags: ["tech", "node"] }
{ name: "Sara", tags: ["food", "health"] }
```

Query:

```js
db.collection.find({
  tags: { $in: ["tech"] }
})
```

This matches Tom, because `"tech"` is in the `tags` array.

---

Would you like a comparison of `$in` vs `$or` or a performance tip?
