---
order: 1
title: "Multi-tenant PCI-DSS landing zone"
tag: "Case 01 · Fintech · Anonymized"
summary: "Reduced mandatory compliance baseline from $6,000+/mo to ~$200/mo while preserving full audit posture."
public: false
highlights:
  - "Application Gateway WAF v2 with per-listener policy and per-tenant IP restrictions"
  - "Azure Deployment Stacks enforced through tooling and policy"
  - "Container Apps with Defender for Containers"
  - "Microsoft Sentinel + Defender suite"
  - "Custom blob-backed signing key store for Duende IdentityServer"
---

A multi-tenant payments platform required a PCI-DSS compliant Azure landing
zone without the typical six-figure baseline cost. Initial gap analysis sized
mandatory controls at $6,000+/month. Through careful separation of truly
mandatory from best-practice controls, the hardened compliance baseline was
reduced to ~$200/month while preserving audit posture.
