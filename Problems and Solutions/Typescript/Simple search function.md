
```typescript

export const SearchDrawer = ({ children }: { children: React.ReactNode }) => {
  const [search, setSearch] = useState('');

  const handleDebounceSearch = useMemo(() => debounce((e) => setSearch(e.target.value), 1000), []);
```

checkout: [[debounce() - to delay calling of a function for a certain period 1]]