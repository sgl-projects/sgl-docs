# Geom Types

The `using` clause specifies the geometric representation of the data. SGL supports four geom types, each with optional representation modifiers.

## Syntax

```
using_clause = "using" geom_expr
             | "using" "(" layered_geom_list ")"

geom_expr    = geom_name
             | repr_modifier geom_name
```

Both singular and plural forms are accepted for all geom names:

| Singular | Plural |
|----------|--------|
| `point` | `points` |
| `bar` | `bars` |
| `line` | `lines` |
| `box` | `boxes` |

---

## Points

Points render each row as an individual dot on the plot, producing scatterplots and strip plots.

```sql
visualize hp as x, mpg as y from cars using points
```

![Basic scatterplot](../assets/images/basic-scatterplot.png)

### Supported Aesthetics

Points support all six aesthetics: `x`, `y`, `theta`, `r`, `color`, and `size`.

### Jittered Points

Use the `jittered` modifier to add random displacement, reducing overplotting. Particularly useful for one-dimensional plots or when many points overlap:

```sql
visualize cyl as x from cars using jittered points
```

![Jittered points](../assets/images/jittered-points.png)

---

## Bars

Bars render data as rectangular bars, useful for categorical comparisons and distributions.

```sql
visualize cut as x, price as y from diamonds using bars
```

![Basic bar chart](../assets/images/basic-bar-chart.png)

### Aesthetic Constraints

- With **one** positional aesthetic: it must be numerical or temporal (unbinned).
- With **two** positional aesthetics: one must be categorical or binned, the other numerical or temporal (unbinned).
- The `size` aesthetic is **not valid** for bars.
- The `color` aesthetic maps to **fill** (not stroke).

### Stacked Bars (Default)

When a `color` aesthetic is present, bars are stacked by default:

```sql
visualize cut as x, price as y, color as color from diamonds using bars
```

![Stacked bar chart with color](../assets/images/bar-chart-color.png)

### Unstacked Bars

Use the `unstacked` modifier to place grouped bars side-by-side:

```sql
visualize cut as x, price as y, color as color from diamonds using unstacked bars
```

![Unstacked bar chart](../assets/images/unstacked-bars.png)

---

## Lines

Lines connect data points in order, useful for time series and trend visualization.

```sql
visualize date as x, pop as y from economics using line
```

![Basic line chart](../assets/images/basic-line-chart.png)

### Aesthetic Constraints

- The `size` aesthetic is **not valid** for lines.
- Lines are a **collective geom** — they support the [`collect by`](collections.md) clause for multi-series plots.

### Regression Lines

Use the `regression` modifier to draw a fitted regression line (OLS) instead of connecting individual points:

```sql
visualize hp as x, mpg as y from cars using regression line
```

The `regression` modifier has additional constraints:

- All aesthetic mappings must be identity (no CTAs like `bin()` or `count(*)`).
- The `color` aesthetic, if present, must not be numerical or temporal.

---

## Boxes

Box plots display the distribution of numerical data through quartiles.

```sql
visualize cut as x, price as y from diamonds using boxes
```

![Basic box plot](../assets/images/basic-boxplot.png)

### Aesthetic Constraints

- With **one** positional aesthetic: it must be numerical or temporal (unbinned).
- With **two** positional aesthetics: one must be categorical or binned, the other numerical or temporal (unbinned).
- The `color` aesthetic must be categorical or binned.
- The `size` aesthetic is **not valid** for boxes.
- Boxes are a **collective geom** — they support the [`collect by`](collections.md) clause.
- **No representation modifiers** are allowed for boxes.

---

## Modifier Summary

| Modifier | Valid Geoms | Effect |
|----------|-------------|--------|
| `jittered` | `point` / `points` | Adds random jitter to reduce overplotting |
| `regression` | `line` / `lines` | Draws OLS regression line |
| `unstacked` | `bar` / `bars` | Side-by-side grouped bars instead of stacked |

Using a modifier with an incompatible geom produces an error. For example, `jittered bars` or `unstacked line` are invalid.
