---
order: 2
title: "Confluence RAG with .NET WebForms"
tag: "Case 02 · Confluence RAG · Public POC"
summary: "End-to-end retrieval platform with a legacy .NET 4.8 WebForms control proving AI drops into intranets without a rewrite. Plus a separate AI item-prioritization service."
public: true
highlights:
  - "Azure AI Services: GPT-4o + text-embedding-3-large (3072 dims)"
  - "Azure AI Search hybrid retrieval (vector + BM25)"
  - ".NET Framework 4.8 Web API 2 (OWIN) + .NET 4.8 ASCX/WebForms control"
  - "PostgreSQL via EF6 for state, ingestion, and webhooks"
  - "Confluence Cloud REST API v2 with webhook-driven re-indexing"
  - "Server-Sent Events for streaming chat responses"
  - "Azure Bicep with Deployment Stacks"
---

Built a complete Confluence Q&A RAG platform end-to-end as a POC for a
freelance engagement. Differentiator: a .NET 4.8 ASCX WebForms control
demonstrating how AI capabilities drop into legacy intranet pages without
a rewrite. Webhooks keep the Azure AI Search index in sync with Confluence
edits, and a separate item-prioritization endpoint applies weighted-criteria
scoring with per-criterion confidence and explanations.
