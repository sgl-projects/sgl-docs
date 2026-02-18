# SGL — Structured Graphics Language

SGL is a graphics language with syntax aesthetically similar to SQL. Built on a customized [grammar of graphics](https://arxiv.org/pdf/2505.14690), it is concise yet expressive. SGL is designed to facilitate the specification of graphics in environments that support SQL queries.

This site documents the SGL language itself, independent of any specific implementation. For implementation-specific details, see [Implementations](implementations.md).

## A Taste of SGL

```sql
visualize
  hp as x,
  mpg as y,
  cyl as color
from cars
using points
```

![Scatterplot of hp vs mpg colored by cyl](assets/images/scatterplot-color.png)

This single statement produces a scatterplot with horsepower on the x-axis, miles per gallon on the y-axis, and points colored by cylinder count — all from the `cars` table.

## Where to Go Next

- **[Getting Started](getting-started.md)** — Learn the basics with progressive examples
- **[Language Reference](reference.md)** — Complete grammar and semantic specification
- **[Features](features/aesthetics.md)** — Detailed documentation for each SGL feature
- **[Examples Gallery](examples.md)** — A collection of SGL visualizations by category
- **[Implementations](implementations.md)** — Available SGL implementations
