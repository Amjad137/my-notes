
## Understanding `$sum: 1` in Aggregation**

Now, let's dive into why we use `$sum: 1` in the **`$group`** stage.

### **How `$sum: 1` Works**

The `$sum` operator **adds values together** when grouping documents.

- If you write `{ $sum: 1 }`, it **adds 1 for each document** in the group, effectively **counting documents**.
- If you write `{ $sum: "$price" }`, it **adds up the `price` values** for all documents in the group.

---

### **Example 1: Counting Documents with `$sum: 1`**

Suppose we have a **`products`** collection:

|_id|name|category|
|---|---|---|
|1|Laptop|Electronics|
|2|Keyboard|Electronics|
|3|Mouse|Electronics|
|4|Book A|Books|
|5|Book B|Books|
|6|T-shirt|Clothing|

Now, we **group by `category` and count the number of products per category**.

### **Aggregation Query:**

```json
[
  {
    "$group": {
      "_id": "$category",
      "count": { "$sum": 1 }
    }
  }
]
```

### **MongoDB Processing Steps:**

1. The database **groups products by `category`**.
2. For each document, it adds **`1`** to the count.
3. The final output:

```json
[
  { "category": "Electronics", "count": 3 },
  { "category": "Books", "count": 2 },
  { "category": "Clothing", "count": 1 }
]
```

📌 **Why `$sum: 1`?**

- Each document contributes **1** to the total count.
- It **counts the number of documents in each group**.

---

### **Example 2: Summing a Field (`$sum: "$price"`)**

Let's say we have the following `sales` collection:

|_id|product|category|price|
|---|---|---|---|
|1|Laptop|Electronics|1000|
|2|Mouse|Electronics|50|
|3|Book A|Books|30|
|4|Book B|Books|20|

If we want to find the **total revenue per category**, we **sum the `price` field instead of 1**.

### **Aggregation Query:**

```json
[
  {
    "$group": {
      "_id": "$category",
      "totalRevenue": { "$sum": "$price" }
    }
  }
]
```

### **Final Output:**

```json
[
  { "category": "Electronics", "totalRevenue": 1050 },
  { "category": "Books", "totalRevenue": 50 }
]
```

📌 **Why `$sum: "$price"`?**

- Instead of counting documents, it **adds up the `price` values**.

---

## ** Why Use `$sum: 1` vs `$sum: "$field"`?**

| **Use Case**              | **Operator**          | **Example**          | **Purpose**                                    |
| ------------------------- | --------------------- | -------------------- | ---------------------------------------------- |
| Count documents per group | `{ $sum: 1 }`         | Count users per city | Counts how many documents exist in each group. |
| Sum values of a field     | `{ $sum: "$amount" }` | Total sales revenue  | Adds up values of a field.                     |

---

## ** Combining `$sum: 1` with Other Stages**

### **Example: Counting Users Per City, Filtering Active Users**

If we want to count **only active users per city**, we add a **`$match`** stage before `$group`.

```json
[
  { "$match": { "status": "active" } },
  {
    "$group": {
      "_id": "$city",
      "count": { "$sum": 1 }
    }
  },
  { "$sort": { "count": -1 } }
]
```

- **First, MongoDB filters users where `"status": "active"`**.
- **Then, it groups them by `city` and counts them**.
- **Finally, it sorts cities from most to least users**.

✅ **Why `$sum: 1`?**

- It **counts documents** in each group **by adding `1` per document**.
- Works like **SQL COUNT(*)**.

### ✅ **When to Use `$sum: 1` vs `$sum: "$field"`?**

|**Goal**|**Operator**|
|---|---|
|Count documents|`{ $sum: 1 }`|
|Sum a field’s values|`{ $sum: "$field" }`|
