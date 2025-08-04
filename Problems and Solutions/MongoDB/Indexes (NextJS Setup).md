```typescript
import { COLLECTIONS, MERCHANT_REQUEST_STATUS } from '@/lib/constants/db.constants';
import { Collection, ObjectId } from 'mongodb';

export interface IBusinessRep {
  name: string;
  phoneNumber: string;
  email: string;
}

export interface IMerchantRequest {
  _id: ObjectId;
  businessName: string;
  email: string;
  address: string;
  templateId: string;
  businessRep: IBusinessRep;
  status: MERCHANT_REQUEST_STATUS;
  createdAt: Date;
  updatedAt?: Date;
}

export class MerchantRequestModel {
  static readonly collectionName = COLLECTIONS.MerchantRequests;

  static readonly status = MERCHANT_REQUEST_STATUS;

  static create(data: IMerchantRequest): IMerchantRequest {
    return {
      _id: new ObjectId(),
      businessName: data.businessName,
      email: data.email,
      address: data.address,
      templateId: data.templateId,
      businessRep: data.businessRep,
      status: data.status || MERCHANT_REQUEST_STATUS.PENDING,
      createdAt: new Date(),
    };
  }

  static format(doc: IMerchantRequest) {
    return {
      id: doc._id?.toString(),
      businessName: doc.businessName,
      email: doc.email,
      address: doc.address,
      templateId: doc.templateId,
      businessRep: doc.businessRep,
      status: doc.status,
      createdAt: doc.createdAt,
      updatedAt: doc.updatedAt,
    };
  }

  // Validate fields (basic validation)
  static validate(data: any): { valid: boolean; errors: string[] } {
    const errors: string[] = [];

    if (!data.businessName) errors.push('Business name is required');
    if (!data.email) errors.push('Email is required');
    if (data.email && !/^\S+@\S+\.\S+$/.test(data.email)) {
      errors.push('Invalid email format');
    }
    if (!data.address) errors.push('Address is required');

    return {
      valid: errors.length === 0,
      errors,
    };
  }

  // Set up indexes (to be called during app initialization)
  static async setupIndexes(collection: Collection<IMerchantRequest>) {
    await collection.createIndex({ email: 1 });
    await collection.createIndex({ createdAt: -1 });
    await collection.createIndex({ status: 1 });
  }
}

```

# Explanation:
The `setupIndexes` method in your `MerchantRequestModel` is setting up **indexes** for the MongoDB collection. Indexes improve query performance by allowing MongoDB to find documents more efficiently.  

### **Why Set Up Indexes?**
Without indexes, MongoDB has to **scan every document** in a collection to find the relevant data (called a **collection scan**). This can be slow if the collection has a lot of documents. Indexes **optimize query performance** by allowing MongoDB to locate documents quickly.

### **Understanding the Indexes in Your Code**
```ts
static async setupIndexes(collection: Collection<IMerchantRequest>) {
  await collection.createIndex({ email: 1 });
  await collection.createIndex({ createdAt: -1 });
  await collection.createIndex({ status: 1 });
}
```
Let's break this down:

1. **`await collection.createIndex({ email: 1 })`**
   - This creates an **index on the `email` field**.
   - Purpose: Makes queries like `find({ email: "test@example.com" })` much faster.
   - Since emails are usually **unique** in many systems, this helps with **fast lookups**.

2. **`await collection.createIndex({ createdAt: -1 })`**
   - This creates an **index on `createdAt` in descending order (`-1`)**.
   - Purpose: Optimizes sorting queries like `find().sort({ createdAt: -1 })`, commonly used to **fetch recent records** (e.g., latest requests).

3. **`await collection.createIndex({ status: 1 })`**
   - This creates an **index on the `status` field**.
   - Purpose: Makes filtering by status (`PENDING`, `APPROVED`, etc.) much faster, improving queries like:
     ```ts
     collection.find({ status: MERCHANT_REQUEST_STATUS.PENDING })
     ```

### **When Should You Call `setupIndexes`?**
- This function should be called **once during app initialization**, usually when setting up the database connection.
- Example usage:
  ```ts
  import { db } from "@/lib/database"; // Assume you have a MongoDB connection setup

  async function initializeDatabase() {
    const merchantRequestsCollection = db.collection<IMerchantRequest>(
      MerchantRequestModel.collectionName
    );
    
    await MerchantRequestModel.setupIndexes(merchantRequestsCollection);
  }

  initializeDatabase().catch(console.error);
  ```
- MongoDB **persists indexes**, so they do not need to be recreated every time the app runs.

### **Benefits of Indexing**
✅ **Faster Queries** – Reduces query execution time significantly.  
✅ **Optimized Sorting** – Fetching the latest records is quicker.  
✅ **Efficient Filtering** – Searching by status/email is much faster.  


# Why there's 1 and -1
In MongoDB indexes, the numbers `1` and `-1` define **the order of sorting** in the index.  

### **1 vs. -1 in Indexes**
- **`1` (Ascending Order)** → Sorts values from **smallest to largest**  
- **`-1` (Descending Order)** → Sorts values from **largest to smallest**  

---

### **Example in Your Code**
```ts
await collection.createIndex({ email: 1 });       // Ascending order
await collection.createIndex({ createdAt: -1 });  // Descending order
await collection.createIndex({ status: 1 });      // Ascending order
```

#### **1️⃣ `await collection.createIndex({ email: 1 })`**
- Creates an **ascending index** on the `email` field.
- This means MongoDB will store emails in **A → Z** order.
- If you search for `email: "test@example.com"`, the lookup will be much faster.

#### **2️⃣ `await collection.createIndex({ createdAt: -1 })`**
- Creates a **descending index** on `createdAt` (newest first).
- If you query:
  ```ts
  collection.find().sort({ createdAt: -1 });
  ```
  MongoDB **doesn't need to sort manually**—it retrieves data in the correct order instantly.

#### **3️⃣ `await collection.createIndex({ status: 1 })`**
- Creates an **ascending index** on `status`.
- This helps with queries like:
  ```ts
  collection.find({ status: MERCHANT_REQUEST_STATUS.PENDING });
  ```
  Since MongoDB knows where each status value is, it retrieves results faster.

---

### **When to Use 1 vs. -1?**
✅ Use **`1` (ascending)** when:
- You need **A → Z** ordering (e.g., alphabetical names, email lookups).
- You want **oldest records first** in time-based fields (`createdAt`, `updatedAt`).

✅ Use **`-1` (descending)** when:
- You need **newest records first** (e.g., latest transactions, newest signups).
- You want **Z → A** ordering for text-based fields.

Would you like an example of **compound indexes** (multiple fields in one index)? 🚀