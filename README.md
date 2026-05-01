# Early Bird Solutions — Site

Static marketing site for [earlybirdsolutions.com](https://earlybirdsolutions.com). Built with Astro, deployed to Azure Static Web Apps.

## Stack

- **Astro 5** (static output, no JS by default)
- **Vanilla CSS** with design tokens — no Tailwind, no CSS-in-JS
- **Content collections** — services and case studies live as Markdown
- **Azure Static Web Apps** for hosting (free tier)
- **GitHub Actions** for CI/CD

## Quick start

```bash
npm install
npm run dev          # http://localhost:4321
npm run build        # outputs to ./dist
npm run preview      # preview the build
```

Node 20+ recommended.

## Project structure

```
src/
├── components/              # Reusable Astro components
│   ├── Nav.astro
│   ├── Hero.astro
│   ├── CredibilityStrip.astro
│   ├── ServicesGrid.astro
│   ├── WorkGrid.astro
│   ├── AboutTeaser.astro
│   ├── Footer.astro
│   └── case-thumbs/         # Per-case-study SVG illustrations
│       ├── PciLandingZone.astro
│       ├── ConfluenceRag.astro
│       └── NetModernization.astro
├── content/                 # Markdown content (editable)
│   ├── services/            # One file per service
│   └── work/                # One file per case study
├── content.config.ts        # Content collection schemas
├── layouts/
│   └── BaseLayout.astro     # HTML shell, meta tags, fonts
├── pages/                   # File-based routing
│   ├── index.astro          # Home
│   ├── services.astro
│   ├── work.astro
│   ├── about.astro
│   └── contact.astro
└── styles/
    └── global.css           # Design tokens + base styles
```

## Editing content

### Adding a service

Create a new file at `src/content/services/your-service.md`:

```yaml
---
number: "05"
order: 5
title: "Your service title"
summary: "Short description shown on home page and services index."
---

Long-form content for the future detail page.
```

It will appear automatically on the home page services grid (sorted by `order`) and on `/services`.

### Adding a case study

Create `src/content/work/your-case.md`:

```yaml
---
order: 4
title: "Case study title"
tag: "Case 04 · Industry · Anonymized"
summary: "One-line outcome for the home page card."
public: false
highlights:
  - "Key technical highlight 1"
  - "Key technical highlight 2"
---

Long-form description.
```

If you want a custom thumbnail SVG, create `src/components/case-thumbs/YourCase.astro` and register it in `src/components/WorkGrid.astro` in the `thumbs` map.

### Editing copy

Hero, About teaser, and Contact intro copy is in the corresponding component files (`Hero.astro`, `AboutTeaser.astro`) and pages (`about.astro`, `contact.astro`). Hardcoded intentionally — these are visual identity, not editable content.

## Design tokens

All in `src/styles/global.css` under `:root`. The whole visual system can be retuned by editing these:

| Token             | Purpose                              |
| ----------------- | ------------------------------------ |
| `--bg`            | Page background (warm cream)         |
| `--ink`           | Primary text (deep navy)             |
| `--ink-soft`      | Secondary text                       |
| `--accent`        | Amber accent — highlights, hovers    |
| `--accent-deep`   | Darker amber for hover states        |
| `--rule`          | Hairline divider color               |
| `--serif`         | Instrument Serif — display headlines |
| `--sans`          | IBM Plex Sans — body                 |
| `--mono`          | JetBrains Mono — labels, code        |

To go dark mode, swap `--bg` to a dark color, `--ink` to a light color, and re-tune `--rule` and `--ink-faint`.

## Deployment — Azure Static Web Apps

### One-time setup

1. **Create the Static Web App in Azure portal**:
   - Resource: Static Web App (Free tier is fine).
   - Plan type: Free.
   - Region: closest to you (e.g., East US 2).
   - Source: GitHub.
   - Repo: this one.
   - Branch: `main`.
   - Build presets: **Custom**.
   - App location: `/`
   - Output location: `dist`
   - When you click Create, Azure will commit a workflow file to your repo. **Delete it** — this repo already has a hand-tuned one at `.github/workflows/azure-static-web-apps.yml`. Then copy the deployment token Azure gave you.

2. **Add the deployment token to GitHub secrets**:
   - Repo → Settings → Secrets and variables → Actions → New repository secret.
   - Name: `AZURE_STATIC_WEB_APPS_API_TOKEN`
   - Value: the token from step 1.

3. **Push to `main`** — the workflow runs and deploys.

### Custom domain (earlybirdsolutions.com)

1. In the Static Web App resource → Custom domains → Add.
2. Pick "Custom domain on other DNS" (since you own the domain elsewhere).
3. Azure gives you a TXT or CNAME record to add at your DNS provider.
4. Validate. SSL is provisioned automatically.

For the apex domain (`earlybirdsolutions.com`), you'll likely need an ALIAS or ANAME record. Azure DNS supports this natively; if your registrar doesn't, either move DNS to Azure DNS or add `www.earlybirdsolutions.com` and redirect the apex.

**Don't proxy through Cloudflare.** Let Static Web Apps terminate TLS directly — fewer moving parts, automatic cert renewal.

### Headers and security

`staticwebapp.config.json` already sets:
- HSTS (2-year, preload-eligible)
- `X-Frame-Options: DENY`
- `X-Content-Type-Options: nosniff`
- A locked-down `Permissions-Policy`

If you ever embed external widgets (Calendly, Plausible, etc.), tune as needed.

## Things to do before going live

- [x] Replace placeholder Cal.com URL in `Footer.astro` and `contact.astro`
- [x] Replace placeholder LinkedIn URL in the same places
- [ ] Add an OG image at `public/og-default.png` (1200×630). The architecture diagram style would be on-brand.
- [ ] Decide whether to add Plausible or App Insights
- [ ] Verify the site renders well on mobile (especially `/work` table layout)
- [ ] Run Lighthouse against the deployed site — target 95+ across the board
- [ ] Submit `https://earlybirdsolutions.com/sitemap-index.xml` to Google Search Console (Astro can generate this with `@astrojs/sitemap` — add when ready)

## Future additions

- **Blog** — Astro Content Collections + a `/blog` route. Lift the markdown pattern already used for services/work.
- **Per-service detail pages** — `/services/[slug]` dynamic routes pulling from the existing collection.
- **Per-case-study detail pages** — same pattern at `/work/[slug]`.
- **Sitemap** — `npm install @astrojs/sitemap`, add to `astro.config.mjs`.
- **RSS** — `@astrojs/rss` if blog gets added.

## License

Private / proprietary. © Early Bird Solutions LLC.
