
### **What is `$match` in MongoDB?**

`$match` is an **aggregation stage** in MongoDB that **filters documents** based on a condition, similar to the `find()` query but used inside an aggregation pipeline.

---

## **Syntax**

```json
{ $match: { field: { operator: value } } }
```

- It **filters** documents that meet the specified condition.
- Works like the `WHERE` clause in SQL.
- Can use comparison operators like `$eq`, `$gt`, `$lt`, `$regex`, etc.

---

## **Example 1: Simple Filtering**

### **Scenario**: You have a `products` collection with this data:

```json
[
  { "_id": 1, "name": "Laptop", "category": "Electronics", "price": 1000 },
  { "_id": 2, "name": "Phone", "category": "Electronics", "price": 500 },
  { "_id": 3, "name": "Shirt", "category": "Clothing", "price": 30 },
  { "_id": 4, "name": "TV", "category": "Electronics", "price": 700 }
]
```

### **Query: Get all `Electronics` products**

```js
db.products.aggregate([
  { $match: { category: "Electronics" } }
]);
```

### **Output**

```json
[
  { "_id": 1, "name": "Laptop", "category": "Electronics", "price": 1000 },
  { "_id": 2, "name": "Phone", "category": "Electronics", "price": 500 },
  { "_id": 4, "name": "TV", "category": "Electronics", "price": 700 }
]
```

✅ **Only "Electronics" items are returned.**

---

## **Example 2: Using `$gt` (Greater Than)**

### **Query: Get products with `price > 500`**

```js
db.products.aggregate([
  { $match: { price: { $gt: 500 } } }
]);
```

### **Output**

```json
[
  { "_id": 1, "name": "Laptop", "category": "Electronics", "price": 1000 },
  { "_id": 4, "name": "TV", "category": "Electronics", "price": 700 }
]
```

✅ **Only products with `price > 500` are included.**

---

## **Example 3: Using `$regex` for Partial Matching**

### **Query: Find products with names that contain `"Lap"` (case-insensitive)**

```js
db.products.aggregate([
  { $match: { name: { $regex: "Lap", $options: "i" } } }
]);
```

### **Output**

```json
[
  { "_id": 1, "name": "Laptop", "category": "Electronics", "price": 1000 }
]
```

✅ **Matches `"Laptop"` because it contains `"Lap"` (case-insensitive).**

---

## **Example 4: Using `$match` with Multiple Conditions**

### **Query: Get `Electronics` products with `price > 600`**

```js
db.products.aggregate([
  { $match: { category: "Electronics", price: { $gt: 600 } } }
]);
```

### **Output**

```json
[
  { "_id": 1, "name": "Laptop", "category": "Electronics", "price": 1000 },
  { "_id": 4, "name": "TV", "category": "Electronics", "price": 700 }
]
```

✅ **Filters by category AND price.**

---

## **Example 5: Using `$match` with `$or`**

### **Query: Get products where `category` is "Electronics" OR `price < 50`**

```js
db.products.aggregate([
  { $match: { $or: [ { category: "Electronics" }, { price: { $lt: 50 } } ] } }
]);
```

### **Output**

```json
[
  { "_id": 1, "name": "Laptop", "category": "Electronics", "price": 1000 },
  { "_id": 2, "name": "Phone", "category": "Electronics", "price": 500 },
  { "_id": 3, "name": "Shirt", "category": "Clothing", "price": 30 },
  { "_id": 4, "name": "TV", "category": "Electronics", "price": 700 }
]
```

✅ **Includes all "Electronics" and the "Shirt" (since it's `price < 50`).**

---

### **Why Use `$match`?**

1. **Filters data early in the pipeline** (improves performance).
2. **Reduces the number of documents** processed in later stages.
3. **Supports complex queries** using operators like `$gt`, `$lt`, `$regex`, etc.

---

### **Where `$match` is Used in Your Code**

#### **Original Code**

```typescript
const pipeline: any[] = [];

if (Object.keys(additionalFilters).length > 0) {
  pipeline.push({ $match: additionalFilters });
}
```

#### **Explanation**

- **If `additionalFilters` exist**, `$match` is added to the pipeline.
- This **removes unnecessary documents** before grouping/counting.

---

### **Summary**

|Operator|Description|
|---|---|
|`$match`|Filters documents before processing|
|`$eq`|Matches exact values|
|`$gt` / `$lt`|Greater than / Less than filtering|
|`$regex`|Matches patterns in string fields|
|`$or`|Matches documents that meet **at least one** condition|

Would you like me to explain anything further? 😊