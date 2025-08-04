In MongoDB, the operators like `$lt` and `$gt` are query operators used to compare values in the database. Here’s a rundown of some key MongoDB query operators, especially the ones useful for range and condition-based queries:

### 1. **Comparison Operators**
These operators are used to compare values, which is especially useful for handling date and time overlaps or numerical ranges.

- **`$lt`**: Stands for "less than". Used to select documents where the value of a field is less than the specified value.
  ```javascript
  { field: { $lt: value } }
  ```
  *Example:* `{ age: { $lt: 30 } }` — finds documents where `age` is less than 30.

- **`$lte`**: Stands for "less than or equal to". Used to select documents where the value of a field is less than or equal to the specified value.
  ```javascript
  { field: { $lte: value } }
  ```
  *Example:* `{ age: { $lte: 30 } }` — finds documents where `age` is 30 or less.

- **`$gt`**: Stands for "greater than". Used to select documents where the value of a field is greater than the specified value.
  ```javascript
  { field: { $gt: value } }
  ```
  *Example:* `{ age: { $gt: 18 } }` — finds documents where `age` is greater than 18.

- **`$gte`**: Stands for "greater than or equal to". Used to select documents where the value of a field is greater than or equal to the specified value.
  ```javascript
  { field: { $gte: value } }
  ```
  *Example:* `{ age: { $gte: 18 } }` — finds documents where `age` is 18 or more.

- **`$ne`**: Stands for "not equal". Used to find documents where the value of a field is not equal to the specified value.
  ```javascript
  { field: { $ne: value } }
  ```
  *Example:* `{ age: { $ne: 21 } }` — finds documents where `age` is not equal to 21.

### 2. **Logical Operators**
Logical operators allow combining multiple conditions in queries.

- **`$or`**: Allows you to specify multiple conditions; at least one of them must be true.
  ```javascript
  { $or: [ { field1: condition1 }, { field2: condition2 } ] }
  ```
  *Example:* `{ $or: [ { age: { $lt: 18 } }, { status: "minor" } ] }` — finds documents where `age` is less than 18 or `status` is "minor".

- **`$and`**: Allows you to specify multiple conditions that must all be true. 
  ```javascript
  { $and: [ { field1: condition1 }, { field2: condition2 } ] }
  ```
  *Example:* `{ $and: [ { age: { $gte: 18 } }, { status: "active" } ] }` — finds documents where `age` is at least 18 and `status` is "active".

- **`$not`**: Inverts the effect of a query expression.
  ```javascript
  { field: { $not: { condition } } }
  ```
  *Example:* `{ age: { $not: { $gte: 18 } } }` — finds documents where `age` is less than 18.

- **`$nor`**: Combines multiple expressions but returns documents that do not match any of the specified conditions.
  ```javascript
  { $nor: [ { field1: condition1 }, { field2: condition2 } ] }
  ```
  *Example:* `{ $nor: [ { age: { $lt: 18 } }, { status: "minor" } ] }` — finds documents where `age` is not less than 18 and `status` is not "minor".

### 3. **Element Operators**
Used to check for specific field characteristics.

- **`$exists`**: Checks if a field exists or not.
  ```javascript
  { field: { $exists: true } }
  ```
  *Example:* `{ email: { $exists: true } }` — finds documents where the `email` field is present.

- **`$type`**: Selects documents if a field is of the specified BSON type.
  ```javascript
  { field: { $type: "string" } }
  ```
  *Example:* `{ age: { $type: "number" } }` — finds documents where the `age` field is of the number type.

### 4. **Evaluation Operators**
These operators can handle more complex expressions and conditions.

- **`$regex`**: Matches a field’s value against a specified regular expression.
  ```javascript
  { field: { $regex: /pattern/ } }
  ```
  *Example:* `{ name: { $regex: /^A/ } }` — finds documents where `name` starts with "A".

- **`$expr`**: Allows you to use aggregation expressions within the query language.
  ```javascript
  { $expr: { $gt: [ "$field1", "$field2" ] } }
  ```
  *Example:* `{ $expr: { $gt: [ "$price", "$cost" ] } }` — finds documents where `price` is greater than `cost`.

These operators together make it easy to perform complex data retrieval tasks, such as checking for overlapping appointments or filtering documents based on custom conditions.