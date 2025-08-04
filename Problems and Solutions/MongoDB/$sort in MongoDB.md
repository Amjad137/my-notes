
The `-1` in `{ "$sort": { "count": -1 } }` is used to **sort the results in descending order**.

### **How Sorting Works in MongoDB**

The `$sort` stage is used to **arrange documents in a specific order** based on a field's value. It accepts an object where:

- **`1`** means **ascending order** (smallest to largest).
- **`-1`** means **descending order** (largest to smallest).

---

### **Example: Sorting in Descending Order (`-1`)**

Imagine you have this aggregation query:

```json
[
  {
    "$group": {
      "_id": "$category",
      "count": { "$sum": 1 }
    }
  },
  {
    "$sort": { "count": -1 }
  }
]
```

#### **Example Input Data (`products` collection):**

|_id|name|category|
|---|---|---|
|1|Laptop|Electronics|
|2|Mouse|Electronics|
|3|Book A|Books|
|4|Book B|Books|
|5|T-shirt|Clothing|

#### **Processing Steps:**

1. **`$group`**: Groups by `category` and **counts the number of products** in each category.
2. **`$sort`**: Orders the results by `count` in **descending order** (`-1`).

#### **Final Output (Sorted by Count Descending):**

```json
[
  { "category": "Electronics", "count": 2 },
  { "category": "Books", "count": 2 },
  { "category": "Clothing", "count": 1 }
]
```

👉 **Why `-1`?**

- It ensures the **category with the highest count appears first**.

---

### **Example: Sorting in Ascending Order (`1`)**

If we change `-1` to `1`:

```json
{ "$sort": { "count": 1 } }
```

It **sorts in ascending order (smallest to largest count)**:

```json
[
  { "category": "Clothing", "count": 1 },
  { "category": "Electronics", "count": 2 },
  { "category": "Books", "count": 2 }
]
```

👉 **Why `1`?**

- It ensures the **category with the lowest count appears first**.

---

### **Sorting Multiple Fields**

You can sort by multiple fields. Example:

```json
{ "$sort": { "count": -1, "category": 1 } }
```

- **First**, sorts by `count` **(descending)**.
- **Then**, if two categories have the same `count`, it sorts alphabetically by `category` **(ascending)**.

---

### **Summary**

|**Sort Order**|**Value**|**Example Usage**|
|---|---|---|
|Ascending|`1`|`{ "$sort": { "price": 1 } }` (lowest price first)|
|Descending|`-1`|`{ "$sort": { "price": -1 } }` (highest price first)|
