Perfect 👍

Just like `robots.ts`, Next.js also supports a **special file** for generating a **dynamic sitemap**:

```
apps/web/app/sitemap.ts
```

---

## 📍 What is a sitemap?

* It’s an XML file (`/sitemap.xml`) that lists all important URLs on your site.
* Helps **search engines discover** and index your content faster.
* Example:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://example.com/</loc>
    <lastmod>2025-08-19</lastmod>
  </url>
  <url>
    <loc>https://example.com/blog/hello-world</loc>
    <lastmod>2025-08-18</lastmod>
  </url>
</urlset>
```

---

## 🔹 How Next.js handles `sitemap.ts`

You can create a **dynamic sitemap generator** like this:

```ts
// apps/web/app/sitemap.ts
import { MetadataRoute } from "next";

export default function sitemap(): MetadataRoute.Sitemap {
  return [
    {
      url: "https://example.com",
      lastModified: new Date(),
      changeFrequency: "daily",
      priority: 1.0,
    },
    {
      url: "https://example.com/blog",
      lastModified: new Date(),
      changeFrequency: "weekly",
      priority: 0.8,
    },
  ];
}
```

---

## 🔹 Benefits

* **Dynamic**: You can pull URLs from your database or CMS instead of hardcoding them.
* **SEO Boost**: Makes sure search engines don’t miss deep/nested pages.
* **Auto-served**: Next.js will serve this at `/sitemap.xml`.

---

✅ **Summary:**

* `app/robots.ts` → Generates `/robots.txt` (controls crawling).
* `app/sitemap.ts` → Generates `/sitemap.xml` (helps discovery & indexing).

---

👉 Do you want me to show you how to **auto-generate a sitemap from your blog routes** (using `[...path]` you showed earlier)? That would connect everything nicely.
