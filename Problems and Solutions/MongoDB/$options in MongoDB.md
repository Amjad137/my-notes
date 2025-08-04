### **3. `$options` (Modifiers for `$regex` in MongoDB)**

### **What is `$options`?**

- `$options` is used **inside** `$regex` to modify how the search works.
- It controls things like **case-sensitivity, multiline search, etc.**.

### **Common Options**

|Option|Meaning|
|---|---|
|`i`|**Case-insensitive** search|
|`m`|**Multiline** match (treats `^` and `$` as line start/end)|
|`s`|**Dotall mode** (allows `.` to match newlines)|
|`x`|**Ignore whitespace** in regex pattern|

---

### **Example 1: Case-Insensitive Search (`i`)**

```json
{ "name": { "$regex": "john", "$options": "i" } }
```

- **Finds**: `"John", "john", "JOHN", "JoHn"` (case doesn't matter).

---

### **Example 2: Multiline Search (`m`)**

#### **Document**

```json
{
  "review": "Great product!\nAwesome battery life."
}
```

#### **Query**

```json
{ "review": { "$regex": "^Awesome", "$options": "m" } }
```

- **Finds** `"Awesome"` **even if it's on the second line**.

---

### **Example 3: Combine `i` and `m`**

#### **Query**

```json
{ "review": { "$regex": "battery", "$options": "im" } }
```

- **Finds `"Battery"`, `"battery"`, `"BATTERY"`** anywhere, even in **multiline text**.

---

## **Summary**

|Operator|Purpose|
|---|---|
|`$regex`|Pattern matching on string fields|
|`$or`|Logical OR condition for multiple fields|
|`$options`|Modifies `$regex` behavior (e.g., case-insensitive)|
