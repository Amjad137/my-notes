Official Docs: [File Conventions: page.js | Next.js](https://nextjs.org/docs/app/api-reference/file-conventions/page)
Next.js automatically provides certain **reserved props** when using specific features like Server Components, App Router, and API routes. Here’s a breakdown of these **reserved props** and how they work.

---

## **Reserved Parameters in Next.js**

### **1. `searchParams`**
- **Where?** In Server Components (App Router).
- **What?** An object containing query parameters (`?key=value` from the URL).
- **Example URL:**  
  ```
  http://localhost:3000/listings?page=2&sort=desc
  ```
- **How it works:**
  ```tsx
  const Home = async ({ searchParams }: { searchParams: { page?: string; sort?: string } }) => {
    console.log(searchParams); // { page: '2', sort: 'desc' }
  };
  ```

---

### **2. `params`**
- **Where?** In Dynamic Routes (`[id]`, `[slug]`, etc.).
- **What?** An object containing dynamic route parameters.
- **Example URL:**  
  ```
  http://localhost:3000/products/123
  ```
- **How it works:**
  ```tsx
  const ProductPage = async ({ params }: { params: { id: string } }) => {
    console.log(params); // { id: '123' }
  };
  ```
- **Example with Catch-All Routes (`[...slug]`):**
  ```
  http://localhost:3000/docs/guides/react
  ```
  ```tsx
  const Docs = async ({ params }: { params: { slug: string[] } }) => {
    console.log(params); // { slug: ['guides', 'react'] }
  };
  ```

---

### **3. `children`**
- **Where?** In Layouts and Server Components.
- **What?** Represents the nested components inside a layout.
- **Example in `layout.tsx`:**
  ```tsx
  const Layout = ({ children }: { children: React.ReactNode }) => {
    return <div className="layout">{children}</div>;
  };
  ```
- **Automatically passes children inside pages:**
  ```tsx
  <Layout>
    <Home />
  </Layout>
  ```

---

### **4. `Component` (For Custom App)**
- **Where?** In `pages/_app.tsx` (only in Pages Router).
- **What?** The active page component.
- **Example in `_app.tsx`:**
  ```tsx
  function MyApp({ Component, pageProps }) {
    return <Component {...pageProps} />;
  }
  ```

---

### **5. `pageProps`**
- **Where?** In `pages/_app.tsx` (Pages Router).
- **What?** Props passed from `getServerSideProps`, `getStaticProps`, etc.
- **Example:**
  ```tsx
  function MyApp({ Component, pageProps }) {
    return <Component {...pageProps} />;
  }
  ```

---

### **6. `params`, `searchParams`, and `segmentPath` in `generateMetadata`**
- **Where?** In Server Components using `generateMetadata()`.
- **What?** Used for dynamic metadata in Next.js.
- **Example:**
  ```tsx
  export async function generateMetadata({ params, searchParams }) {
    return {
      title: `Product ${params.id}`,
      description: `Details for product ${params.id}`,
    };
  }
  ```

---

### **7. `request` and `context` (Middleware)**
- **Where?** In `middleware.ts` (Edge Middleware).
- **What?** Used for handling requests before they reach the server.
- **Example:**
  ```tsx
  import { NextRequest, NextResponse } from 'next/server';

  export function middleware(request: NextRequest) {
    console.log(request.nextUrl.pathname); // Logs the current path
    return NextResponse.next();
  }
  ```

---

## **Complete Summary Table**

| **Keyword**       | **Where?**                     | **What it does?**                                  |
|------------------|--------------------------------|---------------------------------------------------|
| `searchParams`   | Server Components (App Router) | Contains URL query parameters (`?key=value`).     |
| `params`         | Dynamic Routes (`[id]`, `[slug]`) | Contains dynamic route values from the URL.      |
| `children`       | Layouts & Components          | Represents nested components inside a layout.     |
| `Component`      | `pages/_app.tsx` (Pages Router) | Represents the active page component.            |
| `pageProps`      | `pages/_app.tsx` (Pages Router) | Props passed from `getServerSideProps`, etc.      |
| `generateMetadata` | Server Components            | Dynamically generates metadata for a page.       |
| `request`        | Middleware                    | Handles incoming requests before routing.        |
| `context`        | Middleware                    | Contains additional information in Middleware.   |

---

## **Conclusion**
These reserved keywords help Next.js automatically handle routing, query parameters, metadata, and middleware efficiently. You **should not rename** them in function parameters unless explicitly destructuring them.

Want a deeper explanation on any of these? 🚀

