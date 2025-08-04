```typescript
 role: z.nativeEnum(USER_ROLE).refine((role) => role !== USER_ROLE.USER, {
    message: 'The Role User is not allowed',
  }),
```

Great question! Let's walk through **how it fails** step by step when the value is `USER_ROLE.USER` in the context of this Zod validation:

---

### ✅ Here's your code again:

```ts
role: z.nativeEnum(USER_ROLE).refine((role) => role !== USER_ROLE.USER, {
  message: 'The Role User is not allowed',
}),
```

---

### 🧩 Step-by-step Explanation of How It Fails:

1. **Zod receives a value** for the `role` field during validation — let’s say it's `"USER"`.

2. `z.nativeEnum(USER_ROLE)` checks whether `"USER"` is a valid value in the `USER_ROLE` enum.
   - ✅ This passes, because `"USER"` is a valid enum member.

3. **Next, `.refine()` is executed**:
   - It runs the function: `(role) => role !== USER_ROLE.USER`
   - Here, `role === "USER"`, so the condition becomes:
     ```ts
     "USER" !== "USER" // => false
     ```
   - ❌ This returns `false`, meaning the `.refine()` check has **failed**.

4. Since the `.refine()` check failed, **Zod throws a validation error** for the `role` field.
   - It attaches your custom message:
     ```ts
     "The Role User is not allowed"
     ```

---

### 🧪 Example Failure Output

If you run this schema validation with an invalid value like `"USER"`, the result would look like this:

```ts
{
  success: false,
  error: {
    issues: [
      {
        code: 'custom',
        message: 'The Role User is not allowed',
        path: ['role'],
      },
    ],
  },
}
```

---

### ✅ So in short:

- The enum check passes ✅
- The `.refine()` fails ❌ when value is `"USER"`
- Zod then throws a **custom error message** you defined

Let me know if you want a runnable example to test this!