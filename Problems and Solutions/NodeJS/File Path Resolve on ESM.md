```TypeScript
Explaining how it works

## How `import.meta.url` Works

**1. `import.meta.url`** — ESM feature that provides the URL of the current module:
```javascript
// In pdf-service.ts, this gives you something like:
// "file:///D:/Amjath/.../atscore/packages/api/src/routes/ats/lib/pdf-service.ts"
```

**2. `fileURLToPath()`** — Converts a file URL to a file system path:
```javascript
// Converts: "file:///D:/path/to/file.ts"
// To: "D:/path/to/file.ts" (Windows) or "/path/to/file.ts" (Unix)
```

**3. `path.dirname()`** — Gets the directory containing the file:
```javascript
// From: "D:/.../pdf-service.ts"
// To: "D:/.../lib"
```

**4. `path.resolve()`** — Resolves a relative path from that directory:
```javascript
// Combines: "D:/.../lib" + "templates/cv-jd-scan.html"
// Result: "D:/.../lib/templates/cv-jd-scan.html"
```

**Why this works:**
- Works in ESM (ES modules)
- Resolves relative to the file, not `process.cwd()`
- Works regardless of where the code runs (dev, build, production)
- Standard ESM pattern for file-relative paths
```