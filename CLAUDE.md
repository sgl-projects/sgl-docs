# sgl-docs — SGL Language Documentation Site

## Project Overview

This repository contains the official documentation website for **SGL (Structured Graphics Language)** — a declarative SQL-like language for generating data visualizations directly from database connections. SGL has (or will have) implementations in multiple languages/platforms. This site documents the **language itself**, independent of any specific implementation.

The site is built with **MkDocs Material** and deployed to **GitHub Pages**.

### Why this repo exists

SGL implementations (rsgl for R, future Python package, etc.) each live in their own repos. Rather than duplicating language-level documentation in every implementation repo, this site serves as the single source of truth for the SGL language specification, syntax reference, and feature guides. Implementation repos link here for language docs and maintain only implementation-specific documentation (installation, API, etc.) themselves.

---

## Source Material

You have three authoritative sources to draw from. **Read all three before writing any documentation.**

### 1. sglref — Reference Implementation (PRIMARY source of truth)

Location: `../sglref/`

This is the canonical implementation of SGL. It defines correct behavior for all SGL features. When in doubt about any aspect of SGL syntax or semantics, sglref is authoritative.

**Key files to read:**

| File | What it tells you |
|------|-------------------|
| `src/parser.y` | **The grammar** — Bison grammar defining all valid SGL syntax |
| `src/scanner.l` | **Tokenization rules** — keywords, identifiers, string literals, FROM context |
| `R/types.R` | Type system — how column types (numerical, categorical, temporal) affect behavior |
| `R/DuckggGeom.R` | Base geom behavior + default aesthetic mapping |
| `R/DuckggBar.R` | Bar-specific behavior (color→fill, stacking) |
| `R/DuckggLine.R` | Line-specific behavior (group aesthetic) |
| `R/DuckggBox.R` | Box plot behavior |
| `R/DuckggPoint.R` | Point-specific behavior (size aesthetic) |
| `R/DuckggBin.R`, `DuckggBin_utils.R` | Binning algorithm (linear and log-spaced) |
| `R/DuckggCount.R` | Count aggregation |
| `R/DuckggIdentity.R` | Identity (no transformation) |
| `R/semantic_validation.R` | All validation rules — what's allowed and what's an error |
| `R/valid_*.R` | Individual validation modules (groupings, collections, scales, facets, etc.) |
| `R/perform_ctas.R` | CTA processing pipeline |
| `R/rgs_to_ggplot2.R` | How SGL maps to ggplot2 (useful for explaining what plots look like) |
| `R/titles.R` | Default and explicit title generation |
| `R/constants.R` | Valid aesthetic names, geom names, etc. |
| `tests/testthat/test-RcppExports.R` | Parser test suite (~600 lines) — shows all valid/invalid syntax |
| `tests/testthat/test-dbGetPlot.R` | End-to-end examples — real SGL statements and what they produce |
| `tests/testthat/test-valid_*.R` | Validation error test cases — shows all error conditions |

### 2. rsgl — R Implementation (content starting point)

Location: `../rsgl/`

The rsgl package has a vignette that covers most SGL features with examples. Use this as a **content starting point**, but remember:

- The vignette is R-specific (uses `dbGetPlot()` function calls). The sgl-docs site should present SGL statements as language-level examples, not tied to any implementation.
- The vignette may not cover every feature. Cross-reference with sglref for completeness.

**Key files:**

| File | What it tells you |
|------|-------------------|
| `vignettes/introduction.Rmd` | Feature walkthrough with examples — adapt this content |
| `R/parser.R` | Pure R parser — another way to understand the grammar |
| `tests/testthat/test-parser.R` | Parser tests — all valid/invalid syntax patterns |
| `tests/testthat/test-dbGetPlot.R` | Integration tests with example SGL statements |
| `README.Rmd` / `README.md` | Package overview — some content may be reusable |

### 3. Academic Paper

ArXiv: https://arxiv.org/pdf/2505.14690

The original paper describing the SGL language design. Read this for:
- Motivation and design philosophy
- Formal language description
- Comparison with other visualization grammars
- The theoretical foundation (Grammar of Graphics connection)

---

## Site Structure

Build the following pages using MkDocs Material. Each page should be a separate Markdown file in the `docs/` directory.

### Navigation structure

```yaml
nav:
  - Home: index.md
  - Getting Started: getting-started.md
  - Language Reference: reference.md
  - Features:
    - Aesthetic Mappings: features/aesthetics.md
    - Geom Types: features/geoms.md
    - Column Transformations: features/transformations.md
    - Grouping & Aggregation: features/grouping.md
    - Collections: features/collections.md
    - Layering: features/layering.md
    - Scales: features/scales.md
    - Faceting: features/faceting.md
    - Titles: features/titles.md
    - Polar Coordinates: features/polar.md
    - Subqueries: features/subqueries.md
  - Examples Gallery: examples.md
  - Implementations: implementations.md
```

