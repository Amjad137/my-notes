Salance: SaaS to PaaS Architecture Transformation

The Core Problem

Your current flow requires a developer for every new merchant:

flowchart LR
  A["Merchant fills form"] --> B["Admin reviews request"]
  B --> C["Developer copies template"]
  C --> D["Developer customizes code"]
  D --> E["Developer configures env vars"]
  E --> F["Developer deploys"]
  F --> G["Store goes live"]

Steps C through F are manual, expensive, and the reason the business is in loss. The goal is to eliminate them entirely.

Recommended Architecture: Multi-Tenant Storefront Engine

Not a monorepo with apps/template-1, apps/template-2. That still requires a separate deployment per merchant and doesn't solve your core problem. Instead:

One Next.js application per template, serving ALL merchants who chose that template. Each template app is deployed exactly once. Merchant resolution happens at runtime via domain/subdomain.

Domain Strategy: Two Tiers





Standard plan: Merchant gets {store-name}.salance.biz (wildcard subdomain, instant, zero config)



Premium plan: Merchant connects their own domain like philox.com (requires DNS verification + SSL provisioning)

Both domain types hit the same infrastructure. The resolution logic handles both.

flowchart TD
  subgraph standardDns ["Standard: *.salance.biz (wildcard DNS)"]
    req1["greenmart.salance.biz"]
    req2["luxgems.salance.biz"]
  end

  subgraph customDns ["Premium: Custom Domains"]
    req3["philox.com"]
    req4["shopelectro.lk"]
  end

  subgraph gateway ["Gateway Service (separate lightweight app)"]
    lookup["Lookup domain/subdomain in StorefrontConfig DB"]
    route["Determine templateId + storeId"]
  end

  subgraph templates ["Template Deployments (one per template, in Turborepo monorepo)"]
    t1["apps/clothing-template"]
    t2["apps/furniture-template"]
    t3["apps/electronics-template"]
  end

  subgraph templateMiddleware ["Next.js Middleware (inside each template app)"]
    resolve["Read x-store-id header from gateway, fetch full config, inject into app"]
  end

  req1 --> gateway
  req2 --> gateway
  req3 --> gateway
  req4 --> gateway
  gateway --> templateMiddleware
  templateMiddleware --> t1
  templateMiddleware --> t2
  templateMiddleware --> t3

Why This Over the Alternatives







Approach



Deployments per merchant



Developer effort per merchant



Self-service possible





Current (copy + deploy)



1 per merchant



High



No





Monorepo (apps/template-N)



1 per merchant



Medium (scripted)



Partially





Multi-tenant engine



0 (already deployed)



Zero



Yes





Single app with all themes



0



Zero



Yes, but large bundle, coupled templates

The multi-tenant approach gives you the cleanest separation: each template is its own codebase (you already have this), but serves multiple merchants. Adding a new merchant = inserting a database record.



Exactly Where Each Piece Lives (Clearing the Grey Area)

This is the concrete project structure. No ambiguity.

The Gateway Service (NEW project)

A new, lightweight Hono app (similar to your existing APIs). Its only job: receive ALL incoming requests (both *.salance.biz and custom domains), look up which template + store they belong to, and reverse-proxy to the correct template app.

salance-gateway/                    # NEW PROJECT
  src/
    index.ts                        # Hono app entry
    handlers/
      resolve.handler.ts            # Domain/subdomain lookup logic
    services/
      storefront-config.service.ts  # DB lookup + Redis/Momento cache
    config/
      env.config.ts
      db.config.ts
      cache.config.ts

Request flow through the gateway:

sequenceDiagram
  participant Browser
  participant DNS
  participant Gateway as Gateway Service
  participant Cache as Cache Layer
  participant DB as MongoDB
  participant Template as Template App

  Browser->>DNS: philox.com OR greenmart.salance.biz
  DNS->>Gateway: Route to gateway IP

  Gateway->>Cache: Lookup "philox.com" or subdomain "greenmart"
  alt Cache hit
    Cache-->>Gateway: storeId, templateId, apiKey
  else Cache miss
    Gateway->>DB: Query StorefrontConfig by domain or subdomain
    DB-->>Gateway: Full config
    Gateway->>Cache: Cache for 5 min
  end

  Gateway->>Template: Proxy to correct template app with headers
  Note right of Gateway: Sets x-store-id, x-api-key, x-store-subdomain headers

  Template->>Template: Next.js middleware reads headers, fetches full config
  Template-->>Browser: Rendered HTML with merchant branding

