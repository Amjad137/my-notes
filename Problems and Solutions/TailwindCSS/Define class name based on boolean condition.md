
```typescript

<Button
    variant='outline'
    aria-expanded={open}
    className={cn(className, 'w-full justify-between', {
    'text-muted-foreground': !value && placeholder,
    })}
    disabled={disabled}>
    {value ? cities.find((city) => city.id === value)?.city : (placeholder ?? '')}
    <ChevronsUpDown id='chevron' className='ml-2 h-4 w-4 shrink-0 opacity-50' />
</Button>
```

{ 'text-muted-foreground': !value && placeholder, }

How it works:

Great question! That syntax might look strange at first, but it’s actually a **standard JavaScript object** used in a specific way by utility libraries like `clsx`, `classnames`, or your own `cn()` function.

Let me explain it in a beginner-friendly way 👇

---

### 🧱 The Syntax

```js
{
  'bg-red-500': isError,
  'bg-green-500': isSuccess,
  'opacity-50': isDisabled,
}
```

This is just a **JavaScript object** where:
- **Keys** are strings representing CSS class names
- **Values** are booleans (true/false)

#### ✅ Example when values are true:
```js
{
  'bg-red-500': true,
  'opacity-50': false,
}
```

### 💡 Concept: **Conditional Class Names**

When this object is passed into `clsx()` or similar utilities, those libraries **include only the keys where the value is `true`**.

So:

```js
clsx({
  'bg-red-500': true,
  'bg-green-500': false,
  'opacity-50': true,
})
```

🔁 Becomes this final string:
```ts
"bg-red-500 opacity-50"
```

---

### 🤔 Where does this pattern come from?

This pattern is **not a built-in language feature**. It’s a **convention used by utility libraries** like:

#### 🧩 [`classnames`](https://www.npmjs.com/package/classnames)
```ts
import classNames from 'classnames';

classNames('base', {
  'text-red-500': isError,
  'opacity-50': isDisabled,
})
```

#### 🧩 [`clsx`](https://www.npmjs.com/package/clsx)
A more modern, smaller, TypeScript-friendly version of classnames.

```ts
import { clsx } from 'clsx';

clsx('base', {
  'bg-blue-500': isActive,
  'text-gray-400': !isActive,
})
```

#### 🧩 Your `cn()` function

Your `cn()` is likely just a wrapper for `clsx`. Example:

```ts
// utils.ts
import { clsx } from 'clsx';

export function cn(...inputs: ClassValue[]) {
  return clsx(...inputs);
}
```

---

### ✅ Why is this useful?

It helps you **conditionally apply Tailwind classes** (or any classes) in a clean way, instead of writing manual string concatenation.

#### ❌ Bad old-school way:
```ts
className={isError ? 'bg-red-500' : 'bg-green-500'}
```

#### ✅ Better with `cn()`:
```ts
className={cn('base', {
  'bg-red-500': isError,
  'bg-green-500': !isError,
})}
```

---

### 🧪 More Examples

#### Example: Button with disabled and loading states
```ts
className={cn('btn', {
  'opacity-50 cursor-not-allowed': isDisabled,
  'bg-blue-500': !isDisabled,
  'animate-spin': isLoading,
})}
```

If `isDisabled = true` and `isLoading = false`, result:
```ts
"btn opacity-50 cursor-not-allowed"
```

---

### 🔚 Summary

- The object `{ 'class-name': condition }` is **just a JS object** with string keys and boolean values.
- It's passed to utilities like `clsx` or `cn()` to **conditionally include** class names based on truthy values.
- This pattern helps avoid long, messy conditional logic when managing Tailwind/utility class strings.

Let me know if you want to see how `clsx` or your `cn()` function works internally — it's quite simple and fun to understand!