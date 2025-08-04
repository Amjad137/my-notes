### **`$or` (Logical OR Condition in MongoDB)**

### **What is `$or`?**

- `$or` is a **logical operator** that allows multiple conditions.
- If **at least one** condition is true, the document is included in the result.

### **Basic Syntax**

```json
{
  "$or": [
    { "field1": condition1 },
    { "field2": condition2 }
  ]
}
```

- The query will return documents where **either `field1` matches condition1 OR `field2` matches condition2`**.

---

### **Example 1: Find Users Who Are Either 25 Years Old or Live in "New York"**

#### **Collection: Users**

```json
[
  { "name": "John", "age": 25, "city": "Los Angeles" },
  { "name": "Jane", "age": 30, "city": "New York" },
  { "name": "Mike", "age": 25, "city": "New York" }
]
```

#### **Query**

```json
{
  "$or": [
    { "age": 25 },
    { "city": "New York" }
  ]
}
```

- **Matching Results**:
    
    ```json
    [
      { "name": "John", "age": 25, "city": "Los Angeles" },
      { "name": "Jane", "age": 30, "city": "New York" },
      { "name": "Mike", "age": 25, "city": "New York" }
    ]
    ```
    
- **Why?**
    - **John** is included because `age: 25`.
    - **Jane** is included because `city: "New York"`.
    - **Mike** is included because both conditions match.

---

### **Example 2: Search for a Product in Title OR Description**

#### **Collection: Products**

```json
[
  { "title": "iPhone 14", "description": "Apple smartphone" },
  { "title": "MacBook Pro", "description": "Powerful laptop from Apple" },
  { "title": "Samsung Galaxy", "description": "Android phone" }
]
```

#### **Query**

```json
{
  "$or": [
    { "title": { "$regex": "apple", "$options": "i" } },
    { "description": { "$regex": "apple", "$options": "i" } }
  ]
}
```

- This searches for **"Apple"** in either `title` or `description`.
- **Matching Results**:
    
    ```json
    [
      { "title": "iPhone 14", "description": "Apple smartphone" },
      { "title": "MacBook Pro", "description": "Powerful laptop from Apple" }
    ]
    ```
    