How the gateway resolves both domain types:





Extract hostname from request (e.g., philox.com or greenmart.salance.biz)



If hostname ends with .salance.biz -> extract subdomain -> query StorefrontConfig.subdomain



If hostname is anything else -> query StorefrontConfig.customDomain



Result gives templateId -> proxy to the correct template app's URL



Forward with headers: x-store-id, x-api-key, x-store-subdomain

The Template Apps (REFACTORED existing projects, in a Turborepo monorepo)

Each template app is the existing template codebase (e.g., philox-clothing) refactored to remove hardcoded values. They live together in a monorepo for shared code.

salance-storefronts/                # NEW TURBOREPO MONOREPO
  apps/
    clothing-template/              # Refactored from philox-clothing
      middleware.ts                 # <-- THIS IS WHERE THE NEXT.JS MIDDLEWARE LIVES
      src/
        app/
          layout.tsx                # Dynamic metadata from config
          (group)/
            page.tsx                # Dynamic hero from config
            products/
            cart/
            checkout/
        config/
          site.config.ts            # NOW reads from StorefrontConfig, not hardcoded
        components/
          shared/
            logo.tsx                # NOW renders config.branding.logoUrl
            footer.tsx              # NOW renders config.social, config.contact
        providers/
          storefront-config.provider.tsx  # React context for config
        features/                   # Same as current philox-clothing
    furniture-template/
      middleware.ts                 # Same pattern
      src/...
    electronics-template/
      middleware.ts
      src/...
  packages/
    storefront-core/                # Shared: API client, cart logic, checkout, types
    storefront-payments/            # Shared: PayHere, MintPay, Koko, Stripe, COD
    storefront-config/              # Shared: config provider, types, cache utils
      src/
        middleware-utils.ts         # Shared middleware logic (used by each app's middleware.ts)
        config-provider.tsx         # React context provider
        types.ts                    # IStorefrontConfig type
        cache.ts                    # Config caching logic
  turbo.json
  package.json

The middleware.ts in each template app (e.g., apps/clothing-template/middleware.ts):





Reads the x-store-id and x-api-key headers that the gateway already set



Fetches the FULL StorefrontConfig (branding, theme, content, social, SEO) from consumer API (cached)



Sets the config in a cookie or response header for the app to consume



This is lightweight -- the heavy domain resolution already happened in the gateway

Why the middleware is in the template app, not the gateway:





The gateway does domain-to-template routing (lightweight, fast, cacheable)



The template's middleware fetches the full config and makes it available to React components



This separation means the gateway stays fast and simple, while each template can handle its own config shape



How SEO Works (Not a Problem -- Actually a Strength)

This is a critical concern, so here is exactly why multi-tenant SSR is SEO-friendly:

Each merchant is a separate website to Google





Unique domain/subdomain: greenmart.salance.biz and philox.com are completely separate sites to Google's crawler. They get separate entries in Google Search Console, separate indexing, separate rankings.



Server-Side Rendering: Next.js renders the full HTML on the server BEFORE sending it to the browser. When Googlebot crawls greenmart.salance.biz/products/123, it receives complete HTML with that merchant's product name, description, price, images -- not a loading spinner.



Unique content per merchant: Even though the template HTML structure is the same, the CONTENT is completely different (different products, categories, prices, descriptions, images). Google cares about content, not HTML structure. This is exactly how Shopify works -- millions of stores use the same ~100 themes, all indexed perfectly.



Dynamic metadata: Each page generates its own <title>, <meta name="description">, <link rel="canonical">, Open Graph tags from the StorefrontConfig and product data. Example:





greenmart.salance.biz -> <title>GreenMart - Fresh Organic Groceries</title>



philox.com -> <title>PHILOX Clothing - Stand Brave</title>



