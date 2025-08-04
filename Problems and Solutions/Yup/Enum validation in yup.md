Your pattern:

```typescript
mixed<RadioGroupTypes>().oneOf(values(RadioGroupTypes)).default(RadioGroupTypes.mentions)
```

is using **Yup** validation with TypeScript **Enums**. Let's break it down step by step.

---

### **Understanding Each Part**

#### **1. `mixed<RadioGroupTypes>()`**

- `yup.mixed<T>()` is used when the data type can be anything, but we want to constrain it.
- Here, `RadioGroupTypes` is likely a TypeScript `enum` representing valid options.

#### **2. `.oneOf(values(RadioGroupTypes))`**

- `oneOf([...])` ensures the value must be one of the provided options.
- `values(RadioGroupTypes)` is used to extract the possible values from the enum.
- In TypeScript, `Object.values(RadioGroupTypes)` is commonly used to achieve this.

#### **3. `.default(RadioGroupTypes.mentions)`**

- Sets a **default** value (`RadioGroupTypes.mentions`) if none is provided.

---

### **Example Implementation**

#### **1. Defining the Enum**

```typescript
enum RadioGroupTypes {
  ALL = "all",
  MENTIONS = "mentions",
  DIRECT_MESSAGES = "direct_messages",
}
```

#### **2. Creating the Yup Schema**

```typescript
import * as yup from 'yup';

const schema = yup.object({
  notificationType: yup
    .mixed<RadioGroupTypes>()
    .oneOf(Object.values(RadioGroupTypes), 'Invalid notification type')
    .default(RadioGroupTypes.MENTIONS),
});
```

#### **3. Testing the Schema**

```typescript
schema
  .validate({})
  .then((data) => console.log(data)) // { notificationType: "mentions" } (default applied)
  .catch(err => console.log(err.errors));

schema
  .validate({ notificationType: "all" })
  .then((data) => console.log(data)) // { notificationType: "all" } (valid)
  .catch(err => console.log(err.errors));

schema
  .validate({ notificationType: "random" })
  .then((data) => console.log(data))
  .catch(err => console.log(err.errors)); // "Invalid notification type"
```

---

### **Summary**

✅ `mixed<RadioGroupTypes>()` → Allows `RadioGroupTypes` values.  
✅ `.oneOf(values(RadioGroupTypes))` → Ensures only valid enum values.  
✅ `.default(RadioGroupTypes.mentions)` → Sets a default value.

Let me know if you need further clarification! 🚀