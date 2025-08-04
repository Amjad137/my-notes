
```typescript
export type ContentItem = Awaited<
	ReturnType<typeof getAllContents>
>['data'][number];
```

Yes, your understanding is correct. In TypeScript, to obtain the resolved type of an asynchronous function (i.e., the type that the Promise resolves to), you can use the `Awaited` and `ReturnType` utility types in combination.

### Explanation

Given an asynchronous function:

```typescript
async function getAllContents(): Promise<{ data: ContentItem[] }> {
  // Implementation
}
```



To extract the type of an individual `ContentItem` from the resolved data, you can define:

```typescript
type ContentItem = Awaited<ReturnType<typeof getAllContents>>['data'][number];
```



Here's the breakdown:

* `ReturnType<typeof getAllContents>` retrieves the return type of the `getAllContents` function, which is `Promise<{ data: ContentItem[] }>` in this case.

* `Awaited<...>` unwraps the Promise to get `{ data: ContentItem[] }`.&#x20;

* `['data'][number]` accesses the `data` array and extracts the type of its elements, resulting in the `ContentItem` type.

### Alternative Approach

If you're using TypeScript version 4.5 or later, you can define a reusable utility type to extract the resolved return type of any asynchronous function:([GeeksforGeeks][1])

```typescript
type AsyncReturnType<T extends (...args: any) => Promise<any>> = Awaited<ReturnType<T>>;
```



Then, you can use it as follows:

```typescript
type ContentItem = AsyncReturnType<typeof getAllContents>['data'][number];
```



This approach enhances readability and reusability, especially when dealing with multiple asynchronous functions.

### Summary

Using `Awaited<ReturnType<typeof yourAsyncFunction>>` is a standard and effective method in TypeScript to derive the resolved return type of an asynchronous function. It ensures type safety and clarity when working with asynchronous operations.

[1]: https://www.geeksforgeeks.org/typescript-awaitedtype-utility-type/?utm_source=chatgpt.com "Typescript Awaited<Type> Utility Type - GeeksforGeeks"
