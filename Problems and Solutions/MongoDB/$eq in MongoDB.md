
```typescript
The `$eq` operator is a **MongoDB query operator** that stands for **"equal to"**. It is used in queries to match documents where a field's value is exactly equal to a given value.

---

### **Example Usage in MongoDB**
#### **Without `$eq` (Direct Matching)**
```ts
const filter = { city: city }; 
```
This matches documents where `city` is exactly equal to `city`.

---

#### **With `$eq`**
```ts
const filter = { city: { $eq: city } };
```
This does the same thing as above but explicitly tells MongoDB to check for equality.

---

### **Why Use `$eq`?**
Using `$eq` can be useful when building **dynamic queries** where you might use other operators (`$gte`, `$lte`, `$in`, etc.) in the same structure.

#### **Example: Using `$eq` with Conditional Filtering**
```ts
const filter: Record<string, any> = {};

if (city) {
  filter.city = { $eq: city };
}

if (category) {
  filter.category = { $eq: category };
}

console.log(filter);
// Example output: { city: { $eq: "New York" }, category: { $eq: "Electronics" } }
```
Here, the query dynamically adds conditions based on available filters.

---

### **Alternative Query Operators in MongoDB**
- **`$gt`** (greater than): `{ price: { $gt: 100 } }`
- **`$lt`** (less than): `{ price: { $lt: 1000 } }`
- **`$gte`** (greater than or equal to): `{ price: { $gte: 500 } }`
- **`$lte`** (less than or equal to): `{ price: { $lte: 2000 } }`
- **`$ne`** (not equal): `{ category: { $ne: "Clothing" } }`
- **`$in`** (matches any value in an array): `{ city: { $in: ["New York", "Los Angeles"] } }`
- **`$exists`** (checks if a field exists): `{ discount: { $exists: true } }`

Would you like more clarification or examples? 🚀
```