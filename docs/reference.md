# Language Reference

This page is the complete specification of SGL (Structured Graphics Language). It is sufficient for implementing an SGL parser and validator from scratch.

---

## Statement Structure

An SGL program is a **layer list** optionally followed by **graphic clauses**. The graphic clauses (`scale`, `facet`, `title`) apply globally across all layers.

```
statement        = layer_list { graphic_clause }
graphic_clause   = scale_clause | facet_clause | title_clause
```

### Layer List

A layer list is one or more layer expressions separated by the `layer` keyword:

```
layer_list       = layer_expression { "layer" layer_expression }
```

### Layer Expression

Each layer expression is a full `visualize ... from ... using ...` block:

```
layer_expression = "visualize" aes_mappings from_clause
                   [ grouping_clause ] [ collection_clause ]
                   using_clause
```

The clause order within a layer is fixed:

1. `visualize` — aesthetic mappings (required)
2. `from` — data source (required)
3. `group by` — grouping expressions (optional)
4. `collect by` — collection expressions (optional)
5. `using` — geom specification (required)

### Aesthetic Mappings

```
aes_mappings     = aes_mapping { "," aes_mapping }
aes_mapping      = col_expr "as" aesthetic_name
```

### Column Expressions

A column expression is either a bare column name or a CTA function applied to a column:

```
col_expr         = identifier
                 | cta_name "(" identifier ")"
```

### From Clause

The data source is either a table name or a parenthesized SQL subquery:

```
from_clause      = "from" table_name
                 | "from" "(" sql_subquery ")"
```

When a `(` follows `from`, the scanner collects everything up to the matching `)` as a subquery string. Nested parentheses are tracked and balanced.

### Grouping Clause

```
grouping_clause  = "group" "by" grouping_list
grouping_list    = col_expr { "," col_expr }
```

### Collection Clause

```
collection_clause = "collect" "by" collection_list
collection_list   = col_expr { "," col_expr }
```

### Using Clause

The `using` clause specifies one or more geom expressions:

```
using_clause     = "using" geom_expr
                 | "using" "(" layered_geom_list ")"

layered_geom_list = geom_expr { "layer" geom_expr }

geom_expr        = geom_name
                 | repr_modifier geom_name
```

The parenthesized form `using (geom1 layer geom2)` is a shorthand that expands into multiple layers sharing the same aesthetic mappings, data source, grouping, and collection clauses.

### Scale Clause

```
scale_clause     = "scale" "by" scale_list
scale_list       = scale_expr { "," scale_expr }
scale_expr       = scale_type "(" aesthetic_name ")"
```

### Facet Clause

```
facet_clause     = "facet" "by" facet_list
facet_list       = facet_expr { "," facet_expr }
facet_expr       = identifier [ direction ]
direction        = "horizontally" | "vertically"
```

### Title Clause

```
title_clause     = "title" title_list
title_list       = title_expr { "," title_expr }
title_expr       = aesthetic_name "as" single_quoted_string
```

---

## Complete Grammar (EBNF)

```
statement           ::= layer_list { graphic_clause }

graphic_clause      ::= scale_clause
                      | facet_clause
                      | title_clause

layer_list          ::= layer_expression { "layer" layer_expression }

layer_expression    ::= "visualize" aes_mappings from_clause
                        [ grouping_clause ] [ collection_clause ]
                        using_clause

aes_mappings        ::= aes_mapping { "," aes_mapping }

aes_mapping         ::= col_expr "as" AESTHETIC_NAME

col_expr            ::= IDENTIFIER
                      | IDENTIFIER "(" IDENTIFIER ")"

from_clause         ::= "from" TABLE_NAME
                      | "from" "(" SQL_SUBQUERY ")"

grouping_clause     ::= "group" "by" grouping_list

grouping_list       ::= col_expr { "," col_expr }

collection_clause   ::= "collect" "by" collection_list

collection_list     ::= col_expr { "," col_expr }

using_clause        ::= "using" geom_expr
                      | "using" "(" layered_geom_list ")"

layered_geom_list   ::= geom_expr { "layer" geom_expr }

geom_expr           ::= GEOM_NAME
                      | REPR_MODIFIER GEOM_NAME

scale_clause        ::= "scale" "by" scale_list

scale_list          ::= scale_expr { "," scale_expr }

scale_expr          ::= SCALE_TYPE "(" AESTHETIC_NAME ")"

facet_clause        ::= "facet" "by" facet_list

facet_list          ::= facet_expr { "," facet_expr }

facet_expr          ::= IDENTIFIER [ direction ]

direction           ::= "horizontally"
                      | "vertically"

title_clause        ::= "title" title_list

title_list          ::= title_expr { "," title_expr }

title_expr          ::= AESTHETIC_NAME "as" SINGLE_QUOTED_STRING
```

