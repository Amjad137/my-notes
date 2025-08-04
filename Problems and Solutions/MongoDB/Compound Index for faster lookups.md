```typescript
// Add compound index for token lookups (optimizes your most common query)
PasswordResetSchema.index({ userId: 1, isUsed: 1, expiresAt: 1 });
```