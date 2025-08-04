
layout.tsx:
```typescript
type Props = {
  children: React.ReactNode;
};

export const dynamic = 'force-dynamic';

const NewCollectionLayout = ({ children }: Props) => {
  return <div className='pt-[116px] lg:pt-[136px]'>{children}</div>;
};

export default NewCollectionLayout;

```

### # What is `force-dynamic`?

```typescript
export const dynamic = 'force-dynamic';
```

This is a Next.js **Dynamic Rendering Configuration** that:

1. **Forces Dynamic Rendering**
    
    - Disables static rendering and caching
    - Every request gets a fresh server-side render
    - Pages are generated at request time
2. **Use Cases**:
    
    - Real-time data requirements
    - Frequently changing content
    - User-specific content
    - Search pages with query parameters

### Available Options

```typescript
type DynamicOptions = 
  | 'auto'           // Default: Next.js chooses based on usage
  | 'force-dynamic'  // Forces dynamic rendering
  | 'error'          // Errors if dynamic features are used
  | 'force-static'   // Forces static rendering
```
### When to Use `force-dynamic`

✅ **Good Use Cases**:

- Search pages
- User dashboards
- Real-time pricing pages
- Frequently updated content
- Pages with dynamic routes and search params

❌ **Not Recommended For**:

- Static content
- Blog posts
- Documentation
- Landing pages

### Alternative Approaches

```typescript
// 1. Page-level dynamic configuration
export const dynamic = 'auto'

// 2. Route segment configuration
export const revalidate = 60 // Revalidate every 60 seconds

// 3. Individual fetch configuration
fetch(url, { next: { revalidate: 60 } })
```

In your case, it's used in the New Collection layout, likely because the collection data needs to be fresh and reflect real-time inventory or pricing changes.