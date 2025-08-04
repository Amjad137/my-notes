The `tabular-nums` class is a [Tailwind CSS font-variant-numeric utility](https://tailwindcss.com/docs/font-variant-numeric#tabular-nums) that enables **tabular (monospaced) numbers**.

## What does it do?
- It makes all numbers take up the same horizontal space.
- This is especially useful for aligning numbers in tables, dashboards, or financial data, so that columns of numbers line up perfectly.

## Example

**Without `tabular-nums`:**
```
123
 45
6789
```
Numbers may not align vertically.

**With `tabular-nums`:**
```
 123
  45
6789
```
All digits occupy the same width, so numbers align neatly.

## Usage in Tailwind
```tsx
<span className="tabular-nums">12345</span>
```

## In your code
```tsx
<CardTitle className='text-2xl md:text-3xl font-semibold tabular-nums'>
  $1,250.00
</CardTitle>
```
This ensures the numbers in your card titles align perfectly, which is great for dashboards and financial data.