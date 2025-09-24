Great question! Let me explain what `[locale]` is and how it works in your project.

Read file: apps/web/app/(marketing)/[locale]/layout.tsx
Ran tool
Read file: config/index.ts
Perfect! Now I can explain what `[locale]` is and how it works.

## **�� What is `[locale]`?**

`[locale]` is a **dynamic route parameter** in Next.js that captures the language/locale from the URL. It's how your app handles multiple languages.

## **📁 How It Works in Your Project**

### **File Structure:**
```typescript
apps/web/app/(marketing)/[locale]/
├── layout.tsx           ← Handles locale setup
├── page.tsx             ← Home page for each locale
├── blog/                ← Blog routes
├── docs/                ← Documentation routes
├── contact/             ← Contact page
├── legal/               ← Legal pages
└── [...rest]/           ← Catch-all for unknown routes
```

### **URL Structure:**
```typescript
/en          → English version
/de          → German version
/en/blog     → English blog
/de/blog     → German blog
/en/contact  → English contact page
/de/contact  → German contact page
```

## **�� How Locale Routing Works**

### **1. Supported Locales (from config):**
```typescript
locales: {
  en: { currency: "USD", label: "English" },
  de: { currency: "USD", label: "Deutsch" }
}
defaultLocale: "en"
```

### **2. URL Examples:**
```typescript
/en          → English (locale = "en")
/de          → German (locale = "de")
/            → Redirects to /en (default)
/unknown     → 404 (invalid locale)
```

### **3. What Happens in the Layout:**
```typescript
export default async function MarketingLayout({
  children,
  params,  // ← Contains { locale: "en" } or { locale: "de" }
}: PropsWithChildren<{ params: Promise<{ locale: string }> }>) {
  const { locale } = await params;
  
  // Set the locale for this request
  setRequestLocale(locale);
  
  // Check if locale is valid
  if (!locales.includes(locale as any)) {
    notFound(); // Show 404 for invalid locales
  }
  
  // Get translations for this locale
  const messages = await getMessages();
  
  // Render with locale-specific content
  return (
    <NextIntlClientProvider locale={locale} messages={messages}>
      {/* Your app content */}
    </NextIntlClientProvider>
  );
}
```

## **�� Why Use `[locale]` Instead of Route Groups?**

### **Route Groups `()` vs Dynamic Routes `[]`:**

```typescript
// ❌ Route Groups (no URL impact)
(marketing) + [locale] = /en, /de, /fr

// ✅ Dynamic Routes (URL impact)  
[locale] = /en, /de, /fr
```

**Route Groups are for organization only, Dynamic Routes create URL segments.**

## **�� Real Examples from Your App**

### **When user visits `/en`:**
1. Next.js captures `locale = "en"`
2. Layout loads English translations
3. Shows English content

### **When user visits `/de`:**
1. Next.js captures `locale = "de"`
2. Layout loads German translations
3. Shows German content

### **When user visits `/`:**
1. Next.js redirects to `/en` (default locale)
2. Same process as above

## **🔍 How to Access Locale in Components**

### **In Server Components:**
```typescript
// In a page.tsx
export default async function Page({ 
  params 
}: { 
  params: Promise<{ locale: string }> 
}) {
  const { locale } = await params;
  return <div>Current locale: {locale}</div>;
}
```

### **In Client Components:**
```typescript
// In a React component
import { useLocale } from 'next-intl';

export function MyComponent() {
  const locale = useLocale(); // "en" or "de"
  return <div>Locale: {locale}</div>;
}
```

## **🌐 Complete URL Structure**

```typescript
// Marketing pages (with locale)
/en              → English home
/de              → German home
/en/blog         → English blog
/de/blog         → German blog
/en/contact      → English contact
/de/contact      → German contact

// SaaS pages (no locale in URL)
/app             → App dashboard
/app/admin       → Admin panel
/app/settings    → Settings

// API (no locale)
/api             → API endpoints
/api/auth        → Auth endpoints
```

## **🎯 Key Points**

1. **`[locale]`** = Dynamic route that captures language from URL
2. **`/en`** = English version, **`/de`** = German version
3. **`/`** = Redirects to default locale (`/en`)
4. **Layout handles** locale setup, translations, and validation
5. **Only marketing pages** use locale routing (not SaaS app pages)

## **🚀 Why This Design?**

- **SEO friendly**: Each language has its own URL
- **User experience**: Users can bookmark language-specific pages
- **Clean URLs**: `/en/blog` instead of `?lang=en&page=blog`
- **Performance**: Each locale can be statically generated

Does this explain how `[locale]` works in your project? It's the foundation of your multi-language support! 🌍