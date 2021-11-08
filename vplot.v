// Copyright(C) 2021 Erdet Nasufi. All rights reserved.

module vplot

#flag -I .
#flag -I /usr/include
#flag -I @VMODROOT/gnuplot_i
#flag @VMODROOT/gnuplot_i/gnuplot_i.o

#include "gnuplot_i.h"

pub const (
	lines          = 'lines'
	points         = 'points'
	linespoints    = 'linespoints'
	impulses       = 'impulses'
	dots           = 'dots'
	steps          = 'steps'
	errorbars      = 'errorbars'
	boxes          = 'boxes'
	boxeserrorbars = 'boxeserrorbars'
)

struct C.gnuplot_ctrl{}
pub struct Plot {
	ptr &C.gnuplot_ctrl
}

fn C.gnuplot_init() &C.gnuplot_ctrl
pub fn new_plot() Plot {
	return Plot {
		ptr: C.gnuplot_init()
	}
}

fn C.gnuplot_close(&C.gnuplot_ctrl)
pub fn (this Plot)close() {
	C.gnuplot_close(this.ptr)
}

fn C.gnuplot_cmd(&C.gnuplot_ctrl, &char)
pub fn (this Plot)command(command string) {
	unsafe {
		cstr := &char(command.str)
		C.gnuplot_cmd(this.ptr, cstr)
	}
}

fn C.gnuplot_setstyle(&C.gnuplot_ctrl, &char)
pub fn (this Plot)style(style string) {
	unsafe {
		cstr := &char(style.str)
		C.gnuplot_setstyle(this.ptr, cstr)
	}
}

fn C.gnuplot_set_xlabel(&C.gnuplot_ctrl, &char)
pub fn (this Plot)xlabel(label string) {
	unsafe {
		cstr := &char(label.str)
		C.gnuplot_set_xlabel(this.ptr, cstr)
	}
}

fn C.gnuplot_set_ylabel(&C.gnuplot_ctrl, &char)
pub fn (this Plot)ylabel(label string) {
	unsafe {
		cstr := &char(label.str)
		C.gnuplot_set_ylabel(this.ptr, cstr)
	}
}

fn C.gnuplot_resetplot(&C.gnuplot_ctrl)
pub fn (this Plot)reset() {
	C.gnuplot_resetplot(this.ptr)
}

fn C.gnuplot_plot_x(&C.gnuplot_ctrl, &f64, int, &char)
pub fn (this Plot)plot_y(d []f64, title string)? {
	if d.len == 0 {
		return error('Input array is empty.')
	}
	unsafe {
		d_ptr := &d[0]
		n := int(d.len)
		ctitle := &char(title.str)
		C.gnuplot_plot_x(this.ptr, d_ptr, n, ctitle)
	}
}

fn C.gnuplot_plot_xy(&C.gnuplot_ctrl, &f64, &f64, int, &char)
pub fn (this Plot)plot_xy(x []f64, y []f64, title string)? {
	if x.len == 0 || y.len == 0 {
		return error('Input array X and/or Y is/are empty.')
	}

	if x.len != y.len {
		return error('Length of X array (=${x.len}) is not equal with Y array (=${y.len})')
	}
	unsafe {
		n := int(x.len)
		x_ptr := &x[0]
		y_ptr := &y[0]
		ctitle := &char(title.str)
		C.gnuplot_plot_xy(this.ptr, x_ptr, y_ptr, n, ctitle)
	}
}

pub fn (this Plot)plot(x []f64, y []f64, title string)? {
	if x.len == 0 && y.len == 0 {
		return error('Both input arrays are empty.')
	}

	if x.len > 0 && y.len == 0 {
		this.plot_y(x, title)?
	}

	if x.len == 0 && y.len > 0 {
		this.plot_y(y, title)?
	}
	
	this.plot_xy(x, y, title)?
}

fn C.gnuplot_plot_slope(&C.gnuplot_ctrl, f64, f64, &char)
pub fn (this Plot)plot_slope(a f64, b f64, title string) {
	unsafe {
		ctitle := &char(title.str)
		C.gnuplot_plot_slope(this.ptr, a, b, ctitle)
	}
}

fn C.gnuplot_plot_equation(&C.gnuplot_ctrl, &char, &char)
pub fn (this Plot)plot_equation(equation string, title string) {
	unsafe {
		cequation := &char(equation.str)
		ctitle := &char(title.str)
		C.gnuplot_plot_equation(this.ptr, cequation, ctitle)
	}
}

fn C.gnuplot_write_x_csv(&char, &f64, int, &char) int
pub fn write_x_csv(filename string, d []f64, title string) ?bool {
	mut rc := 0

	if d.len == 0 {
		return error('Input array is empty.')
	}

	unsafe {
		d_ptr := &d[0]
		n := d.len
		cfn := &char(filename.str)
		ctitle := &char(title.str)
		rc = C.gnuplot_write_x_csv(cfn, d_ptr, n, ctitle)
	}
	return rc > 0
}

fn C.gnuplot_write_xy_csv(&char, &f64, &f64, int, &char) int
pub fn write_xy_csv(filename string, x []f64, y []f64, title string) ? bool {
	mut rc := 0

	if x.len == 0 || y.len == 0 {
		return error('Input array X and/or Y is/are empty.')
	}

	if x.len != y.len {
		return error('Length of X array (=${x.len}) is not equal with Y array (=${y.len})')
	}

	unsafe {
		x_ptr := &x[0]
		y_ptr := &y[0]
		n := x.len
		cfn := &char(filename.str)
		ctitle := &char(title.str)
		rc = C.gnuplot_write_xy_csv(cfn, x_ptr, y_ptr, n, ctitle)
	}
	return rc > 0
}

pub fn write_csv(filename string, x []f64, y []f64, title string) ? bool {
	if x.len == 0 && y.len == 0 {
		return error('Both input arrays are empty.')
	}

	if x.len > 0 && y.len == 0 {
		return write_x_csv(filename, x, title)
	}

	if x.len == 0 && y.len > 0 {
		return write_x_csv(filename, y, title)
	}
	
	return write_xy_csv(filename, x, y, title)
}

pub struct PlotSession {
	title   string
	style   string
	label_x string
	label_y string
	x     []f64
	y     []f64
}

fn C.gnuplot_plot_once(&char, &char, &char, &char, &f64, &f64, int)
pub fn plot(session PlotSession)? {
	if session.x.len == 0 || session.y.len == 0 {
		return error('Input array X and/or Y is/are empty.')
	}
	if session.x.len != session.y.len {
		xl := session.x.len
		yl := session.y.len
		return error('Length of X array (=${xl}) is not equal with Y array (=${yl})')
	}

	unsafe {
		ctitle := &char(session.title.str)
		cstyle := &char(session.style.str)
		clblx  := &char(session.label_x.str)
		clbly  := &char(session.label_y.str)
		x_ptr  := &f64(session.x[0])
		y_ptr  := &f64(session.y[0])
		n      := int(session.x.len)
		C.gnuplot_plot_once(ctitle, cstyle, clblx, clbly, x_ptr, y_ptr, n)
	}
}
