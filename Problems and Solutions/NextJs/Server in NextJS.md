Creating an API in Next.js follows a structured approach, especially when using the **App Router (`app/` directory)** or the **Pages Router (`pages/api/` directory)**. Here are the key rules and best practices:

---

### **1. Choose the Correct Routing Approach**

#### **(A) Using the Pages Router (`pages/api/` directory)**

- API routes are placed inside `pages/api/` (e.g., `pages/api/users.ts`).
    
- Each file inside `api/` automatically becomes an endpoint (`/api/users`).
    
- Functions inside API route files must be default-exported and handle `req` (request) and `res` (response).
    

#### **(B) Using the App Router (`app/api/` directory - Recommended for Next.js 13+)**

- Use the `app/api/` directory with **server functions**.
    
- Define route handlers inside `route.ts` (or `route.js`).
    
- Use **Request** and **Response** objects from the Web API (`fetch`-like API).
    
- Example:
    
    ```
    app/api/users/route.ts → Handles requests at /api/users
    ```
    

---

### **2. Handle HTTP Methods Properly**

- Use the correct HTTP method (`GET`, `POST`, `PUT`, `DELETE`, etc.).
    
- In **Pages Router**, check `req.method` manually:
    
    ```ts
    export default function handler(req, res) {
      if (req.method === "POST") {
        res.status(200).json({ message: "Success" });
      } else {
        res.status(405).json({ message: "Method Not Allowed" });
      }
    }
    ```
    
- In **App Router**, define multiple handlers in `route.ts`:
    
    ```ts
    export async function GET(req: Request) {
      return Response.json({ message: "GET request" });
    }
    
    export async function POST(req: Request) {
      return Response.json({ message: "POST request" });
    }
    ```
    

---

### **3. Always Return Proper HTTP Responses**

- Use `res.status(code).json({ ... })` in the **Pages Router**.
    
- Use `Response.json({ ... })` in the **App Router**.
    
- Common status codes:
    
    - `200` → Success
        
    - `201` → Created (for POST)
        
    - `400` → Bad Request (invalid data)
        
    - `401` → Unauthorized (auth issues)
        
    - `403` → Forbidden (permission denied)
        
    - `404` → Not Found
        
    - `500` → Server Error
        

---

### **4. Use Middleware for Authentication & Authorization**

- In **Pages Router**, check authentication inside API handlers.
    
- In **App Router**, use middleware (`middleware.ts`) to enforce auth checks globally.
    
- Example of middleware in `middleware.ts`:
    
    ```ts
    import { NextResponse } from "next/server";
    
    export function middleware(req) {
      const token = req.cookies.get("token")?.value;
      if (!token) {
        return NextResponse.json({ message: "Unauthorized" }, { status: 401 });
      }
      return NextResponse.next();
    }
    ```
    
- To apply it only to `/api` routes:
    
    ```ts
    export const config = { matcher: "/api/:path*" };
    ```
    

---

### **5. Secure and Validate Input Data**

- Use **Zod** or other validation libraries to validate request data.
    
- Prevent **SQL injection, XSS, CSRF attacks**.
    
- Example using Zod:
    
    ```ts
    import { z } from "zod";
    
    const userSchema = z.object({
      name: z.string().min(3),
      email: z.string().email(),
    });
    
    export async function POST(req: Request) {
      const body = await req.json();
      const parsed = userSchema.safeParse(body);
    
      if (!parsed.success) {
        return Response.json({ error: parsed.error }, { status: 400 });
      }
    
      return Response.json({ message: "Valid data" });
    }
    ```
    

---

### **6. Optimize API Performance**

- **Use caching** (e.g., Next.js `revalidate`).
    
- **Use pagination** for large datasets.
    
- **Optimize database queries** (e.g., MongoDB indexes).
    

---

### **7. Enable CORS if Required**

- If your API is accessed from a different domain, enable CORS.
    
- Example CORS handling in App Router:
    
    ```ts
    export async function OPTIONS() {
      return new Response(null, {
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
        },
      });
    }
    ```
    

---

### **8. Use Environment Variables for Secrets**

- Store API keys, database credentials, and secrets in `.env.local`:
    
    ```
    DATABASE_URL=mongodb://...
    JWT_SECRET=your_secret_key
    ```
    
- Access them using `process.env`:
    
    ```ts
    const dbUrl = process.env.DATABASE_URL;
    ```
    

---

Would you like a specific example based on your project needs? 🚀