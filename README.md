# vplot
vplot is a wrapper for GNU Plot (gnuplot_i). The source of `gnuplot_i` I have downloaded from [this link](http://ndevilla.free.fr/gnuplot/). Files listed on gnuplot_i are taken from downloaded sources, including the license file.


## Dependecies
First, you need to install the `gnuplot`.


## Plot styles

- `vplot.style_lines`
- `vplot.style_points`
- `vplot.style_linespoints`
- `vplot.style_impulses`
- `vplot.style_dots`
- `vplot.style_steps`
- `vplot.style_errorbars`
- `vplot.style_boxes`
- `vplot.style_boxeserrorbars`

## Tested functions

- [x] `new_plot`
- [x] `Plot.close()`
- [x] `Plot.style(string)`
- [x] `Plot.plot_slope(f64, f64, string)`
- [x] `Plot.plot_equation(string, string)`
- [x] `Plot.reset()`
- [x] `Plot.plot_xy([]f64, []f64, string)`
- [x] `Plot.command(string)`
- [x] `Plot.commands([]string)` 
- [x] `Plot.plot([]f64, []f64, string)`
- [x] `Plot.plot_y([]f64, string)`
- [x] `Plot.xlabel(string)`
- [x] `Plot.ylabel(string)`
- [x] `vplot.write_x_csv(string, []f64, string)`
- [x] `vplot.write_xy_csv(string, []f64, []f64, string)`
- [x] `vplot.write_csv(string, []f64, []f64, string)`
- [x] `vplot.PlotSession{}`
- [x] `vplot.plot(PlotSession)`


