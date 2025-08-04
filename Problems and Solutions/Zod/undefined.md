# Understanding `z.union([studentDetailsSchema, z.undefined()])`

This pattern creates a field that can be either a fully-defined object OR completely absent from the request.

## Why Include `z.undefined()`?

1. **Conditional Requirements**: The `studentDetails` field should only be:
   - Required when `role === USER_ROLE.STUDENT`
   - Omitted for all other roles

2. **Two-Phase Validation**: 
   - First phase: Accept either a valid object OR undefined
   - Second phase: Use `.superRefine()` to enforce role-specific requirements

3. **API Flexibility**: Allows the API to handle requests where these fields are completely absent from the JSON payload

## Alternative Approaches

If you didn't use `z.union([studentDetailsSchema, z.undefined()])`, you'd have these alternatives:

```typescript
// Option 1: .optional() - accepts undefined OR null
studentDetails: studentDetailsSchema.optional()

// Option 2: .nullable() - accepts a valid object OR null
studentDetails: studentDetailsSchema.nullable()
```

The current approach is more precise, specifically allowing:
- Valid student details object 
- Field being absent (undefined)
- But NOT allowing null or invalid objects

This pattern works together with the `.superRefine()` logic that enforces that `studentDetails` exists when `role === USER_ROLE.STUDENT`.