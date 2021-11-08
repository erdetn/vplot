
module main

// import time
import vplot
import os

const sleep_length = 2
const npoints      = 50

fn wait() {
	// time.sleep(sleep_length)
	rc := os.input('Press [ENTER] to continue...')
	println('${rc} is pressed.')
}

fn main() {
	mut h1 := vplot.new_plot()
	mut h2 := vplot.new_plot()
	mut h3 := vplot.new_plot()
	mut h4 := vplot.new_plot()

	mut x := []f64{len: npoints, cap: npoints}
	mut y := []f64{len: npoints, cap: npoints}

	println('*** example of gnuplot control through C ***\n')
    
	h1.style('lines')

	println('*** plotting slopes\n')
	println('y = x\n')
	h1.plot_slope(1.0, 0.0, 'unit slope')
	wait()

	println('y = 2*x\n')
	h1.plot_slope(2.0, 0.0, 'y=2x')
	wait()

	println('y = -x\n')
	h1.plot_slope(-1.0, 0.0, 'y=-x')
	wait()
	
	h1.reset()

    	println('\n\n')
    	println('*** various equations\n')
	println('y = sin(x)\n')
	h1.plot_equation('sin(x)', 'sine')
	wait()

	println('y = log(x)\n')
	h1.plot_equation('log(x)', 'logarithm')
	wait()

	println('y = sin(x)*cos(2*x)\n')
	h1.plot_equation('sin(x)*cos(2*x)', 'sine product')
	wait()

	h1.reset()
	println('\n\n')
	println('*** showing styles\n')

	println('sine in points\n')
	h1.style('points')
	h1.plot_equation('sin(x)', 'sine')
	wait()

	println('sine in impulses\n')
	h1.style('impulses')
	h1.plot_equation('sin(x)', 'sine')
	wait()

	println('sine in steps\n')
	h1.style('steps')
	h1.plot_equation('sin(x)', 'sine')
	wait()

	h1.reset()
	h1.style('impulses')
	println('\n\n')
	println('*** user-defined lists of doubles\n')
	for i in 1 .. npoints {
		x << f64(i*i)
	}
	h1.plot_y(x, 'user-defined doubles') or {
		println(err.msg)
	}
	wait()

	println('*** user-defined lists of points\n')
	for j in 1 .. npoints {
		x[j] = f64(j)
		y[j] = f64(j*j)
	}
	h1.reset()
	h1.style('points')
	h1.plot_xy(x, y, 'user-defined points') or {
		println(err.msg)
	}
	wait()

	println('\n\n')
	println('*** multiple output windows\n')
	h1.reset()
	h1.style('lines')
	
	h2.style('lines')
	
	h3.style('lines')
	
	h4.style('lines')

	println('window 1: sin(x)\n')
	h1.plot_equation('sin(x)', 'sin(x)')
	wait()
	println('window 2: x*sin(x)\n')
	h2.plot_equation('x*sin(x)', 'x*sin(x)')
	wait()
	println('window 3: log(x)/x\n')
	h3.plot_equation('log(x)/x', 'log(x)/x')
	wait()
	println('window 4: sin(x)/x\n')
	h4.plot_equation('sin(x)/x', 'sin(x)/x')
	wait()

	println('\n\n')
	println('*** end of gnuplot example\n')
	h1.close()
	h2.close()
	h3.close()
	h4.close()
}
