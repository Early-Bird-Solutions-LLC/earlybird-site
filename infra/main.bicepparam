using './main.bicep'

// Phase 1 deploy: false (creates DNS zone + records, no SWA custom domain attach).
// Phase 2 deploy: true AFTER nameservers at the registrar are flipped and propagated.
param attachCustomDomains = true

// All other params use defaults from main.bicep.
// To override the preserved verification TXT tokens (e.g., once a stale token is
// identified and can be removed), set apexTxtRecords here.
