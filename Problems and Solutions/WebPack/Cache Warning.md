We Get:
@repo/web:build: <w> [webpack.cache.PackFileCacheStrategy] Serializing big strings (855kiB) impacts deserialization performance (consider using Buffer instead and decode when needed)
@repo/web:build: <w> [webpack.cache.PackFileCacheStrategy] Serializing big strings (128kiB) impacts deserialization performance (consider using Buffer instead and decode when needed)

Explanation:
These are webpack cache performance warnings, not errors. They indicate large strings are being serialized in the cache, which can slow down cache deserialization.

They’re informational and don’t block the build. Common causes:
1. Large files (e.g., HTML templates) being processed
2. Large generated code chunks

Since we’re using a large HTML template (`cv-jd-scan.html`), this is expected.

If you want to suppress them, you can adjust the webpack config, but it’s not necessary. The build should complete successfully despite these warnings.

Checking if the build completes successfully:

**Explanation**: These are webpack cache performance warnings, not errors. They indicate large strings (855kiB and 128kiB) are being cached, which can slow cache deserialization.

**Why they appear**: Likely from the HTML template (`cv-jd-scan.html`) being processed during the build.

**Action needed**: None. These are informational and don't affect build success. They're common with large templates or generated code.

**If you want to suppress them** (optional), you can add this to the webpack config, but it's not necessary:

```typescript
webpack: (config, { webpack, isServer }) => {
    // ... existing code ...
    config.infrastructureLogging = {
        level: 'error', // Only show errors, suppress warnings
    };
    return config;
}
```

The build should complete successfully. These warnings are safe to ignore.