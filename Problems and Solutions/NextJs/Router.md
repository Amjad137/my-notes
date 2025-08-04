In **Next.js**, both `router.push` and `router.replace` are used for programmatic navigation, but they behave slightly differently:

### **1. `router.push`**
- **Adds a new entry** to the browser history.
- Allows the user to navigate back to the previous page using the browser's back button.

✅ **Example:**
```tsx
import { useRouter } from 'next/navigation';

const navigate = () => {
  const router = useRouter();
  router.push('/dashboard');
};
```
📌 **Use Case:** When you want the user to navigate to a new page but still be able to go back.

---

### **2. `router.replace`**
- **Replaces the current entry** in the browser history.
- The user **cannot go back** to the previous page using the back button.

✅ **Example:**
```tsx
import { useRouter } from 'next/navigation';

const navigate = () => {
  const router = useRouter();
  router.replace('/dashboard');
};
```
📌 **Use Case:** When you don’t want the user to go back (e.g., after login or form submission).

---

### **Other Navigation Methods in Next.js**
| Method                  | Description |
|-------------------------|-------------|
| `router.back()`         | Navigates back to the previous page (same as clicking the browser's back button). |
| `router.forward()`      | Moves forward in history (same as clicking the forward button). |
| `router.prefetch(url)`  | Preloads a page in the background for faster navigation. |
| `router.reload()`       | Reloads the current page (similar to `window.location.reload()`). |

---

### **When to Use What?**
- **`router.push`** → Normal navigation where the user should be able to go back.
- **`router.replace`** → Redirecting after login/logout or when the previous page is no longer relevant.
- **`router.back` / `router.forward`** → Manually control history-based navigation.

Let me know if you need more details! 🚀