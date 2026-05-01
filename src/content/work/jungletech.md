---
order: 3
title: "Custom-corpus RAG for technical manuals"
tag: "Case 03 · Technical manuals RAG · POC"
summary: "RAG platform over customer-uploaded technical PDFs with image-aware retrieval, real-time ingestion progress, and a YARP BFF security pattern."
public: false
highlights:
  - "Azure OpenAI: GPT-4o + text-embedding-ada-002"
  - "PostgreSQL pgvector with HNSW vector index for cosine search"
  - "Blazor InteractiveAuto + MudBlazor UI"
  - "YARP reverse proxy implementing the BFF (Backend-for-Frontend) pattern"
  - "ASP.NET Core 10 Minimal APIs + SignalR for real-time ingest progress"
  - "Microsoft Entra External ID (CIAM) for end-user auth"
  - "PdfPig for text extraction; HybridCache for cost-aware embedding reuse"
  - "Image description-based retrieval; analytics + cost tracking dashboard"
---

A from-scratch RAG platform for searching customer-uploaded technical manuals.
Documents are extracted with PdfPig, chunked, and embedded into a PostgreSQL
pgvector index with HNSW for sub-second cosine similarity. Recent additions
include image dedup with an embedded lightbox viewer, image-description-based
retrieval (vision + RAG), and an analytics page tracking per-conversation
token costs. The BFF security pattern via YARP keeps OpenAI access tokens
server-side; SignalR pushes ingestion progress to the browser as documents
process.
