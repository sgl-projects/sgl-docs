# Getting Started

This guide walks you through the basics of SGL with progressive examples. By the end, you'll understand how to write SGL statements for common visualization tasks.

## Statement Structure

Every SGL statement follows the same pattern:

```
visualize <mappings> from <data source> using <geom>
```

1. **`visualize`** — Declare which columns map to which visual properties (aesthetics)
2. **`from`** — Name the data source (a table or subquery)
3. **`using`** — Specify the chart type (geom)

## Example 1: Basic Scatterplot

The simplest SGL statement maps two columns to the x and y axes:

```sql
visualize hp as x, mpg as y from cars using points
```

![Basic scatterplot of hp vs mpg](assets/images/basic-scatterplot.png)

This creates a scatterplot with `hp` (horsepower) on the horizontal axis and `mpg` (miles per gallon) on the vertical axis, using data from the `cars` table.

## Example 2: Adding Color

Add a third mapping to encode a column as color:

```sql
visualize hp as x, mpg as y, cyl as color from cars using points
```

![Scatterplot with color](assets/images/scatterplot-color.png)

The `cyl` column is mapped to the `color` aesthetic, automatically creating a legend. Whether this produces a discrete or continuous color scale depends on the column type — categorical columns produce discrete colors, numerical columns produce gradients.

## Example 3: Changing the Geom

Swap `points` for `bars` or `line` to change the chart type entirely:

```sql
visualize cut as x, price as y from diamonds using bars
```

![Bar chart](assets/images/basic-bar-chart.png)

```sql
visualize date as x, pop as y from economics using line
```

![Line chart](assets/images/basic-line-chart.png)

Different geoms have different requirements for their aesthetic mappings. For example, bar charts need one categorical/binned axis and one numerical axis, while line charts connect points in order. See [Geom Types](features/geoms.md) for details.

## Example 4: Aggregation with count

Use `count(*)` to count rows and `group by` to specify how they're grouped:

```sql
visualize cut as x, count(*) as y from diamonds group by cut using bars
```

![Count bar chart](assets/images/count-bar-chart.png)

The rule is straightforward: when you use `count(*)`, every other mapped column must appear in the `group by` clause. Here, `cut` is the only non-aggregated mapping, so it goes in `group by`.

Combine `bin()` with `count(*)` for histograms:

```sql
visualize bin(mpg) as x, count(*) as y from cars group by bin(mpg) using bars
```

![Histogram](assets/images/histogram.png)

`bin(mpg)` discretizes the continuous `mpg` column into 5 equal-width buckets before counting. See [Column Transformations](features/transformations.md) and [Grouping](features/grouping.md) for more.

## Example 5: Layering and Regression

Overlay multiple geoms on the same plot using `layer`. The shorthand syntax shares all clauses except the geom:

```sql
visualize hp as x, mpg as y from cars using (points layer regression line)
```

![Scatterplot with regression line](assets/images/scatterplot-regression-shorthand.png)

This produces a scatterplot with an overlaid regression line — a common pattern for exploring relationships between variables. See [Layering](features/layering.md) for the full syntax.

## What's Next

These five examples cover the core of SGL. There's much more to explore:

- **[Aesthetic Mappings](features/aesthetics.md)** — All 6 aesthetics including size and polar coordinates
- **[Collections](features/collections.md)** — Multi-series line charts and grouped box plots
- **[Scales](features/scales.md)** — Log scale transformations
- **[Faceting](features/faceting.md)** — Split plots into panels
- **[Titles](features/titles.md)** — Custom axis and legend labels
- **[Subqueries](features/subqueries.md)** — Preprocess data with SQL before plotting
- **[Examples Gallery](examples.md)** — A comprehensive collection of SGL visualizations
