module main

import os
import vplot

fn main() {
	mut p1 := vplot.new_plot()

	p1.plot_slope(2.0, 0.0, 'y=2x')
	
	ret := os.input('Press [ENTER] to continue')
	println('${ret} is pressed.')

	p1.close()
}