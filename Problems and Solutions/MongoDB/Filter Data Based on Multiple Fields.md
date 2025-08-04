
```typescript

snitchHandler.get("/", async (c) => {
  try {
    const queryParams = c.req.queries();
    
    const snitchFilters: FilterQuery<ISnitch> = {};
    
    // Extract single values from arrays if needed
    Object.entries(queryParams).forEach(([key, value]) => {
      if (value) {
        snitchFilters[key] = Array.isArray(value) ? value[0] : value;
      }
    });

    const data = await snitchService.findAll(snitchFilters);
    return c.json(data.results, StatusCodes.OK);
  } catch (err) {
    // error handling
  }
});

```