# Understanding `$each` in MongoDB Updates

The `$each` modifier is used with array update operators like `$addToSet` to insert multiple elements into an array field at once.

```typescript
$addToSet: {
  subjectSpecialization: { $each: teacherDetails.subjectSpecialization },
  qualifications: { $each: teacherDetails.qualifications }
}
```

## Why `$each` is necessary here:

Without `$each`, MongoDB would treat the entire array as a single element:

```typescript
// Without $each
$addToSet: { subjectSpecialization: teacherDetails.subjectSpecialization }

// teacherDetails.subjectSpecialization = ["math", "physics"]
// Result: [["math", "physics"]] ❌ (nested array - wrong!)
```

With `$each`, MongoDB adds each element individually:

```typescript
// With $each
$addToSet: { subjectSpecialization: { $each: teacherDetails.subjectSpecialization } }

// teacherDetails.subjectSpecialization = ["math", "physics"]
// Result: ["math", "physics"] ✅ (individual elements - correct!)
```

The `$addToSet` operator with `$each` ensures:
1. Each subject and qualification is added individually
2. Only unique values are added (no duplicates)
3. Existing values are preserved

It's the correct approach when working with arrays like `subjectSpecialization` and `qualifications`.