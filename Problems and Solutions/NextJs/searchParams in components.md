``` typescript

interface EditListingPageProps {
  params: Promise<{
    listingId: string;
  }>;
}

const EditListingPage = async ({ params }: EditListingPageProps) => {
  // Await the params using the `use` hook
  const { listingId } = await params;
```

```typescript
export default async function Home({
  searchParams: rawSearchParams,
}: {
  searchParams: { [key: string]: string | undefined };
}) {
  // Parse search params safely
  const searchParams = {
    page: '1',
    limit: '24',
    sort: SortByFields.Date,
    sortOrder: SortOrder.Descending,
    ...rawSearchParams // Spread raw params after defaults
  };
```