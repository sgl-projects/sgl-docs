# Aesthetic Mappings

Aesthetic mappings define how data columns are visually encoded in a plot. Each mapping associates a column (or column expression) with a visual property like position, color, or size.

## Syntax

```
aes_mapping  = col_expr "as" aesthetic_name
aes_mappings = aes_mapping { "," aes_mapping }
```

Aesthetic mappings appear immediately after the `visualize` keyword, separated by commas:

```sql
visualize column1 as x, column2 as y, column3 as color from ...
```

## Available Aesthetics

SGL supports six aesthetics, divided into two coordinate systems and two non-positional properties:

### Cartesian Positional Aesthetics

| Aesthetic | Description |
|-----------|-------------|
| `x` | Horizontal axis position |
| `y` | Vertical axis position |

### Polar Positional Aesthetics

| Aesthetic | Description |
|-----------|-------------|
| `theta` | Angle position (maps internally to the x axis in polar coordinates) |
| `r` | Radius position (maps internally to the y axis in polar coordinates) |

### Non-Positional Aesthetics

| Aesthetic | Description |
|-----------|-------------|
| `color` | Color encoding (stroke for points/lines, fill for bars) |
| `size` | Size encoding (points only) |

## Coordinate Systems

Every layer must include at least one positional aesthetic. Cartesian and polar aesthetics **cannot be mixed** within the same layer.

Valid combinations:

- `x` only
- `y` only
- `x` and `y`
- `theta` only
- `r` only
- `theta` and `r`

Invalid:

- `x` and `theta` (mixing coordinate systems)
- `y` and `r` (mixing coordinate systems)

## One-Dimensional Plots

You can map just one positional aesthetic. When only `x` or only `y` is provided, the other axis is left empty, producing a strip plot:

```sql
visualize mpg as x from cars using points
```

![One-dimensional scatter plot of mpg](../assets/images/one-dim-scatter.png)

## Examples

### Basic Scatterplot

Map two columns to `x` and `y`:

```sql
visualize hp as x, mpg as y from cars using points
```

![Basic scatterplot of hp vs mpg](../assets/images/basic-scatterplot.png)

### Color Encoding

Add a third column to `color`:

```sql
visualize hp as x, mpg as y, cyl as color from cars using points
```

![Scatterplot with color encoding](../assets/images/scatterplot-color.png)

### Size Encoding

Map a numerical column to `size` (points only):

```sql
visualize hp as x, mpg as y, wt as size from cars using points
```

![Scatterplot with size encoding](../assets/images/scatterplot-size.png)

!!! note
    The `size` aesthetic is only valid for the point geom. Bars, lines, and boxes do not support size mapping.

### Polar Aesthetics

Use `theta` and `r` for polar coordinate plots. See [Polar Coordinates](polar.md) for details.

## Type Constraints

The column type (numerical, categorical, or temporal) affects how an aesthetic behaves. Some geoms impose constraints on which types can be mapped to which aesthetics:

- **Bars and boxes**: With two positional aesthetics, one must be categorical/binned and the other numerical/temporal.
- **Boxes**: The `color` aesthetic must be categorical or binned.
- **Size**: Must be mapped to a numerical column.

See [Geom Types](geoms.md) for the full constraints per geom.

## Default Titles

Each aesthetic gets a default axis or legend label derived from the column expression:

- Plain column name → the column name itself (e.g., `mpg`)
- `count(*)` → `"Count"`
- `bin(column)` → `"Binned column"`

Override defaults with the [title clause](titles.md).
