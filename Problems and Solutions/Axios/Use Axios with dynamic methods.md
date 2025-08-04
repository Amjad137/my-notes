
```typescript
 // Choose API endpoint based on whether we're editing or creating
const endpoint = listingData?._id ? `/v1/listing/${listingData._id}`:'/v1/listing';
const method = listingData ? 'patch' : 'post';

const response = await Axios[method](endpoint, {
        ...data,
        images: imageUrls,
      });

```