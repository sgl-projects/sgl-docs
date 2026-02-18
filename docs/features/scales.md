# Scales

The `scale` clause transforms the axis scale for positional aesthetics. Currently, SGL supports logarithmic (base 10) scaling.

## Syntax

```
scale_clause = "scale" "by" scale_list
scale_list   = scale_expr { "," scale_expr }
scale_expr   = scale_type "(" aesthetic_name ")"
```

The `scale` clause appears after the last `using` clause (it is a graphic clause that applies globally):

```sql
visualize hp as x, mpg as y from cars using points scale by log(x)
```

## Log Scale

The only supported scale type is `log`, which applies a base-10 logarithmic transformation to the specified axis.

### Single Axis

Apply a log scale to one axis:

```sql
visualize hp as x, mpg as y from cars using points scale by log(x)
```

![Log scale on x-axis](../assets/images/log-scale-scatter.png)

### Both Axes

Apply log scales to both axes by separating with a comma:

```sql
visualize hp as x, mpg as y from cars using points scale by log(x), log(y)
```

## Rules

### Positional Aesthetics Only

Scales can only be applied to positional aesthetics (`x`, `y`, `theta`, `r`). Attempting to scale a non-positional aesthetic like `color` or `size` is an error.

### Numerical Mappings Only

The scaled aesthetic must have a numerical mapping in every layer where it appears. Categorical or temporal mappings cannot be log-scaled.

### Aesthetic Must Exist

The scale can only reference aesthetics that appear in at least one layer's aesthetic mappings:

```sql
-- Invalid: no 'y' aesthetic to scale
visualize hp as x from cars using points scale by log(y)
```

## Interaction with Binning

When `bin()` is used on an axis that also has a log scale, the binning algorithm automatically switches to **log-spaced bins**. Instead of dividing the range into equal-width intervals in linear space, it divides the range into equal-width intervals in log-space:

```sql
visualize bin(price) as x, count(*) as y from diamonds
group by bin(price)
using bars
scale by log(x)
```

![Log-spaced histogram](../assets/images/log-histogram.png)

This ensures the bins appear evenly spaced on the log-scaled axis.
