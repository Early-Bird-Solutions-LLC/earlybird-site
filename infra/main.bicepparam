using './main.bicep'

// Phase 1 deploy: false (creates DNS zone + records, no SWA custom domain attach).
// Phase 2 deploy: true AFTER nameservers at the registrar are flipped and propagated.
param attachCustomDomains = true

// Phase 2b: apex validation token issued by SWA on first attach. Pasted in here
// so the apex TXT record set publishes it and dns-txt-token validation completes.
param apexValidationToken = '_v2hhqazt537llnaticqfgsfor91hwut'

// All other params use defaults from main.bicep.
// To override the preserved verification TXT tokens (e.g., once a stale token is
// identified and can be removed), set apexTxtRecords here.
