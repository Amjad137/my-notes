this problem arises when we update Zustand to V5 from V4, means Zustand team has worked on to avoid unnecessary re-renders.
So we need to update our code from:
```typescript

  const { currentUsersCategory, setCurrentUsersCategory } = useUsersManagementStore((s) => ({
    currentUsersCategory: s.currentUsersCategory,
    setCurrentUsersCategory: s.setCurrentUsersCategory,
  }));
  
```

to:

