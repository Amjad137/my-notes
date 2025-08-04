
```typescript
 <Image
    src={listing.images[0] || '/placeholder.svg'}
    alt={listing.title}
    fill
    className='object-cover transition-transform duration-300 group-hover:scale-105'
    sizes='(min-width: 1024px) 20vw, (min-width: 768px) 25vw, (min-width: 640px) 33vw, 50vw'
    priority={priority}
    unoptimized
            />
```