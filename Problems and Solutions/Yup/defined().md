In **Yup**, the `defined()` method is a schema constraint that ensures the value is **not `undefined`**. It’s often used when you want to allow `null` (or other values), but you want to explicitly **disallow `undefined`**.

### Example
```js
import * as yup from 'yup';

const schema = yup.object({
  name: yup.string().defined(),
});
```

In this example:
- ✅ `"John"` → valid
- ✅ `""` → valid (empty string is still defined)
- ✅ `null` → valid (unless you also call `.nullable(false)`)
- ❌ `undefined` → **invalid**

### Use Case
`defined()` is particularly useful when you want to **require a field to be present**, even if its value is `null` or empty. This is different from:
- `required()` – which disallows both `undefined` and `null`, and typically also empty strings (depending on schema type).
- `nullable()` – allows `null` values.

You might combine them like:
```js
yup.string().nullable().defined()
// allows: null, '', 'value'
// disallows: undefined
```

Would you like a comparison between `required()`, `defined()`, and `nullable()`?