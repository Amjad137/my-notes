middleware:
```typescript
// Helper function to redirect to login with original URL preserved
const redirectToUserLogin = (request: NextRequest) => {
	const url = new URL('/login', request.url);
	url.searchParams.set(
		'redirect',
		request.nextUrl.pathname + request.nextUrl.search,
	);
	return NextResponse.redirect(url);
};
```

login page:
```typescript
	const searchParams = new URLSearchParams(
		typeof window !== 'undefined' ? window.location.search : '',
	);
	const redirectUrl = searchParams.get('redirect') || '/users';
```


Absolutely! Let me break down how the `redirectToUserLogin` helper function works step by step.

## 🔍 The `redirectToUserLogin` Helper Function

```typescript
const redirectToUserLogin = (request: NextRequest) => {
	const url = new URL('/login', request.url);
	url.searchParams.set(
		'redirect',
		request.nextUrl.pathname + request.nextUrl.search,
	);
	return NextResponse.redirect(url);
};
```

### Step-by-Step Breakdown

**1. Create Login URL**
```typescript
const url = new URL('/login', request.url);
```
- Takes the incoming request's base URL (e.g., `https://dev.careway.it`)
- Creates a new URL object pointing to `/login`
- Result: `https://dev.careway.it/login`

**2. Capture Original URL**
```typescript
request.nextUrl.pathname + request.nextUrl.search
```
- `request.nextUrl.pathname`: The path user was trying to access (e.g., `/users/education/46`)
- `request.nextUrl.search`: Any query parameters (e.g., `?page=2&filter=video`)
- Combined: `/users/education/46?page=2&filter=video`

**3. Add Redirect Parameter**
```typescript
url.searchParams.set('redirect', originalPath);
```
- Adds the original URL as a query parameter to the login URL
- Result: `https://dev.careway.it/login?redirect=/users/education/46`

**4. Perform Redirect**
```typescript
return NextResponse.redirect(url);
```
- Sends a 302 redirect response to the browser
- Browser navigates to the login page with the redirect parameter

## 🎯 Real-World Example

**Scenario**: User clicks SMS link `https://dev.careway.it/users/education/46?section=comments`

### Before Fix (❌)
```
1. User → /users/education/46?section=comments
2. Middleware → /login (original URL lost!)
3. User logs in → /users (wrong destination)
```

### After Fix (✅)
```
1. User → /users/education/46?section=comments
2. redirectToUserLogin() creates:
   - Base: https://dev.careway.it/login
   - Original: /users/education/46?section=comments
   - Final: /login?redirect=/users/education/46?section=comments
3. User logs in → UserLoginForm reads 'redirect' param
4. Redirect to: /users/education/46?section=comments ✅
```

## 🔧 How It Integrates

**In Middleware**:
```typescript
if (!session || session?.user?.role !== 'user') {
	return redirectToUserLogin(request); // Preserve original URL
}
```

**In Login Form**:
```typescript
const redirectUrl = searchParams.get('redirect') || '/users';
// After login:
router.push(redirectUrl); // Go to original destination
```

## 🎨 Visual Flow

```
SMS Link Click
     ↓
┌─────────────────────────────────────┐
│ middleware/user.ts                  │
│ ┌─────────────────────────────────┐ │
│ │ redirectToUserLogin()           │ │
│ │ • Captures: /users/education/46 │ │
│ │ • Creates: /login?redirect=...  │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
     ↓
┌─────────────────────────────────────┐
│ Login Page                          │
│ URL: /login?redirect=/users/ed.../46│
└─────────────────────────────────────┘
     ↓ (user logs in)
┌─────────────────────────────────────┐
│ UserLoginForm.tsx                   │
│ ┌─────────────────────────────────┐ │
│ │ searchParams.get('redirect')    │ │
│ │ • Reads: /users/education/46    │ │
│ │ • Redirects to original URL     │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
     ↓
✅ User lands at: /users/education/46
```