### Page content guidelines

#### Home (`index.md`)

- Brief (2-3 paragraphs) introduction: what is SGL, why it exists
- A "taste" example: show one simple SGL statement and the plot it produces
- Link to Getting Started for full walkthrough
- Link to the arXiv paper for academic context
- Do NOT duplicate content from other pages — keep it concise

#### Getting Started (`getting-started.md`)

- Explain the basic structure of an SGL statement: `visualize ... from ... using ...`
- Walk through aesthetic mappings (x, y, color, size)
- Explain data sources (table names and subqueries)
- Explain geom types (points, bars, lines, boxes)
- Use 4-5 progressive examples, building from simple to moderately complex
- Each example should have the SGL statement as a code block AND a rendered plot image

#### Language Reference (`reference.md`)

This is the **complete, precise specification**. Read `src/parser.y` in sglref thoroughly.

Document:
- **Complete grammar** — present a readable EBNF or railroad-diagram style grammar
- **Keywords** — all reserved words (case-sensitive, lowercase): `visualize`, `as`, `from`, `using`, `group`, `by`, `collect`, `facet`, `scale`, `title`, `layer`, `log`, `bin`, `count`, `horizontally`, `vertically`, `jittered`, `regression`, `unstacked`
- **Aesthetic names**: `x`, `y`, `color`, `size`, `theta`, `r`
- **Geom names**: `points`, `point`, `bars`, `bar`, `line`, `lines`, `boxes`, `box`
- **Representation modifiers**: `jittered` (points only), `regression` (line only), `unstacked` (bars only)
- **CTA functions**: `bin(column)`, `count(*)`
- **Scale types**: `log`
- **Facet directions**: `horizontally`, `vertically`, `default` (neither specified)
- **String literals**: single-quoted, with `\'` escape (used in title clause only)
- **Identifiers**: unquoted strings that are not keywords — used for column names, table names
- **Statement structure**: the full clause ordering rules

Be precise. This page should be sufficient for someone to implement an SGL parser from scratch.

#### Feature Pages (`features/*.md`)

