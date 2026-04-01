### **Big picture: what actually causes re-renders?**

First clarify this (very important for your notes):

- **`useEffect` does NOT cause re-renders by itself.**
- A **re-render only happens when state changes**, e.g. `setState(...)`, `useState`, `useReducer`.
- So the problem is usually:  
  - `useEffect` runs → you call `setState` inside → that state update triggers a re-render → `useEffect` runs again → and so on.

To avoid **unnecessary** re-renders, you want to **avoid state updates that don’t really change what’s shown in the UI**.

---

### **Why `useRef` helps**

- **`useRef` holds a value across renders, but changing it does NOT trigger a re-render.**
- Think of it as a small “box” that React keeps between renders:
  - `const ref = useRef(initialValue);`
  - Access: `ref.current`
  - Update: `ref.current = newValue`
- Because `ref.current` updates don’t re-render, we can use it for:
  - Internal flags
  - Caches
  - Previous values  
  **…anything that’s not directly needed to render the UI.**

---

### **Pattern 1: One-time guard inside `useEffect` (like your `permissionChecked`)**

Use this when you want some effect logic to run **only once** per component instance, even if React re-runs the effect (e.g. StrictMode, dependency changes, etc.).

```ts
const hasRunRef = useRef(false);

useEffect(() => {
  if (hasRunRef.current) {
    // We've already run this effect logic once -> skip
    return;
  }
  hasRunRef.current = true;

  // ✅ This block runs only once
  doExpensiveOrSideEffectWork();
}, [/* deps here, or [] */]);
```

**What this does:**

- First time:
  - `hasRunRef.current` is `false`
  - We run the logic, then set it to `true`
- Next times:
  - `hasRunRef.current` is `true`
  - We `return` early → no work, **no state updates**, so **no extra re-renders**

This is what your `permissionChecked` ref does for the microphone permission check.

---

### **Pattern 2: Avoiding state when you only need a “memory”**

Bad (causes re-renders you don’t need):

```ts
const [hasInitialized, setHasInitialized] = useState(false);

useEffect(() => {
  if (hasInitialized) return;
  setHasInitialized(true); // 🔁 triggers another render

  initializeSomething();
}, [hasInitialized]);
```

Better (no extra re-render just to flip a flag):

```ts
const hasInitialized = useRef(false);

useEffect(() => {
  if (hasInitialized.current) {
    return;
  }
  hasInitialized.current = true;

  initializeSomething();
}, []);
```

**Note:**  
- In the “bad” version, the **only reason** we use state is to remember “I’ve done this”.  
- That memory is not used in the JSX, so there’s no reason to pay the re-render cost.

---

### **Pattern 3: Storing previous values to avoid redundant `setState`**

Sometimes you only want to call `setState` if the new value is actually different.  
Instead of always calling `setState` inside `useEffect`, you can use a ref as a guard.

```ts
const [value, setValue] = useState<string>("");
const previousInputRef = useRef<string>("");

useEffect(() => {
  if (incomingValue === previousInputRef.current) {
    // Nothing changed, don't bother updating state
    return;
  }

  previousInputRef.current = incomingValue;
  setValue(incomingValue); // Only when it actually changed
}, [incomingValue]);
```

Result:

- Fewer state updates → fewer re-renders
- `useRef` holds the last value we applied, purely as an internal check.

---

### **How this connects to your `permissionChecked` code**

In your `use-speech-recognition` hook:

```ts
const permissionChecked = useRef(false);

useEffect(() => {
  if (!browserSupportsSpeechRecognition) {
    setError("Browser doesn't support speech recognition");
    return;
  }

  if (permissionChecked.current) {
    return;
  }
  permissionChecked.current = true;

  // async permission logic here...
}, [browserSupportsSpeechRecognition]);
```

- **Goal**: only run the permission checking logic once.
- **Without the ref**, if something triggers the effect again, you might re-run:
  - `navigator.permissions.query(...)`
  - And maybe more `setState` calls inside
- **With the ref**:
  - The **expensive + state-updating** logic is guaranteed to run once.
  - That means fewer `setState` calls → fewer re-renders.

---

### **Checklist you can use when writing effects**

When you write a `useEffect`, ask:

1. **Do I need this value to affect the UI directly?**
   - Yes → use `useState`
   - No → consider `useRef`

2. **Can this effect run more than once?**
   - If not desired, use a **ref guard**:
     - `if (hasRunRef.current) return;`
     - `hasRunRef.current = true;`

3. **Am I calling `setState` with the same value repeatedly?**
   - If yes, store the previous value in a ref and **skip** the update if nothing changed.

If you follow this, you’ll naturally avoid most unnecessary re-renders caused by `useEffect`.