Open the Swagger/Scalar docs in your browser using:

## Swagger Documentation URL

```
https://dhuw74riftblyd6d7r7jkhfxnu0yztug.lambda-url.ap-south-1.on.aws/api/docs
```

## Other useful endpoints

1. **Swagger UI (Scalar)**: 
   ```
   https://dhuw74riftblyd6d7r7jkhfxnu0yztug.lambda-url.ap-south-1.on.aws/api/docs
   ```

2. **Raw OpenAPI JSON**:
   ```
   https://dhuw74riftblyd6d7r7jkhfxnu0yztug.lambda-url.ap-south-1.on.aws/api/openapi
   ```

3. **Health Check**:
   ```
   https://dhuw74riftblyd6d7r7jkhfxnu0yztug.lambda-url.ap-south-1.on.aws/api/health
   ```

## Notes

- The app uses base path `/api` (line 25 in app.ts)
- The `/docs` endpoint uses Scalar (line 77-83)
- The `/openapi` endpoint returns the merged OpenAPI schema (line 63-75)

Open the `/api/docs` URL in your browser to view the interactive API documentation.