---

## Terminals

### Keywords

All keywords are **case-sensitive** and **lowercase**:

| Keyword | Usage |
|---------|-------|
| `visualize` | Begins a layer expression |
| `as` | Separates a column expression from its aesthetic or a title label |
| `from` | Introduces the data source |
| `using` | Introduces the geom specification |
| `group` | Part of `group by` clause |
| `collect` | Part of `collect by` clause |
| `by` | Used with `group`, `collect`, `scale`, and `facet` |
| `layer` | Separates multiple layer expressions or geom expressions |
| `scale` | Part of `scale by` clause |
| `facet` | Part of `facet by` clause |
| `horizontally` | Facet direction modifier |
| `vertically` | Facet direction modifier |
| `title` | Begins the title clause |

### Aesthetic Names

| Name | Type | Description |
|------|------|-------------|
| `x` | Cartesian positional | Horizontal axis |
| `y` | Cartesian positional | Vertical axis |
| `theta` | Polar positional | Angle |
| `r` | Polar positional | Radius |
| `color` | Non-positional | Color encoding |
| `size` | Non-positional | Size encoding (points only) |

### Geom Names

Both singular and plural forms are accepted:

| Singular | Plural | Description |
|----------|--------|-------------|
| `point` | `points` | Scatterplot points |
| `bar` | `bars` | Bar chart |
| `line` | `lines` | Line chart |
| `box` | `boxes` | Box plot |

### Representation Modifiers

| Modifier | Valid Geoms | Description |
|----------|-------------|-------------|
| `jittered` | `point` / `points` | Adds random jitter to reduce overplotting |
| `regression` | `line` / `lines` | Draws a regression line (OLS) instead of connecting points |
| `unstacked` | `bar` / `bars` | Places grouped bars side-by-side instead of stacking |

### CTA Functions (Column Transformations and Aggregations)

| CTA | Syntax | Type | Description |
|-----|--------|------|-------------|
| `bin` | `bin(column)` | Transformation | Bins a numerical column into 5 equal-width buckets |
| `count` | `count(*)` | Aggregation | Counts rows per group |

- `bin` cannot be applied to categorical columns.
- `count` can only be applied to `*` (the wildcard), not to specific column names.

### Scale Types

| Scale | Description |
|-------|-------------|
| `log` | Logarithmic (base 10) scale |

Only positional aesthetics (`x`, `y`, `theta`, `r`) can be scaled.

### Identifiers

Identifiers are unquoted strings matching `[^ '\t\n,()]+` that are not keywords. They are used for:

- Column names (e.g., `mpg`, `hp`, `cyl`)
- Table names (in the `from` clause)
- Aesthetic names, geom names, CTA names, and scale types are also parsed as identifiers and then validated

### String Literals

Single-quoted strings are used only in the `title` clause:

- Delimited by single quotes: `'My Title'`
- Escape a literal single quote with backslash: `\'`
- Example: `title x as 'Engine\'s Horsepower'`

### Subqueries

When `from` is followed by `(`, everything up to the matching `)` is captured as a SQL subquery string. Nested parentheses are balanced and included in the subquery text.

