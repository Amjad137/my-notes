
## `type FieldWithStatus<T> = T extends { status: KycFieldReviewStatus } ? T : never;`

The syntax `type FieldWithStatus<T> = T extends { status: KycFieldReviewStatus } ? T : never;` defines a **TypeScript conditional type**. Let's break it down step by step:

### Components:

1. **Type Alias (`type FieldWithStatus<T>`)**:
   - `type FieldWithStatus<T>`: This defines a type alias named `FieldWithStatus`, which takes a generic type parameter `T`. The `T` can be any type you pass to this alias.

2. **Conditional Type (`T extends { status: KycFieldReviewStatus } ? T : never`)**:
   - `T extends { status: KycFieldReviewStatus }`: This checks if the type `T` extends (or is assignable to) the type `{ status: KycFieldReviewStatus }`. Essentially, it's checking if `T` has a `status` property, and if the type of `status` is `KycFieldReviewStatus`.
   - **The `?` and `:` operators**: This is similar to a ternary (conditional) operator in regular JavaScript/TypeScript code. If the condition is true (i.e., `T` extends `{ status: KycFieldReviewStatus }`), then the type evaluates to `T`. If the condition is false, it evaluates to `never`.

3. **The `never` Type**:
   - `never` is a special type in TypeScript that represents a type that should never occur. If `T` does not extend `{ status: KycFieldReviewStatus }`, `FieldWithStatus<T>` will evaluate to `never`. In practice, this means that if `T` does not have a `status` field of type `KycFieldReviewStatus`, the result is a type that represents no possible value.

### Example Scenarios:

1. **When `T` has a `status` field of type `KycFieldReviewStatus`**:
   ```typescript
   type Example1 = FieldWithStatus<{ status: KycFieldReviewStatus, otherField: string }>;
   // Example1 will be { status: KycFieldReviewStatus, otherField: string }
   ```
   In this case, since the type `T` (`{ status: KycFieldReviewStatus, otherField: string }`) does indeed extend `{ status: KycFieldReviewStatus }`, the conditional type returns `T` itself.

2. **When `T` does not have a `status` field**:
   ```typescript
   type Example2 = FieldWithStatus<{ otherField: string }>;
   // Example2 will be never
   ```
   Here, `T` (`{ otherField: string }`) does not extend `{ status: KycFieldReviewStatus }`, so the conditional type evaluates to `never`.

3. **When `T` has a `status` field but with a different type**:
   ```typescript
   type Example3 = FieldWithStatus<{ status: string, otherField: string }>;
   // Example3 will be never
   ```
   Since `status` in `T` is not of type `KycFieldReviewStatus`, this type will also evaluate to `never`.

### Use Cases:
This pattern is useful when you want to conditionally narrow down or filter types based on whether they meet certain criteria. In this case, it's used to determine if an object has a `status` field of type `KycFieldReviewStatus`, and if so, allow access to that type in the context of a function or interface.

### Summary:
- `type FieldWithStatus<T> = T extends { status: KycFieldReviewStatus } ? T : never;` defines a type alias that checks whether a type `T` has a `status` field of type `KycFieldReviewStatus`.
- If `T` meets this condition, `FieldWithStatus<T>` resolves to `T`. If not, it resolves to `never`.

This allows you to conditionally narrow down types based on whether they meet specific structural requirements.

More on extends keyword : [[Extends- Conditional Check]]