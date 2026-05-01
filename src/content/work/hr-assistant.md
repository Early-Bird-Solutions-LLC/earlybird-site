---
order: 1
title: "Internal HR assistant over SharePoint"
tag: "Case 01 · SharePoint RAG · Anonymized"
summary: "RAG-powered employee Q&A over an HR-policy corpus in SharePoint, behind enterprise SSO. Later promoted into Azure AI Foundry as a managed Agent."
public: false
highlights:
  - "Azure OpenAI: GPT-4o + text-embedding-3-small"
  - "Azure AI Search vector index over the SharePoint document corpus"
  - ".NET 10 Blazor Web App (Auto render mode) with MudBlazor UI"
  - "Microsoft Entra ID (OIDC) — single-tenant access only"
  - "Bicep IaC; subsequently promoted into Azure AI Foundry as a managed Agent"
manifest:
  - key: "Source"
    value: "SharePoint · HR document corpus"
  - key: "Retrieval"
    value: "Azure AI Search · vector index"
  - key: "Reasoning"
    value: "Azure OpenAI · GPT-4o · text-embedding-3-small"
  - key: "Delivery"
    value: ".NET 10 Blazor (Auto) · MudBlazor · Entra ID OIDC"
  - key: "Infra"
    value: "Bicep · later promoted to Foundry Agent"
---

End-to-end RAG application: SharePoint as the document source, Azure AI
Search for hybrid retrieval, and Azure OpenAI for grounded chat completions
with cited sources. Shipped to internal employees behind enterprise SSO,
then promoted into Azure AI Foundry where it now runs as a managed Agent
alongside other knowledge agents on the platform.
