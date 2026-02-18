# Grouping & Aggregation

The `group by` clause specifies how rows are grouped for aggregation. It works in conjunction with the `count(*)` aggregation to produce summarized visualizations like count bar charts and histograms.

## Syntax

```
grouping_clause = "group" "by" grouping_list
grouping_list   = col_expr { "," col_expr }
```

The `group by` clause appears after the `from` clause and before any `collect by` or `using` clause:

```sql
visualize cut as x, count(*) as y from diamonds group by cut using bars
```

## Rules

### Aggregation Requires Grouping

When any aesthetic mapping uses an aggregation (currently only `count(*)`), every non-aggregated mapping must appear in the `group by` clause:

```sql
-- Valid: cut is non-aggregated and appears in group by
visualize cut as x, count(*) as y from diamonds group by cut using bars
```

```sql
-- Invalid: cut is non-aggregated but missing from group by
visualize cut as x, count(*) as y from diamonds using bars
```

!!! warning
    The only exception is when `count(*)` is the sole aesthetic mapping — in that case, no `group by` is needed because there are no non-aggregated columns to group.

### Grouping Requires Aggregation

If a `group by` clause is provided, at least one aggregation must be present in the `visualize` clause:

```sql
-- Invalid: group by present but no aggregation
visualize hp as x, mpg as y from cars group by hp using points
```

### No Aggregations in group by

Grouping expressions themselves cannot be aggregations:

```sql
-- Invalid: cannot group by an aggregation
visualize cut as x, count(*) as y from diamonds group by count(*) using bars
```

## Grouping with bin()

The `bin()` transformation can appear in both the aesthetic mapping and the `group by` clause. When it does, binning is applied before aggregation:

```sql
visualize bin(mpg) as x, count(*) as y from cars group by bin(mpg) using bars
```

![Histogram](../assets/images/histogram.png)

The `bin(mpg)` expression in the `group by` clause matches the `bin(mpg)` in the aesthetic mapping, satisfying the rule that all non-aggregated mappings must be grouped.

## Multiple Grouping Columns

Multiple columns can be grouped by separating them with commas:

```sql
visualize bin(mpg) as x, count(*) as y, cyl_cat as color
from (select *, cast(cyl as varchar) as cyl_cat from cars)
group by bin(mpg), cyl_cat
using bars
```

![Grouped histogram](../assets/images/grouped-histogram.png)

Here, both `bin(mpg)` (mapped to x) and `cyl_cat` (mapped to color) are non-aggregated and both appear in the `group by` clause.

## Interaction with Collections

The `group by` and [`collect by`](collections.md) clauses serve different purposes:

- **`group by`** drives SQL-level aggregation — rows are combined using `count(*)`.
- **`collect by`** drives visual grouping — rows are kept separate but drawn as distinct series.

When both are present, collection columns must have corresponding groupings. See [Collections](collections.md) for details.
