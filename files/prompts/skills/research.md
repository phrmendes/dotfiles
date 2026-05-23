---
name: research
description: Academic research workflows using Zotero library and PDF parsing. Load when working with papers, literature reviews, citations, or document analysis.
---

## Tools available

- **Zotero MCP** (`http://localhost:23119/llm-for-zotero/mcp`) — search library, read papers, write notes, apply tags, import references
- **docling MCP** — parse PDFs to structured Markdown, extract tables and figures

## Workflow

### Chatting with a paper

1. Use Zotero MCP `read_paper` to get the full text
2. If the paper has complex tables/equations, use docling MCP to parse the PDF first
3. Answer grounded in retrieved content, cite section/page

### Literature review

1. Use `query_library` to find relevant papers by topic, author, or tag
2. Use `search_paper` for targeted evidence retrieval across multiple papers
3. Synthesize thematically, not paper-by-paper
4. Save the review with `edit_current_note` or file-based notes

### Parsing a PDF

1. Prefer Zotero's built-in text for standard single-column papers
2. Use docling MCP for: multi-column layouts, tables, equations, scanned PDFs
3. Do not re-parse the same PDF — Zotero caches parsed content

## Notes

- Always cite sources with paper title and section
- Prefer `search_paper` over `read_paper` for targeted questions (faster, cheaper)
- Write notes in Markdown with Pandoc citation syntax `[@citekey]`
- For bulk library operations (tagging, metadata, organizing) prefer agentic workflows over manual steps
