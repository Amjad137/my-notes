
### 1. `Object.keys()`
- **Purpose**: This method returns an array of the keys (property names) of the given object.
- **Example**:
   ```typescript
   const person = { name: 'Alice', age: 25, city: 'New York' };
   const keysArray = Object.keys(person);
   console.log(keysArray); // Output: ['name', 'age', 'city']
   ```

### 2. `Object.values()`
- **Purpose**: This method returns an array of the values of the given object's properties.
- **Example**:
   ```typescript
   const person = { name: 'Alice', age: 25, city: 'New York' };
   const valuesArray = Object.values(person);
   console.log(valuesArray); // Output: ['Alice', 25, 'New York']
   ```

   - **Step-by-Step**:
     - `Object.values(person)` takes the `person` object and extracts all of its values.
     - The result is an array with the values `'Alice'`, `25`, and `'New York'`.

### 3. `Object.entries()`
- **Purpose**: This method returns an array of key-value pairs from the given object, where each key-value pair is represented as an array.
- **Example**:
   ```typescript
   const person = { name: 'Alice', age: 25, city: 'New York' };
   const entriesArray = Object.entries(person);
   console.log(entriesArray); 
   // Output: [['name', 'Alice'], ['age', 25], ['city', 'New York']]
   ```

   - **Step-by-Step**:
     - `Object.entries(person)` takes the `person` object and extracts each key-value pair.
     - The result is an array of arrays, where each inner array contains a key and its corresponding value from the `person` object.

### How These Methods Form Arrays:
- **Internally**: These methods iterate over the object's own enumerable properties (properties directly defined on the object, not inherited from its prototype) and collect the keys, values, or key-value pairs into an array.
- **Purpose**: These arrays can then be used for various operations like filtering, mapping, checking conditions, etc., just as you would with any other array.

### Example Using `Object.values()` in Your Context:
In your function `isSectionApproved`, you use `Object.values()` to form an array of the values from the `section` object:
```typescript
Object.values(section).every((field) => {
```
- **Explanation**:
  - `Object.values(section)` converts the `section` object into an array of its values.
  - For example, if `section` is:
    ```typescript
    const section = {
      firstName: { value: 'John', status: 'APPROVED' },
      lastName: { value: 'Doe', status: 'PENDING' },
      email: { value: 'john.doe@example.com', status: 'APPROVED' }
    };
    ```
  - `Object.values(section)` would produce:
    ```typescript
    [
      { value: 'John', status: 'APPROVED' },
      { value: 'Doe', status: 'PENDING' },
      { value: 'john.doe@example.com', status: 'APPROVED' }
    ]
    ```
  - The `.every()` method then iterates over this array, checking each `field` for the specified conditions.

### Summary:
- `Object.values()` converts an object's property values into an array, which can then be iterated over or processed like any other array.
- `Object.keys()` and `Object.entries()` are similar methods that return arrays of the object's keys or key-value pairs, respectively.