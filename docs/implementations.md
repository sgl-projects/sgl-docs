# Implementations

SGL is a **language specification** — it defines the syntax and semantics for generating data visualizations from database connections. Implementations bring SGL to life in specific programming environments, handling the connection to databases, parsing SGL statements, and rendering the resulting plots.

---

## Available Implementations

### rsgl (R)

**Repository:** [github.com/jochapjo/rsgl](https://github.com/jochapjo/rsgl)

rsgl is the first implementation of SGL, built for the R ecosystem. It connects to databases via DBI, parses SGL statements, and renders visualizations using ggplot2.

Key features:

- Works with any DBI-compatible database (DuckDB, PostgreSQL, SQLite, etc.)
- Renders plots as ggplot2 objects, so they can be further customized with ggplot2 functions
- Bundles the [sglref](https://github.com/jochapjo/sglref) reference parser for correct SGL parsing

---

## Planned Implementations

Future implementations are planned for other languages and platforms. The SGL language is designed to be portable — the same SGL statement should produce equivalent visualizations regardless of the implementation.

---

## What "Implementation" Means

All SGL implementations share the same language:

- **Same syntax** — the grammar defined in the [Language Reference](reference.md) applies to every implementation.
- **Same semantics** — the validation rules, type system, and behavioral constraints are consistent.
- **Different rendering** — each implementation maps SGL to its host platform's plotting library (e.g., ggplot2 in R, matplotlib in Python).
- **Different database connectivity** — each implementation uses its platform's database drivers.

This documentation site covers the **language itself**. For installation instructions, API documentation, and platform-specific details, see each implementation's own repository.
