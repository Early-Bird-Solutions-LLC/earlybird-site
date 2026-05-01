using './main.bicep'

// Phase 1 deploy: false (creates DNS zone + records, no SWA custom domain attach).
// Phase 2 deploy: change to true AFTER nameservers at the registrar are flipped to
// the values output by the Phase 1 deploy AND DNS propagation has completed.
param attachCustomDomains = false

// All other params use defaults from main.bicep.
// To override the preserved verification TXT tokens (e.g., once a stale token is
// identified and can be removed), set apexTxtRecords here.
