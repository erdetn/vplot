module main

import vplot
import os

fn main() {
	mut cmds := []string{}

	cmds << 'set title "Simple Plots" font ",20"'
	cmds << 'set key left box'
	cmds << 'set samples 50'
	cmds << 'set style data points'
	cmds << 'plot [-10:10] sin(x),atan(x),cos(atan(x))'

	mut p1 := vplot.new_plot()

	p1.commands(cmds)
	os.input('Press any keys to continue...')

	p1.close()

}