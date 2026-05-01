# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Context primer for Claude Code sessions working on this project. Also serves as plain project documentation.

## What this is

The marketing site for **Early Bird Solutions** — Jim Keeley's independent Azure AI consulting practice. Live at [earlybirdsolutions.com](https://earlybirdsolutions.com). The site exists to validate credibility for prospects who Google him before agreeing to a call.

**Audience:** Technical decision-makers (CTOs, VPs of Eng, hiring managers) evaluating whether to hire him. They will judge the site on craft within ~5 seconds.

**Tone:** Senior practitioner. Direct, specific, no AI/SaaS hype. No "transforming the future of work" language.

## Stack

- **Astro 5** — static output, no JS by default
- **Vanilla CSS** with design tokens — deliberately no Tailwind, no CSS-in-JS
- **Content collections** — services and case studies as Markdown with Zod-validated frontmatter
- **Azure Static Web Apps** for hosting (free tier)
- **GitHub Actions** for CI/CD via `.github/workflows/azure-static-web-apps.yml` (present in repo, hand-tuned — do not let Azure regenerate it)

## Commands

- `npm run dev` — dev server at http://localhost:4321
- `npm run build` — static build to `./dist`. **Run before every commit** — catches Zod schema errors in content collections and broken content refs that the dev server tolerates.
- `npm run preview` — preview the production build locally
- No test suite, no linter — `astro/tsconfigs/strict` (TypeScript strict mode) and `astro check` (run as part of `astro build`) are the only static checks. Don't add Jest/Vitest/ESLint without a reason; the surface area doesn't justify it.

Node 20+ recommended.

## Architecture flow

Pages in `src/pages/` are file-routed by Astro. The home page (`index.astro`) composes section components from `src/components/`. Two of those — `ServicesGrid.astro` and `WorkGrid.astro` — read from the `services` and `work` content collections defined in `src/content.config.ts` (Zod-validated frontmatter, Markdown bodies in `src/content/{services,work}/*.md`). `src/layouts/BaseLayout.astro` is the HTML shell (meta tags, fonts, global CSS import). Design tokens and base styles live in `src/styles/global.css`; component-specific styles use Astro's scoped `<style>` blocks.

The build is fully static (`output: 'static'` in `astro.config.mjs`). There is no client-side JS framework and no runtime — Astro ships zero JS by default and this site keeps it that way. Anything dynamic would need to be added deliberately.

`staticwebapp.config.json` is read at deploy time by Azure Static Web Apps for headers (HSTS, X-Frame-Options, Permissions-Policy) and 404 routing — it is not used by the Astro build.

## Architecture decisions worth not relitigating

These were debated and settled. Please don't suggest reversing without a strong reason.

- **Multi-page over SPA.** Better SEO, feels more substantial than a one-pager.
- **Vanilla CSS over Tailwind.** Site is small (~5 pages); design tokens in `global.css` are simpler than Tailwind class soup for this scale.
- **Content as Markdown via collections, not hardcoded.** Lets Jim add services/case studies without touching components.
- **Hardcoded hero/about/contact copy in components, not in collections.** That copy is visual identity, not editable content.
- **No contact form.** Email + Cal.com is cleaner. Form would need a backend.
- **No analytics yet.** Decision deferred. Plausible or App Insights when ready.
- **No blog yet.** Adding blog is a content commitment, not a tech decision.
- **No Cloudflare proxy.** Let SWA terminate TLS directly. Fewer moving parts.
- **Public repo.** Code transparency is a credibility signal for senior IC consulting.

## Design system

All tokens in `src/styles/global.css` under `:root`. Edit there to retune the visual system globally.

| Token             | Value      | Purpose                                |
| ----------------- | ---------- | -------------------------------------- |
| `--bg`            | `#F4F1EA`  | Warm off-white page background         |
| `--bg-tint`       | `#EDE8DC`  | Slightly darker bands (credibility strip) |
| `--paper`         | `#FAF8F2`  | Section variant (work section)         |
| `--ink`           | `#0F1A2C`  | Deep navy primary text                 |
| `--ink-soft`      | `#4A5568`  | Secondary text                         |
| `--ink-faint`     | `#8A8578`  | Mono labels, subtle metadata           |
| `--rule`          | `#D8D2C2`  | Hairline dividers                      |
| `--accent`        | `#B8763E`  | Amber — accents, hover states          |
| `--accent-deep`   | `#8C5829`  | Darker amber for hover-on-hover        |
| `--accent-bright` | `#E8A968`  | Lighter amber for dark backgrounds (footer) |

