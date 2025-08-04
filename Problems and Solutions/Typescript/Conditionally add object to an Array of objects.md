```typescript
const items = [
    ...(isSuperAdmin
      ? [
          {
            title: 'Users',
            url: '/admin/users',
            icon: Users, 
          },
        ]
      : []),
    {
      title: 'Listings',
      url: '/admin/listings',
      icon: ListTodo,
    },
    {
      title: 'Domain',
      url: '/admin/domains',
      icon: Inbox,
    },
    {
      title: 'Reports',
      url: '/admin/reports',
      icon: Calendar,
    },
  ];
```