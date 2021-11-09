module main

import vplot
import os
import math

fn sig() ([]f64, []f64) {
	mut x := []f64{}
	mut s := []f64{}

	for i in 1 .. 1000 {
		x << f64(i)
		s << f64(math.log(i))
	}
	return x, s
}

fn main() {
	// x, y := sig()

	mut p1 := vplot.PlotSession{
		title: 'Test Plot Session'
		style: vplot.style_impulses
		label_x: 'x = index i'
		label_y: 'y=log(x)'
		x: [f64(0), 1.0, 2.0, 3.0]
		y: [f64(1), 1.0, 0.0, 1.0]
	}

	vplot.plot(p1) or {
		println('ERROR: ${err.msg}')
	}
	os.input('Press any key to continue...')
}
