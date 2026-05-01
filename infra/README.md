# Infrastructure

Bicep template for the Early Bird Solutions site infrastructure. Deploys to the `UpworkDemo` Azure subscription in the `jim@earlybirdsolutions.onmicrosoft.com` tenant.

## What it manages

- **Static Web App** (`swa-earlybird-site`, Free tier, East US 2)
- **Azure DNS zone** for `earlybirdsolutions.com`
- DNS records: MX (Google Workspace), SPF, DMARC, apex verification TXTs, `www` CNAME, apex ALIAS to the SWA
- (Phase 2) SWA custom domains for the apex and `www`

GitHub Actions deploy of the site itself is separate (`.github/workflows/azure-static-web-apps.yml`) — that uses the SWA deployment token, which is rotated out-of-band and stored as a GitHub repo secret.

## Prerequisites

- Azure CLI logged in as `jim@earlybirdsolutions.onmicrosoft.com`
- Resource group `rg-earlybird-site` exists in `eastus2`
- Bicep CLI installed (ships with `az` 2.20+)

## Two-phase deploy

DNS-driven cert provisioning has a chicken-and-egg dependency on the registrar nameservers, so deployment runs in two phases.

### Phase 1 — DNS zone + records (no SWA custom domains attached)

```bash
az deployment group what-if \
  --resource-group rg-earlybird-site \
  --template-file infra/main.bicep \
  --parameters infra/main.bicepparam

az deployment group create \
  --name earlybird-infra-phase1 \
  --resource-group rg-earlybird-site \
  --template-file infra/main.bicep \
  --parameters infra/main.bicepparam
```

The deployment outputs `dnsZoneNameServers` — four values like `ns1-XX.azure-dns.com`, `.net`, `.org`, `.info`.

### Switch nameservers at the registrar

Change the nameservers for `earlybirdsolutions.com` from GoDaddy's defaults (`ns31.domaincontrol.com`, `ns32.domaincontrol.com`) to the four Azure DNS nameservers. **Domain Settings → Nameservers → "I'll use my own nameservers"** in the GoDaddy registrar page (NOT the DNS records page).

Propagation typically completes in 15–60 minutes. Verify with:

```bash
nslookup -type=NS earlybirdsolutions.com 8.8.8.8
```

When the four `ns*.azure-dns.*` nameservers are returned, you're authoritative on Azure DNS.

### Phase 2 — Attach SWA custom domains

Edit `main.bicepparam`:

```bicep
param attachCustomDomains = true
```

Re-deploy:

```bash
az deployment group create \
  --name earlybird-infra-phase2 \
  --resource-group rg-earlybird-site \
  --template-file infra/main.bicep \
  --parameters infra/main.bicepparam
```

The SWA will validate ownership via the `cname-delegation` method (it reads the CNAME and ALIAS records that already point at it), provision a TLS cert from DigiCert, and start serving HTTPS at both `https://earlybirdsolutions.com/` and `https://www.earlybirdsolutions.com/`.

Validation + cert provisioning typically takes 5–30 minutes per hostname.

## Idempotency notes

- **Deployment token:** Re-deploying the SWA via Bicep does NOT rotate the deployment token (the token lives under `Microsoft.Web/staticSites/secrets`, separate from the resource body managed here). Verified empirically.
- **DNS records:** PUT semantics — re-deploys overwrite the record set with the values in the template. To add an out-of-template record, add it to `main.bicep` first; otherwise it will be erased on the next deploy.

## Future work

- GitHub OIDC federated credential so this Bicep deploys from CI instead of a local `az` session.
- Identify the three opaque verification TXT tokens currently preserved (likely Stripe/Notion/MS-365-from-2023) and remove what's stale.
- Move DMARC policy from `p=none` to `p=quarantine` after a few weeks of report data.
- Optional: split the DNS zone + records into a separate deployment / module if more domains land here.