---

## Semantic Rules

### Coordinate System Constraint

Every layer must have at least one positional aesthetic. A layer cannot mix Cartesian (`x`, `y`) and polar (`theta`, `r`) aesthetics.

### Grouping Rules

1. If any aesthetic mapping uses an aggregation (`count(*)`), then a `group by` clause is required unless the aggregation is the only mapping.
2. Every non-aggregated aesthetic mapping must appear in the `group by` clause.
3. If a `group by` clause is provided, at least one aggregation must be present in the `visualize` clause.
4. Grouping expressions cannot contain aggregations (e.g., `group by count(*)` is invalid).

### Collection Rules

- `collect by` is only valid for **collective geoms**: `line`/`lines` and `box`/`boxes`.
- For non-collective geoms (`point`/`points`, `bar`/`bars`), specifying `collect by` is an error.
- Without a `group by`, collection expressions must be plain column names (no CTAs).
- With a `group by`, collections must have corresponding groupings, and non-positional groupings must be included in the `collect by` clause.

### Layering Rules

- If a positional aesthetic appears in one layer, it must appear in all layers.
- The same aesthetic must be mapped to the same type (numerical, categorical, or temporal) across all layers.
- Date and datetime temporal types cannot be mixed across layers for the same aesthetic.

### Scale Rules

- Only `log` is supported as a scale type.
- Scales can only be applied to aesthetics that exist in at least one layer.
- Scaled aesthetics must have numerical mappings.

### Facet Rules

- Maximum of 2 facet expressions.
- For 2 facets, one must specify `horizontally` and the other `vertically`.
- Facet columns must exist in at least one layer's data source.
- Facet columns must be categorical type.

### Title Rules

- Titles can only be set for aesthetics that appear in at least one layer's aesthetic mappings.

### Geom-Specific Rules

**Points:**

- Support all aesthetics including `size`.
- Valid modifiers: `jittered` (or default).

**Bars:**

- `size` aesthetic is not valid.
- With one positional aesthetic: it must be numerical or temporal (unbinned).
- With two positional aesthetics: one must be categorical/binned, the other numerical/temporal (unbinned).
- Valid modifiers: `unstacked` (or default).
- `color` controls the bar interior color, not the outline.

**Lines:**

- `size` aesthetic is not valid.
- Collective geom — supports `collect by`.
- Valid modifiers: `regression` (or default).
- `regression` requires: all mappings must be identity (no CTAs), and color (if present) must not be numerical or temporal.

**Boxes:**

- `size` aesthetic is not valid.
- Collective geom — supports `collect by`.
- With one positional aesthetic: it must be numerical or temporal (unbinned).
- With two positional aesthetics: one must be categorical/binned, the other numerical/temporal (unbinned).
- `color` must be categorical or binned.
- No representation modifiers are allowed.

### Column Type System

SGL classifies database column types into three categories:

| Category | Examples |
|----------|---------|
| **Numerical** | INTEGER, BIGINT, FLOAT, DOUBLE, DECIMAL, SMALLINT, TINYINT, and their aliases |
| **Categorical** | VARCHAR (CHAR, TEXT, STRING), BOOLEAN (BOOL, LOGICAL) |
| **Temporal** | DATE, TIMESTAMP (DATETIME), TIME, INTERVAL, TIMESTAMPTZ |

These categories determine which aesthetics a column can be mapped to and how it interacts with geom-specific constraints.

### Binning Behavior

- `bin(column)` creates 5 equal-width buckets across the column's range.
- When combined with a `log` scale on the same axis, bins are computed in log-space (log-spaced bins).
- The binned result is treated as a categorical/binned type for validation purposes.

### Default Titles

When no explicit `title` clause is provided, default labels are derived from the column expression:

- Plain column: the column name (e.g., `mpg`)
- `count(*)`: `"Count"`
- `bin(column)`: `"Binned column"` (e.g., `"Binned mpg"`)