Each feature page should include:
- **What it does** — 1-2 sentence explanation
- **Syntax** — the exact syntax for that feature, extracted from the grammar
- **Examples** — 2-4 SGL examples with rendered plot images
- **Behavior details** — any subtle rules (read sglref's validation and processing code)
- **Error conditions** — what happens when the feature is misused (read `test-valid_*.R`)

**Specific notes per feature page:**

**Aesthetic Mappings** (`features/aesthetics.md`):
- Cover all 6 aesthetics: x, y, color, size, theta, r
- Explain type constraints (e.g., size must be numerical, theta/r are positional)
- Explain one-dimensional plots (only x or only y mapped)
- Show how polar aesthetics (theta, r) differ from Cartesian (x, y)

**Geom Types** (`features/geoms.md`):
- Points: default and jittered
- Bars: default (stacked), unstacked
- Lines: default and regression
- Boxes: box plot behavior
- Explain which modifiers work with which geoms
- Note: both singular and plural forms are accepted (point/points, bar/bars, etc.)

**Column Transformations** (`features/transformations.md`):
- `bin(column)`: bins a numerical column into 5 equal-width buckets
- `count(*)`: counts rows per group
- Explain how bin + count creates histograms
- Explain log-spaced binning when combined with log scales
- Note: bin and count are Column Transformations and Aggregations (CTAs)

**Grouping & Aggregation** (`features/grouping.md`):
- `group by` clause syntax
- Rule: every non-aggregated aesthetic must appear in group by
- How grouping interacts with count(*)
- How grouping interacts with bin()

**Collections** (`features/collections.md`):
- `collect by` clause syntax
- Difference from `group by`: visual grouping, not SQL aggregation
- Primary use case: multi-line charts
- How collections create the `group` aesthetic in line charts

**Layering** (`features/layering.md`):
- Multi-layer syntax: `visualize ... layer visualize ...`
- Shorthand syntax: `using (geom1 layer geom2)`
- How shorthand expands (shared data source and mappings, different geoms)
- Common pattern: scatterplot + regression line

**Scales** (`features/scales.md`):
- `scale by log(x)`, `scale by log(y)`, or both
- Only `log` scale type is supported
- Only positional aesthetics (x, y) can be scaled
- How log scales affect binning (log-spaced bins)

**Faceting** (`features/faceting.md`):
- `facet by column` — single facet (wrapping)
- `facet by col1 horizontally, col2 vertically` — 2D grid
- Direction keywords: `horizontally`, `vertically`
- Facet columns must be categorical

**Titles** (`features/titles.md`):
- `title x as 'Label'` syntax
- Can set titles for: x, y, color, size, theta, r
- Single-quoted strings with `\'` escape
- Default titles (column names) when no explicit title

**Polar Coordinates** (`features/polar.md`):
- Using `theta` and `r` instead of `x` and `y`
- Pie charts: `count(*) as theta, col as color ... using bars`
- Cannot mix Cartesian and polar aesthetics

**Subqueries** (`features/subqueries.md`):
- `from (SELECT ...)` syntax
- Subqueries can contain nested parentheses
- Common use: type casting, filtering, derived columns
- The SQL dialect depends on the database being used

#### Examples Gallery (`examples.md`)

A collection of 15-20 complete examples organized by category:
- Basic plots (scatterplot, bar chart, line chart, box plot)
- Aggregation (count bar chart, histogram, grouped histogram)
- Multi-series (collection lines, stacked bars, unstacked bars)
- Advanced (layered plots, faceted plots, polar/pie charts, log scales, custom titles)
- Subqueries (type casting, filtering, derived columns)

Each example: SGL statement code block + rendered plot image + 1-sentence description.

#### Implementations (`implementations.md`)

- **rsgl** (R): Link to https://github.com/jochapjo/rsgl — available now
- **Future implementations**: Mention that Python and other implementations are planned
- Brief note on what "implementation" means: same language, different host environments

---

## Rendered Plot Images

### Generating images

Create a script at `scripts/render_examples.R` that:

1. Loads rsgl and duckdb
2. Creates test tables (cars from mtcars, economics from ggplot2::economics, diamonds from ggplot2::diamonds with factors→character, synth with letter/number/boolean columns)
3. For each example SGL statement, calls `rsgl::dbGetPlot()` and saves the result as a PNG to `docs/assets/images/`
4. Uses consistent image dimensions (e.g., 800x500 pixels, 150 DPI)
5. Uses a consistent ggplot2 theme for all images

### Image naming convention

Use descriptive kebab-case names:
- `basic-scatterplot.png`
- `bar-chart-color.png`
- `histogram.png`
- `scatterplot-regression-layer.png`
- `pie-chart.png`
- `faceted-scatterplot.png`
- etc.

### Including images in docs

Use standard Markdown image syntax with alt text:

```markdown
![Scatterplot of hp vs mpg](assets/images/basic-scatterplot.png)
```

Or use MkDocs Material's image features for better sizing/alignment if needed.

---

## Technology & Configuration

### MkDocs Material

The `mkdocs.yml` is already set up with the Material theme. Key configuration:

- **Theme**: Material with a blue color scheme
- **Navigation**: Defined in `mkdocs.yml` (see nav structure above)
- **Code highlighting**: Enabled for SQL syntax highlighting on SGL code blocks
- **Search**: Built-in MkDocs search

When writing documentation, use these MkDocs Material features:
- **Admonitions** (`!!! note`, `!!! warning`, `!!! tip`) for callouts
- **Code blocks** with `sql` language tag for SGL examples (closest syntax highlighting match)
- **Tabs** for showing the same concept in different contexts if needed

### Deployment

GitHub Actions workflow at `.github/workflows/deploy.yml` handles deployment:
- Triggers on push to `main`
- Installs Python + mkdocs-material
- Builds the site
- Deploys to GitHub Pages

No manual deployment needed — just push to main.

---

## Writing Guidelines

### Tone

- Clear, concise, technical but approachable
- Write for developers who know SQL and want to create visualizations
- Don't assume knowledge of R, Python, or any specific implementation
- Present SGL as a language, not as a feature of any particular package

### SGL code examples

- Use `sql` code fence language for syntax highlighting (SGL is SQL-like enough)
- Show the complete SGL statement, not fragments
- Use consistent formatting: lowercase keywords, reasonable line breaks for long statements
- Always pair code examples with rendered plot images where possible

### Cross-referencing

- Link between pages liberally (e.g., from "Grouping" to "Transformations" when discussing bin + count)
- Use relative links within the docs: `[Aesthetic Mappings](features/aesthetics.md)`

### What NOT to include

- Implementation-specific API calls (no `dbGetPlot()`, no Python function calls)
- Installation instructions for any specific package (that belongs in implementation repos)
- Database-specific SQL syntax (keep subquery examples generic)
- Performance considerations (implementation-specific)

---

## Verification Checklist

Before considering the site complete, verify:

- [ ] All pages listed in the nav exist and have content
- [ ] Every SGL feature from sglref is documented
- [ ] The grammar in the Language Reference matches `src/parser.y` exactly
- [ ] All example SGL statements are syntactically valid (test against rsgl or sglref)
- [ ] Plot images exist for all examples that reference them
- [ ] `mkdocs build` succeeds without errors
- [ ] No broken internal links
- [ ] No implementation-specific language (R function calls, Python imports, etc.) in language docs
- [ ] The site reads coherently as a standalone language specification + guide