**Typography:**
- `--serif` — Instrument Serif. Display headlines, big numbers, italics for emphasis.
- `--sans` — IBM Plex Sans. Body, UI elements.
- `--mono` — JetBrains Mono. Labels, eyebrows, technical metadata. Always uppercase, letter-spaced.

**Aesthetic direction:** Editorial / refined minimalism. Warm cream background, deep navy ink, single amber accent. Asymmetric grids. Hairline rules. Numbered sections like a paper (`§ 01 — Services`). The vibe is senior practitioner's portfolio, not startup landing page. **Deliberately avoiding** Azure-blue gradients, generic Inter typography, and SaaS-template layouts.

## Content patterns

### Adding a service

Create `src/content/services/your-slug.md`:

```yaml
---
number: "05"
order: 5
title: "Your service title"
summary: "One paragraph for home page and services index. Specific, no buzzwords."
---

Long-form content for future detail page at /services/your-slug.
```

Appears automatically on home page services grid (sorted by `order`) and at `/services`.

### Adding a case study

Create `src/content/work/your-slug.md`:

```yaml
---
order: 4
title: "Case study title"
tag: "Case 04 · Industry · Anonymized"
summary: "One-line outcome for home page card."
public: false
highlights:
  - "Technical highlight 1"
  - "Technical highlight 2"
---

Long-form description.
```

If you want a custom thumbnail SVG: create `src/components/case-thumbs/YourCase.astro` and add it to the `thumbs` map in `src/components/WorkGrid.astro`. Use the same architecture-diagram style as existing thumbs (white containers, gradient accent bars, mono labels).

## Compliance / claims hygiene

**Important:** Never claim PCI-DSS v4.0 compliance — Jim's primary work is not yet on v4. Use just "PCI-DSS" until the v4 milestone lands at APS, then the three current locations (Hero, CredibilityStrip, services/pci-secure-ai.md) can be updated to add the version back. v4 is a real differentiator and worth claiming once it's true.

Other version refs in the codebase that are legitimate and should stay:
- "Application Gateway WAF v2" — actual Microsoft product version
- "Azure.AI.Projects v2 SDK" — actual SDK version
- ".NET 4.8", ".NET Core", ".NET 10" — actual framework versions

## Deployment

`.github/workflows/azure-static-web-apps.yml` builds and deploys on every push to `main`. PR builds get preview environments.

**One-time setup needed:**
1. Create Static Web App in Azure portal (Free tier). When Azure auto-commits a workflow file, delete it — this repo's hand-tuned one is better.
2. Add deployment token from Azure as `AZURE_STATIC_WEB_APPS_API_TOKEN` in repo secrets.
3. Custom domain: SWA → Custom domains → Add → "Custom domain on other DNS" → add the validation record at the registrar.

Security headers (HSTS, X-Frame-Options, Permissions-Policy, etc.) are configured in `staticwebapp.config.json`.

(Pre-launch todo list lives in `README.md` under "Things to do before going live" — kept there so it can decay without polluting this orientation file.)

## Working conventions

- **Always run `npm run build` before committing.** Catches content collection schema errors and broken refs that dev server tolerates.
- **Edit `global.css` tokens, not component styles, for visual changes that should propagate.** Component-scoped styles are for component-specific layout only.
- **Commit messages: present tense, specific.** "Add OG image" not "added OG image" or "OG image stuff".
- **Keep the editorial aesthetic.** Resist the urge to add gradient backgrounds, drop shadows, glassmorphism, or other SaaS-template tropes. The amber accent is the only chromatic moment.

## Background context on Jim (for tone calibration)

- Senior platform engineer, Microsoft Certified Azure Solutions Architect Expert + Administrator Associate
- Florida, Eastern timezone
- Active platform engineer on a multi-tenant fintech / PCI-regulated platform (APS / Neighborli)
- Real .NET + Azure depth, ~10+ years
- Currently working toward AI-102 (Azure AI Engineer Associate)
- Site copy should sound like him: direct, specific, technical-but-not-jargon-soup, never overselling

## Files Claude Code should read first when joining

1. This file (`CLAUDE.md`)
2. `README.md` — setup and deployment
3. `src/styles/global.css` — design tokens
4. `src/content.config.ts` — content schemas
5. `src/components/Hero.astro` — canonical example of component style and animation patterns
