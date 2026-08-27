---
name: zotero
description: Search a local Zotero library and discover academic papers. Use when the user asks to find, look up, or manage Zotero items, PDFs, attachments, notes, tags, collections, or DOIs; extract PDF full text; or find papers that cite, are cited by, or relate to a given paper using Semantic Scholar.
---

# Pyzotero (Zotero + Semantic Scholar)

The `pyzotero` CLI reads a local Zotero library and queries Semantic Scholar for academic papers.

---

## Setup

Zotero must run with the local API enabled:

- Zotero > Settings > Advanced > "Allow other applications on this computer to communicate with Zotero"
- The CLI connects to `http://localhost:23119/api`

Check the connection first:

```bash
pyzotero test
```

If you see `Local API is not enabled` (403), enable the setting above. Semantic Scholar commands still work offline from Zotero with `--no-check-library`.

---

## Local Library Commands

### Search

```bash
pyzotero search -q "machine learning"                                # titles + metadata, top-level items
pyzotero search -q "climate change" --fulltext                       # includes PDF content, returns parents
pyzotero search -q "methodology" --itemtype book --itemtype journalArticle  # OR item types
pyzotero search --collection ABC123 -q "test"                        # only this collection
pyzotero search -q "topic" --tag "climate" --tag "adaptation"        # AND tags
pyzotero search -q "topic" --limit 20 --offset 20                    # paginate
pyzotero search -q "climate" --json                                  # machine-readable
```

JSON output: `{"count": N, "items": [{"key", "itemType", "title", "creators", "date", "publication", "volume", "issue", "doi", "url", "pdfAttachments"}]}`

### Items by key

```bash
pyzotero item ABC123               # single item; add --json for the full record
pyzotero item ABC123 --json
pyzotero subset ABC123 DEF456 GHI789   # batch lookup, max 50 keys per call
pyzotero children ABC123           # attachments and notes of an item
pyzotero fulltext ABC123           # extracted PDF text; key must be an ATTACHMENT key
```

`children` is the fast way to find PDF attachments for an item. `fulltext` returns `{"content", "indexedPages", "totalPages"}`.

### Library overview

```bash
pyzotero listcollections            # collections as JSON: id, name, items, parent
pyzotero listcollections --limit 10
pyzotero tags                       # all tags
pyzotero tags --collection ABC123   # tags used in one collection
pyzotero itemtypes                  # valid item types
```

### DOI lookup

```bash
pyzotero alldoi 10.1234/example                    # is this DOI in the library?
pyzotero alldoi 10.1234/abc https://doi.org/10.5678/def doi:10.9012/ghi --json
pyzotero doiindex                                  # full DOI-to-key map, cacheable
```

`alldoi` matches case-insensitively and strips `https://doi.org/`, `http://doi.org/`, `doi:`. `doiindex` prints the whole mapping — cache it to avoid rescanning:

```bash
pyzotero doiindex > doi_cache.json
```

---

## Semantic Scholar Commands

All commands print JSON to stdout; progress messages go to stderr. `--check-library` (default) annotates each paper with `inLibrary` using the local DOI index.

### Search

```bash
pyzotero s2search -q "climate adaptation"             # default limit 20, max 100
pyzotero s2search -q "machine learning" --year 2020-2024
pyzotero s2search -q "neural networks" --open-access --limit 50
pyzotero s2search -q "deep learning" --sort citations --min-citations 100
pyzotero s2search -q "X" --no-check-library           # works with Zotero offline
```

### Citation graph

```bash
pyzotero citations --doi "10.1038/nature12373"   # papers citing it (limit max 1000)
pyzotero references --doi "10.1038/nature12373"  # papers it cites (limit max 1000)
pyzotero related --doi "10.1038/nature12373"     # SPECTER2 similar papers (limit max 500)
```

Paper fields: `paperId`, `doi`, `title`, `authors`, `year`, `venue`, `citationCount`, `referenceCount`, `isOpenAccess`, `openAccessPdfUrl`, plus `inLibrary` when checking.

---

## Gotchas

- Exit code 1 + error message on stderr for failures; parse stdout JSON only.
- `subset` errors when given more than 50 keys.
- `fulltext` needs an attachment key, not a top-level item key.
- `s2search`/`citations`/`references`/`related` can hit the Semantic Scholar rate limit — on "Rate limit exceeded", wait and retry.
- `--locale` (global option, default `en-US`) controls localized strings.
