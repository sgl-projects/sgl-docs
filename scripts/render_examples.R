#!/usr/bin/env Rscript

# Render all SGL example images for the documentation site.
# Usage: Rscript scripts/render_examples.R
#
# Prerequisites: rsgl, duckdb, ggplot2 must be installed.

library(rsgl)
library(duckdb)
library(ggplot2)

# --- Configuration ---
output_dir <- "docs/assets/images"
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

img_width <- 800
img_height <- 500
img_dpi <- 150

# --- Database Setup ---
con <- DBI::dbConnect(duckdb())

# cars table from mtcars
DBI::dbWriteTable(con, "cars", mtcars)

# economics table (convert tibble to data.frame for duckdb compatibility)
DBI::dbWriteTable(con, "economics", as.data.frame(ggplot2::economics))

# diamonds table (factors converted to character)
DBI::dbWriteTable(con, "diamonds", transform(
  ggplot2::diamonds,
  cut = as.character(cut),
  color = as.character(color),
  clarity = as.character(clarity)
))

# synth table for multi-series examples
synth <- data.frame(
  letter = rep(c("a", "b", "c"), 2),
  number = c(1, 2, 3, 4, 5, 6),
  boolean = c(TRUE, TRUE, TRUE, FALSE, FALSE, FALSE)
)
DBI::dbWriteTable(con, "synth", synth)

# --- Consistent Theme ---
theme_sgl <- theme_minimal(base_size = 13) +
  theme(
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA)
  )
theme_set(theme_sgl)

# --- Helper: render and save ---
render_example <- function(sgl_stmt, filename) {
  filepath <- file.path(output_dir, filename)
  cat(sprintf("Rendering %s ...\n", filename))
  tryCatch(
    {
      p <- rsgl::dbGetPlot(con, sgl_stmt)
      ggsave(
        filepath,
        plot = p,
        width = img_width / img_dpi,
        height = img_height / img_dpi,
        dpi = img_dpi
      )
    },
    error = function(e) {
      cat(sprintf("  ERROR rendering %s: %s\n", filename, e$message))
    }
  )
}

# --- Render All Examples ---

# Basic plots
render_example(
  "visualize hp as x, mpg as y from cars using points",
  "basic-scatterplot.png"
)

render_example(
  "visualize hp as x, mpg as y, cyl as color from cars using points",
  "scatterplot-color.png"
)

render_example(
  "visualize hp as x, mpg as y, wt as size from cars using points",
  "scatterplot-size.png"
)

render_example(
  "visualize mpg as x from cars using points",
  "one-dim-scatter.png"
)

render_example(
  "visualize cyl as x from cars using jittered points",
  "jittered-points.png"
)

render_example(
  "visualize cut as x, price as y from diamonds using bars",
  "basic-bar-chart.png"
)

render_example(
  "visualize date as x, pop as y from economics using line",
  "basic-line-chart.png"
)

render_example(
  "visualize cut as x, price as y from diamonds using boxes",
  "basic-boxplot.png"
)

# Aggregation
render_example(
  "visualize cut as x, count(*) as y from diamonds group by cut using bars",
  "count-bar-chart.png"
)

render_example(
  "visualize bin(mpg) as x, count(*) as y from cars group by bin(mpg) using bars",
  "histogram.png"
)

render_example(
  paste(
    "visualize bin(mpg) as x, count(*) as y, cyl_cat as color",
    "from (select *, cast(cyl as varchar) as cyl_cat from cars)",
    "group by bin(mpg), cyl_cat",
    "using bars"
  ),
  "grouped-histogram.png"
)

render_example(
  paste(
    "visualize bin(price) as x, count(*) as y from diamonds",
    "group by bin(price)",
    "using bars",
    "scale by log(x)"
  ),
  "log-histogram.png"
)

# Multi-series
render_example(
  "visualize cut as x, price as y, color as color from diamonds using bars",
  "bar-chart-color.png"
)

render_example(
  "visualize cut as x, price as y, color as color from diamonds using unstacked bars",
  "unstacked-bars.png"
)

render_example(
  "visualize letter as x, number as y from synth collect by boolean using lines",
  "multi-line.png"
)

# Layering
render_example(
  paste(
    "visualize hp as x, mpg as y from cars using points",
    "layer",
    "visualize hp as x, mpg as y from cars using regression line"
  ),
  "scatterplot-regression-layer.png"
)

render_example(
  "visualize hp as x, mpg as y from cars using (points layer regression line)",
  "scatterplot-regression-shorthand.png"
)

# Scales
render_example(
  "visualize hp as x, mpg as y from cars using points scale by log(x), log(y)",
  "log-scale-scatter.png"
)

# Faceting
render_example(
  paste(
    "visualize hp as x, mpg as y",
    "from (select *, cast(cyl as varchar) as cyl_cat from cars)",
    "using points",
    "facet by cyl_cat"
  ),
  "faceted-scatterplot.png"
)

render_example(
  paste(
    "visualize hp as x, mpg as y",
    "from (select *, cast(cyl as varchar) as cyl_cat,",
    "                cast(am as varchar) as am_cat from cars)",
    "using points",
    "facet by cyl_cat horizontally, am_cat vertically"
  ),
  "faceted-2d-scatterplot.png"
)

# Titles
render_example(
  paste(
    "visualize hp as x, mpg as y, cyl as color from cars using points",
    "title x as 'Horsepower', y as 'Miles Per Gallon', color as 'Cylinders'"
  ),
  "titled-scatterplot.png"
)

# Polar
render_example(
  "visualize count(*) as theta, cut as color from diamonds group by cut using bars",
  "pie-chart.png"
)

# Subqueries
render_example(
  paste(
    "visualize hp as x, mpg as y",
    "from (select * from cars where mpg > 20)",
    "using points"
  ),
  "subquery-scatter.png"
)

# --- Cleanup ---
DBI::dbDisconnect(con)
cat("\nDone! All images saved to", output_dir, "\n")
