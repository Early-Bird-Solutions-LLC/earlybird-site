---
order: 1
title: "RAG-powered HR assistant over SharePoint"
tag: "Case 01 · SharePoint RAG · Anonymized"
summary: "Internal AI assistant answering HR-policy questions for employees of a regulated multi-tenant fintech platform. Grounded in SharePoint, deployed on Blazor + Entra ID, later promoted to a Foundry Agent."
public: false
highlights:
  - "Azure OpenAI: GPT-4o + text-embedding-3-small"
  - "Azure AI Search vector index over the SharePoint document corpus"
  - ".NET 10 Blazor Web App (Auto render mode) with MudBlazor UI"
  - "Microsoft Entra ID (OIDC) with company-tenant access only"
  - "Bicep IaC; subsequently promoted into Azure AI Foundry as a managed Agent"
---

Built end-to-end as a focused RAG application: SharePoint as the document
source, Azure AI Search for hybrid retrieval, and Azure OpenAI for grounded
chat completions with cited sources. Shipped to internal employees behind
Entra ID, then promoted into Azure AI Foundry where it now runs as a managed
Agent alongside other knowledge agents in the platform.