This pattern ensures that **no matter what protected URL** a user tries to access, they'll be brought back to exactly that URL after logging in, preserving their original intent and any query parameters.

Great question! Let me explain exactly why the `searchParams` and `redirectUrl` are needed in the `UserLoginForm` and how they work together with the middleware.

## 🔗 The Connection Between Middleware & Login Form

### The Complete Flow

**1. Middleware Redirects** (adds `redirect` parameter)
```typescript
// middleware/user.ts
const redirectToUserLogin = (request: NextRequest) => {
	const url = new URL('/login', request.url);
	url.searchParams.set('redirect', '/users/education/46'); // ← Adds this!
	return NextResponse.redirect(url);
};
```
**Result**: User lands on `/login?redirect=/users/education/46`

**2. Login Form Reads** (extracts `redirect` parameter)
```typescript
// UserLoginForm.tsx
const searchParams = new URLSearchParams(
	typeof window !== 'undefined' ? window.location.search : '',
);
const redirectUrl = searchParams.get('redirect') || '/users';
```

### Breaking Down the Login Form Code

**`window.location.search`**:
```typescript
// When user is on: /login?redirect=/users/education/46
window.location.search // Returns: "?redirect=/users/education/46"
```

**`new URLSearchParams()`**:
```typescript
const searchParams = new URLSearchParams("?redirect=/users/education/46");
// Creates an object that can parse URL parameters
```

**`searchParams.get('redirect')`**:
```typescript
searchParams.get('redirect') // Returns: "/users/education/46"
// OR returns null if no 'redirect' parameter exists
```

**`|| '/users'` (fallback)**:
```typescript
const redirectUrl = searchParams.get('redirect') || '/users';
// If redirect exists: "/users/education/46"
// If no redirect: "/users" (default)
```

## 🎯 Real Example

### Scenario 1: SMS Link (with redirect)
```
1. User clicks: https://dev.careway.it/users/education/46
2. Middleware → /login?redirect=/users/education/46
3. Login form:
   - window.location.search = "?redirect=/users/education/46"
   - searchParams.get('redirect') = "/users/education/46"
   - redirectUrl = "/users/education/46"
4. After login → router.push("/users/education/46") ✅
```

### Scenario 2: Direct Login (no redirect)
```
1. User goes directly to: https://dev.careway.it/login
2. Login form:
   - window.location.search = "" (empty)
   - searchParams.get('redirect') = null
   - redirectUrl = "/users" (fallback)
3. After login → router.push("/users") ✅
```

## 🛡️ Why the `window !== 'undefined'` Check?

```typescript
typeof window !== 'undefined' ? window.location.search : ''
```

**During Server-Side Rendering (SSR)**:
- `window` object doesn't exist on the server
- Without this check → Error: "window is not defined"
- With this check → Uses empty string `''` on server, actual search on client

## 🔄 The Complete Picture

```
┌─── SMS Link Click ────┐
│ /users/education/46   │
└───────────┬───────────┘
            │
    ┌───────▼────────┐
    │   Middleware   │ ← Adds redirect parameter
    │ redirectToUser │
    │    Login()     │
    └───────┬────────┘
            │
    ┌───────▼────────────────────────┐
    │ Browser navigates to:          │
    │ /login?redirect=/users/ed.../46│
    └───────┬────────────────────────┘
            │
    ┌───────▼────────┐
    │  UserLoginForm │ ← Reads redirect parameter
    │                │
    │ searchParams   │ ← Extracts: "/users/education/46"
    │ redirectUrl    │
    └───────┬────────┘
            │
         (login)
            │
    ┌───────▼────────┐
    │ router.push    │ ← Uses extracted URL
    │ (redirectUrl)  │
    └────────────────┘
            │
    ┌───────▼────────┐
    │ SUCCESS! User  │
    │ lands at orig  │
    │ inal URL       │
    └────────────────┘
```

**Without this code**: User would always go to `/users` after login, losing their original destination.

**With this code**: User goes back to exactly where they intended to go! 🎯