Alright — here’s your **HTTP Response Headers Cheat Sheet** 📜
Perfect for when you’re sending files, APIs, or securing responses in Next.js.

---

## **HTTP Response Headers — Quick Reference Table**

| **Header**                       | **Purpose**                            | **Common Values / Parameters**                                                 | **Example**                                              |
| -------------------------------- | -------------------------------------- | ------------------------------------------------------------------------------ | -------------------------------------------------------- |
| **Content-Type**                 | Tells browser the file type & encoding | `text/html; charset=utf-8`, `application/json`, `application/pdf`, `image/png` | `Content-Type: application/pdf`                          |
| **Content-Disposition**          | Suggests file handling behavior        | `inline`, `attachment; filename="file.pdf"`                                    | `Content-Disposition: attachment; filename="report.pdf"` |
| **Content-Length**               | Size of content in bytes               | Integer                                                                        | `Content-Length: 23456`                                  |
| **Content-Encoding**             | How content is compressed              | `gzip`, `br`, `deflate`                                                        | `Content-Encoding: gzip`                                 |
| **Content-Language**             | Language of content                    | `en-US`, `fr`, `si-LK`                                                         | `Content-Language: en-US`                                |
| **Cache-Control**                | Browser/CDN caching rules              | `no-store`, `no-cache`, `max-age=3600`, `public`, `private`                    | `Cache-Control: public, max-age=86400`                   |
| **Expires**                      | Date/time after which content is stale | HTTP date                                                                      | `Expires: Wed, 14 Aug 2025 12:00:00 GMT`                 |
| **ETag**                         | Unique version identifier for content  | String hash                                                                    | `ETag: "abc123"`                                         |
| **Last-Modified**                | When content last changed              | HTTP date                                                                      | `Last-Modified: Tue, 13 Aug 2025 12:00:00 GMT`           |
| **Vary**                         | Determines cache variations            | `Accept-Encoding`, `User-Agent`                                                | `Vary: Accept-Encoding`                                  |
| **Content-Security-Policy**      | Restricts allowed sources for content  | `default-src 'self'; img-src 'self' https:`                                    | `Content-Security-Policy: default-src 'self'`            |
| **X-Content-Type-Options**       | Prevents MIME sniffing                 | `nosniff`                                                                      | `X-Content-Type-Options: nosniff`                        |
| **X-Frame-Options**              | Prevent iframe embedding               | `DENY`, `SAMEORIGIN`                                                           | `X-Frame-Options: DENY`                                  |
| **Strict-Transport-Security**    | Forces HTTPS                           | `max-age=31536000; includeSubDomains`                                          | `Strict-Transport-Security: max-age=31536000`            |
| **Referrer-Policy**              | Controls referrer info sent            | `no-referrer`, `strict-origin`                                                 | `Referrer-Policy: no-referrer`                           |
| **Permissions-Policy**           | Enables/disables browser features      | `camera=(), microphone=(), geolocation=()`                                     | `Permissions-Policy: geolocation=()`                     |
| **Accept-Ranges**                | Allows partial downloads               | `bytes`                                                                        | `Accept-Ranges: bytes`                                   |
| **Content-Range**                | Specifies which part of file is sent   | `bytes 0-1023/2048`                                                            | `Content-Range: bytes 0-500/1234`                        |
| **Access-Control-Allow-Origin**  | CORS origin allowlist                  | `*`, `https://myapp.com`                                                       | `Access-Control-Allow-Origin: *`                         |
| **Access-Control-Allow-Methods** | Allowed HTTP methods for CORS          | `GET, POST, PUT, DELETE`                                                       | `Access-Control-Allow-Methods: GET, POST`                |
| **Access-Control-Allow-Headers** | Allowed custom headers                 | `Content-Type, Authorization`                                                  | `Access-Control-Allow-Headers: Content-Type`             |
| **Set-Cookie**                   | Send cookies to browser                | `name=value; HttpOnly; Secure; SameSite=Strict`                                | `Set-Cookie: sessionId=abc123; HttpOnly; Secure`         |
| **Link**                         | Preload or prefetch resources          | `<style.css>; rel=preload; as=style`                                           | `Link: </app.js>; rel=preload; as=script`                |

---

## **📦 Example: Sending a Secure PDF Download in Next.js**

```js
import { NextResponse } from 'next/server';

export async function GET() {
  const fileBuffer = await generatePDF(); // your PDF generation function
  
  return new NextResponse(fileBuffer, {
    status: 200,
    headers: {
      'Content-Type': 'application/pdf',
      'Content-Disposition': `attachment; filename="report_${Date.now()}.pdf"`,
      'Content-Length': fileBuffer.length.toString(),
      'Cache-Control': 'no-store',
      'X-Content-Type-Options': 'nosniff',
      'Strict-Transport-Security': 'max-age=31536000; includeSubDomains',
    }
  });
}
```

---

If you want, I can make you a **color-coded A4 printable PDF version** of this cheat sheet so you can stick it on your desk while coding.
It’ll be easy to glance at and remember.

Do you want me to prepare that next?