Canonical URLs: The <link rel="canonical"> tag uses the merchant's actual domain. For greenmart.salance.biz, canonical is https://greenmart.salance.biz/.... For philox.com, canonical is https://philox.com/.... No cross-domain confusion.

What you must implement correctly





Dynamic generateMetadata() in Next.js layout/pages that reads from StorefrontConfig (not hardcoded)



Dynamic robots.txt and **sitemap.xml** per merchant (Next.js route handlers that query the store's products/categories)



Canonical URLs that use the merchant's actual domain (subdomain or custom domain)



Structured data (JSON-LD) for products, breadcrumbs, organization -- generated per merchant



No noindex on merchant pages -- each merchant's store should be fully crawlable

SEO advantage of custom domains (premium tier)

Custom domains (philox.com) have a slight SEO edge over subdomains (philox.salance.biz) because:





Google treats subdomains as related-but-separate from the parent domain



A custom domain gets 100% independent domain authority



This is a genuine value proposition for the premium plan



Phase 1: Storefront Configuration System (Backend)

1.1 New StorefrontConfig Model

Add a new collection to hold everything that's currently hardcoded in the template code. This goes in all three APIs (consumer, merchant, admin).

interface IStorefrontConfig {
  store: Types.ObjectId; // ref to Store
  subdomain: string; // unique, indexed (e.g., "philox") -- ALWAYS present
  customDomain?: string; // indexed, unique when set (e.g., "philox.com") -- premium only
  customDomainVerified: boolean; // DNS verification status for custom domain
  templateId: string; // "clothing" | "furniture" | "electronics" | etc.
  plan: 'STARTER' | 'PREMIUM'; // determines feature access (custom domain, etc.)

  branding: {
    storeName: string;
    logoUrl?: string;
    faviconUrl?: string;
    tagline?: string;
  };

  theme: {
    primaryColor: string; // hex
    secondaryColor: string;
    accentColor: string;
    fontFamily: string; // from a predefined list
    borderRadius: 'none' | 'sm' | 'md' | 'lg' | 'full';
  };

  content: {
    heroTitle: string;
    heroSubtitle?: string;
    heroImageUrl?: string;
    aboutText?: string;
    footerText?: string;
  };

  social: {
    facebook?: string;
    instagram?: string;
    tiktok?: string;
    whatsapp?: string;
    twitter?: string;
  };

  contact: {
    email: string;
    phone?: string;
    address?: string;
  };

  seo: {
    title: string;
    description: string;
    keywords: string[];
    ogImageUrl?: string;
  };

  // The canonical domain for this store (computed):
  // If customDomain is set and verified -> customDomain
  // Otherwise -> "{subdomain}.salance.biz"
  // Used for canonical URLs, sitemap, robots.txt, OG tags

  status: 'ACTIVE' | 'SUSPENDED' | 'MAINTENANCE';
}

Database indexes for fast domain resolution:





{ subdomain: 1 } -- unique index, for *.salance.biz lookups



{ customDomain: 1 } -- unique sparse index, for custom domain lookups



{ store: 1 } -- for merchant dashboard lookups

1.2 New API Endpoints

Consumer API (gateway + storefronts call this):





GET /v1/storefront-config/resolve?subdomain=philox -- resolve by subdomain (for *.salance.biz)



GET /v1/storefront-config/resolve?domain=philox.com -- resolve by custom domain



Both return: full config + public API key + templateId. The gateway calls this to know where to route. The template middleware calls this to get the full branding config.

Merchant API (dashboard calls this):





GET /v1/storefront-config -- get config for current store



PATCH /v1/storefront-config -- update branding, theme, content, social, SEO



POST /v1/storefront-config/custom-domain -- request custom domain (premium only)



GET /v1/storefront-config/verify-domain -- check DNS verification status



DELETE /v1/storefront-config/custom-domain -- remove custom domain

Admin API:





POST /v1/storefront-config -- create config during provisioning



Full CRUD for managing all configs



PATCH /v1/storefront-config/:id/verify-domain -- manually verify/approve custom domain

1.3 Extend the Existing Store Model

The existing Store model at salance-merchant-api/src/models/store.model.ts already has name, email, address, image, category, keys. The new StorefrontConfig is a separate collection referencing Store, keeping concerns separated. The Store model stays as-is for business logic; StorefrontConfig handles presentation.



Phase 2: Multi-Tenant Template Refactor

(The middleware architecture is already explained in detail in "Exactly Where Each Piece Lives" above. This phase covers the implementation work.)

2.1 Refactor Template to Be Config-Driven

Currently in philox-clothing, these are hardcoded and need to become dynamic:





src/config/site.config.ts -- read from StorefrontConfig



src/constants/common-constants.ts -- social links, contact info from API



src/components/shared/logo.tsx -- render config.branding.logoUrl or config.branding.storeName



src/app/layout.tsx -- metadata from config.seo



CSS variables in global.css -- injected from config.theme at runtime

Key pattern: Create a React context (StorefrontConfigProvider) that wraps the app and provides the config everywhere. Server components fetch it; client components consume via context.

2.2 API Client Refactor

Currently api.config.ts reads environment.apiKeyPublic from env vars. Change it to read from the resolved store config:

// Before: hardcoded per deployment
headers: { 'x-api-key': environment.apiKeyPublic }

// After: resolved per tenant at runtime
headers: { 'x-api-key': storefrontConfig.apiKeyPublic }

2.3 Shared Packages (Turborepo)

Since all templates share cart, checkout, payment gateway, and API client logic, extract these into shared packages:

salance-storefronts/
  apps/
    clothing-template/    # current philox-clothing, refactored
    furniture-template/
    electronics-template/
    ...
  packages/
    storefront-core/      # API client, cart logic, checkout, types
    storefront-payments/  # PayHere, MintPay, Koko, Stripe, COD
    storefront-ui/        # shared components (if any)
    storefront-config/    # middleware, config provider, tenant resolution

This is where the monorepo makes sense -- not for deploying per-merchant, but for sharing code across templates while keeping each template as its own deployable app.



Phase 3: Self-Service Provisioning

3.1 Enhanced Merchant Onboarding Flow

Replace the current 3-step form + manual admin review with an automated flow:

flowchart TD
  A["Merchant visits salance.biz"] --> B["Chooses template"]
  B --> C["Fills business details"]
  C --> D["Customizes branding: name, logo, colors, hero text"]
  D --> E["Chooses subdomain: xxx.salance.biz"]
  E --> F["Selects plan and pays via Stripe"]
  F --> G["Provisioning API triggered"]

  subgraph auto ["Automated Provisioning (< 5 seconds)"]
    G --> H["Create User account"]
    H --> I["Create Store + API keys"]
    I --> J["Create StorefrontConfig"]
    J --> K["Subdomain goes live instantly via wildcard DNS"]
  end

  K --> L["Merchant redirected to dashboard"]
  L --> M["Store is live at xxx.salance.biz"]

3.2 Provisioning API

A new endpoint (in admin-api or a new provisioning service) that atomically:





Creates the merchant user (with temporary password or magic link)



Creates the store with API keys (existing logic in salance-admin-api/src/handlers/v1/store.handler.ts)



Creates the StorefrontConfig with all the branding data from the form



Records the subscription/payment



Sends welcome email with dashboard credentials

3.3 DNS and Domain Strategy

Standard plan (*.salance.biz):





Wildcard DNS: *.salance.biz -> gateway service IP/load balancer



Instant: merchant picks subdomain during signup, it works immediately (no DNS propagation needed since the wildcard already covers it)



SSL: Wildcard certificate for *.salance.biz (one cert covers all merchants)

Premium plan (custom domains like philox.com):





Merchant adds their domain in the dashboard



System shows them DNS instructions: "Add a CNAME record pointing philox.com to storefront.salance.biz"



Background job polls DNS to verify the CNAME is set (customDomainVerified: true)



Once verified, the gateway accepts requests from philox.com and routes them correctly



SSL: Automatic certificate provisioning per custom domain





Vercel: Handles this automatically when you add a custom domain via their API



AWS: ACM (AWS Certificate Manager) + CloudFront for automatic SSL



Caddy (self-hosted option): Automatic HTTPS via Let's Encrypt

How the gateway handles both:

flowchart TD
  req["Incoming request"]
  req --> extract["Extract hostname"]
  extract --> check{"Ends with .salance.biz?"}

  check -->|Yes| subdomain["Extract subdomain part"]
  subdomain --> querySubdomain["Query: StorefrontConfig.subdomain = extracted"]

  check -->|No| customDomain["Treat as custom domain"]
  customDomain --> queryDomain["Query: StorefrontConfig.customDomain = hostname AND customDomainVerified = true"]

  querySubdomain --> found{"Config found?"}
  queryDomain --> found

  found -->|Yes| proxy["Proxy to template app (templateId from config)"]
  found -->|No| error["Return 404 / landing page"]

Canonical URL logic in templates:





If the merchant has a verified custom domain -> canonical = https://philox.com/...



If not -> canonical = https://greenmart.salance.biz/...



This is computed from StorefrontConfig and used in generateMetadata(), sitemap.xml, robots.txt



Phase 4: Merchant Dashboard Enhancements

Extend the existing salance-merchant-dashboard with:





Storefront Customizer: A settings page where merchants can update their branding, theme colors, hero content, social links, contact info, and SEO metadata. Changes reflect immediately since the storefront reads from the API.



Live Preview: Show a preview of their storefront with the current config.



Domain Management: Manage their subdomain and custom domain.



What Stays the Same





Consumer API (salance-consumer-api/src/index.ts): Unchanged core. Still uses x-api-key for store isolation. Just add the storefront-config endpoint.



Merchant API (salance-merchant-api/src/index.ts): Unchanged core. Add storefront-config CRUD.



Admin API (salance-admin-api/src/index.ts): Unchanged core. Add provisioning endpoint.



Store data model: The existing Store, Product, Order, Category, Customer models are untouched.



API-key-based multi-tenancy: Already works perfectly. The storefront engine just resolves which API key to use at runtime instead of compile time.



Deployment Architecture

flowchart TB
  subgraph internet ["Internet"]
    browserA["Customer visits greenmart.salance.biz"]
    browserB["Customer visits philox.com"]
  end

  subgraph dnsLayer ["DNS Layer"]
    wildcardDns["*.salance.biz wildcard DNS"]
    customDns["philox.com CNAME -> storefront.salance.biz"]
  end

  subgraph gatewayLayer ["Gateway Service (Hono app, single deployment)"]
    gateway["Domain resolution + template routing + config cache"]
  end

  subgraph monorepo ["salance-storefronts Turborepo Monorepo"]
    subgraph templateApps ["apps/ (one deployment each)"]
      clothing["clothing-template"]
      furniture["furniture-template"]
      electronics["electronics-template"]
    end
    subgraph sharedPkgs ["packages/ (shared code)"]
      core["storefront-core"]
      payments["storefront-payments"]
      configPkg["storefront-config"]
    end
  end

  subgraph apis ["APIs (AWS Lambda, unchanged)"]
    consumerApi["consumer-api"]
    merchantApi["merchant-api"]
    adminApi["admin-api"]
  end

  subgraph data ["Database"]
    mongo["MongoDB: stores, products, orders, storefront_configs"]
  end

  browserA --> wildcardDns --> gateway
  browserB --> customDns --> gateway
  gateway -->|"templateId=clothing"| clothing
  gateway -->|"templateId=furniture"| furniture
  gateway -->|"templateId=electronics"| electronics
  clothing --> consumerApi
  furniture --> consumerApi
  electronics --> consumerApi
  consumerApi --> mongo
  merchantApi --> mongo
  adminApi --> mongo

  clothing -.->|"imports"| core
  clothing -.->|"imports"| payments
  clothing -.->|"imports"| configPkg



Implementation Priority

The phases are ordered by business impact. Phase 1 + 2 are the minimum to go live with the new model. Phase 3 adds self-service. Phase 4 adds merchant autonomy.

Estimated effort: Phase 1 (1-2 weeks), Phase 2 (2-3 weeks), Phase 3 (1-2 weeks), Phase 4 (1-2 weeks). A single experienced developer can execute this in 6-8 weeks.