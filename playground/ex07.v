module main

import vplot
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
	x, y := sig()

	vplot.write_x_csv('write_x_csv.csv', y, 'Write CSV with Y only data') or {
		println('ERROR: ${err.msg}')
	}
	vplot.write_xy_csv('write_xy_csv.csv', x, y, 'Write CSV with X & Y data using write_xy function') or {
		println('ERROR: ${err.msg}')
	}

	vplot.write_csv('write_csv.csv', x, y, 'Write csv with write_csv function only') or {
		println('ERROR: ${err.msg}')
	}
}
