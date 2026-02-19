# Docs Conformance Auditor Memory

## Key sglref Patterns (Confirmed 2026-02-19)
- Type classification is by R class after DuckDB query, NOT DuckDB type name directly
- INTERVAL and TIME map to R `difftime` → classified as **numerical** (not temporal)
- UUID maps to R `character` → classified as **categorical** (undocumented in docs)
- Temporal = DATE (R Date) or TIMESTAMP/TIMESTAMPTZ/DATETIME (R POSIXct) only
- Scale `log` can apply to ANY aesthetic with numerical mapping — not positional-only
- Facet: 2 "default" direction facets ARE valid; only two matching explicit directions is invalid
- `bin()` can be applied to numerical AND temporal columns; only categorical is rejected

## Most Relevant sglref Files Per Topic
- Grammar: src/parser.y, src/scanner.l, src/geom.c, src/aes.c, src/cta.c, src/qual.c, src/scale.c
- Types: R/types.R, tests/testthat/test-types.R
- Scales: R/valid_scales.R, tests/testthat/test-valid_scales.R
- Facets: R/valid_facet.R, tests/testthat/test-valid_facet.R
- Geom rules: R/sgl_geom_*.R
- Grouping: R/valid_groupings.R
- Titles: R/titles.R, R/valid_titles.R
- Binning: R/sgl_cta_bin.R, R/sgl_cta_bin_utils.R
