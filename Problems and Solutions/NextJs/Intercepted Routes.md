(.)
Alright, let's break down **Intercepted Routes** in Next.js (specifically Next.js 13+ with the App Router).

---

## **What Are Intercepted Routes?**

* They allow you to **load a route from somewhere else** in your app **without leaving the current layout**.
* Common use case: **Modals, side panels, or temporary overlays** where you don’t want a full page navigation.

---

## **Basic Concept**

In **Next.js App Router**, routes live under `app/`.
An **intercepted route** is created by prefixing the folder with `(.)`.

### **Folder Naming**

* `(.)folder` → intercepts **from the same level**
* `(..)folder` → intercepts **from one level up**
* `(...)folder` → intercepts **from the root**

---

## **Example: Modal for a Product**

Imagine you have:

```
app/
 ├─ products/
 │   ├─ page.tsx         → Shows all products
 │   ├─ [id]/
 │   │   └─ page.tsx     → Shows a single product full page
 │   └─ (.)[id]/
 │       └─ page.tsx     → Modal version of product page
```

### **Normal Navigation**

* `/products/1` → loads `products/[id]/page.tsx` as a full page.

### **Intercepted Navigation**

* When clicked **from `/products` page**, it loads `(.)[id]/page.tsx` **as a modal** while still rendering the `/products` page behind.

---

## **Code Example**

### `/app/products/page.tsx`

```tsx
'use client';

import Link from 'next/link';

export default function ProductsPage() {
  const products = [{ id: 1, name: 'Laptop' }, { id: 2, name: 'Phone' }];
  return (
    <div>
      <h1>Products</h1>
      {products.map(p => (
        <Link key={p.id} href={`/products/${p.id}`}>
          {p.name}
        </Link>
      ))}
    </div>
  );
}
```

### `/app/products/(.)[id]/page.tsx` (Modal)

```tsx
'use client';

import { useRouter } from 'next/navigation';

export default function ProductModal({ params }: { params: { id: string } }) {
  const router = useRouter();
  return (
    <div className="fixed inset-0 bg-black/50 flex items-center justify-center">
      <div className="bg-white p-4 rounded shadow">
        <h2>Product ID: {params.id}</h2>
        <button onClick={() => router.back()}>Close</button>
      </div>
    </div>
  );
}
```

### `/app/products/[id]/page.tsx` (Full Page)

```tsx
export default function ProductPage({ params }: { params: { id: string } }) {
  return <h1>Full Product Page: {params.id}</h1>;
}
```

---

## **When to Use**

* Modals on top of list pages
* Side panels for editing forms
* Quick previews without leaving the page

---

Do you want me to also draw a **diagram of how intercepted routes work** visually? Or should I show a **real-world login modal example**?
