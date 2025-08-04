
```typescript
## **1. `$regex` (Regular Expression Search in MongoDB)**

### **What is `$regex`?**

- `$regex` is a MongoDB **query operator** used to perform **pattern matching** on string fields.
- It allows searching for documents where a field **contains** or **matches** a certain pattern.
- Works similar to **regular expressions** in programming.

### **Basic Syntax**

```json
{ "fieldName": { "$regex": "pattern" } }
```

- This searches for all documents where `"fieldName"` **matches the regex pattern**.

---

### **Example 1: Search for Names Starting with "A"**

#### **Collection: Users**

```json
[
  { "name": "Alice" },
  { "name": "Alex" },
  { "name": "Bob" }
]
```

#### **Query**

```json
{ "name": { "$regex": "^A" } }
```

- The `^A` pattern means **"starts with A"**.
- **Matching Results**:
    
    ```json
    [
      { "name": "Alice" },
      { "name": "Alex" }
    ]
    ```
    
- **"Bob"** is excluded because it does not start with `"A"`.

---

### **Example 2: Find Emails Ending with `.com`**

#### **Collection: Users**

```json
[
  { "email": "john@gmail.com" },
  { "email": "jane@yahoo.com" },
  { "email": "sam@hotmail.co.uk" }
]
```

#### **Query**

```json
{ "email": { "$regex": "\\.com$" } }
```

- The `\.com$` pattern means **"ends with .com"**.
- **Matching Results**:
    
    ```json
    [
      { "email": "john@gmail.com" },
      { "email": "jane@yahoo.com" }
    ]
    ```
    
- **"[sam@hotmail.co.uk](mailto:sam@hotmail.co.uk)"** is excluded.

---

### **Example 3: Case-Insensitive Search for "luxury"**

#### **Collection: Listings**

```json
[
  { "title": "Luxury Apartment" },
  { "title": "Modern Condo" },
  { "title": "luxury villa" }
]
```

#### **Query**

```json
{ "title": { "$regex": "luxury", "$options": "i" } }
```

- Without `$options: "i"`, **"Luxury Apartment"** wouldn't match because MongoDB's regex is case-sensitive by default.
    
- **Matching Results**:
    
    ```json
    [
      { "title": "Luxury Apartment" },
      { "title": "luxury villa" }
    ]
    ```
    
