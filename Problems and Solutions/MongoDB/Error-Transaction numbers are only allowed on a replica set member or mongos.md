
whats run-rs:[[run-rs]]

install globally
npm install -g run-rs

Sometimes issue may arise:
### 🧠 What’s happening?

You’re installing `run-rs`, which depends on `kerberos`, which uses native code — and that **requires C++ build tools** on Windows.

Right now, it’s failing because:

- You **don’t have Visual Studio build tools installed**, specifically the **"Desktop development with C++"** workload
    
- Node-gyp can’t compile native modules like `kerberos` without them
    

---

### ✅ How to fix this (only needs to be done once)

#### 🔧 Step 1: Install **Visual Studio Build Tools**

Download from here:  
👉 [https://visualstudio.microsoft.com/visual-cpp-build-tools/](https://visualstudio.microsoft.com/visual-cpp-build-tools/)

During install, **check this workload**:

✅ **"Desktop development with C++"**

That includes all the compilers and SDKs needed for Node.js native modules.