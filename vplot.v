// Copyright(C) 2021 Erdet Nasufi. All rights reserved.

module vplot

#flag -I .
#flag -I /usr/include
#flag -I @VMODROOT/gnuplot_i
#flag @VMODROOT/gnuplot_i/gnuplot_i.o

#include "gnuplot_i.h"

pub const (
	style_lines          = 'lines'
	style_points         = 'points'
	style_linespoints    = 'linespoints'
	style_impulses       = 'impulses'
	style_dots           = 'dots'
	style_steps          = 'steps'
	style_errorbars      = 'errorbars'
	style_boxes          = 'boxes'
	style_boxeserrorbars = 'boxeserrorbars'
)

struct C.gnuplot_ctrl{}
pub struct Plot {
	ptr &C.gnuplot_ctrl
mut:
	multiplot bool
}

fn C.gnuplot_init() &C.gnuplot_ctrl
pub fn new() Plot {
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

pub fn (this Plot)commands(commands []string) {
	for command in commands {
		this.command(command)
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
pub fn (this Plot)label_x(label string) {
	unsafe {
		cstr := &char(label.str)
		C.gnuplot_set_xlabel(this.ptr, cstr)
	}
}

fn C.gnuplot_set_ylabel(&C.gnuplot_ctrl, &char)
pub fn (this Plot)label_y(label string) {
	unsafe {
		cstr := &char(label.str)
		C.gnuplot_set_ylabel(this.ptr, cstr)
	}
}

fn C.gnuplot_resetplot(&C.gnuplot_ctrl)
pub fn (this Plot)reset() {
	C.gnuplot_resetplot(this.ptr)
}

fn C.gnuplot_plot_x(&C.gnuplot_ctrl, &f64, int, &char, bool)
pub fn (this Plot)plot(d []f64, title string)? {
	if d.len == 0 {
		return error('Input array is empty.')
	}
	unsafe {
		d_ptr := &d[0]
		n := int(d.len)
		ctitle := &char(title.str)
		C.gnuplot_plot_x(this.ptr, d_ptr, n, ctitle, this.multiplot)
	}
}

fn C.gnuplot_plot_xy(&C.gnuplot_ctrl, &f64, &f64, int, &char, bool)
pub fn (this Plot)plot2(x []f64, y []f64, title string)? {
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
		C.gnuplot_plot_xy(this.ptr, x_ptr, y_ptr, n, ctitle, this.multiplot)
	}
}

fn C.gnuplot_plot_slope(&C.gnuplot_ctrl, f64, f64, &char, bool)
pub fn (this Plot)plot_slope(a f64, b f64, title string) {
	unsafe {
		ctitle := &char(title.str)
		C.gnuplot_plot_slope(this.ptr, a, b, ctitle, this.multiplot)
	}
}

fn C.gnuplot_plot_equation(&C.gnuplot_ctrl, &char, &char, bool)
pub fn (this Plot)plot_equation(equation string, title string) {
	unsafe {
		cequation := &char(equation.str)
		ctitle := &char(title.str)
		C.gnuplot_plot_equation(this.ptr, cequation, ctitle, this.multiplot)
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
pub fn plotter(session PlotSession)? {
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
		x_ptr  := &f64(&session.x[0])
		y_ptr  := &f64(&session.y[0])
		n      := int(session.x.len)
		C.gnuplot_plot_once(ctitle, cstyle, clblx, clbly, x_ptr, y_ptr, n)
	}
}

pub enum Stack {
	rows_first
	columns_first
}

pub struct Multiplotter {
pub mut:
	rows u32 [required]
	cols u32 [required]
	title string [required]
	stack Stack = Stack.rows_first
	scale_x u32 = 1
	scale_y u32 = 1
}

pub fn (mut this Plot)enable_multiplot(mp Multiplotter) {
	mut cmd := ''

	this.multiplot = true

	stack_str := if mp.stack == Stack.rows_first {'rowsfirst'} else {'columnsfirst'}

	cmd += 'set size 1,1 \n'
	cmd += 'set origin 0, 0\n'
	cmd += 'set multiplot '
	cmd += 'layout ${mp.rows}, ${mp.cols} '
	cmd += '${stack_str} downwards '
	cmd += 'title \"${mp.title}\" '
	cmd += 'scale ${mp.scale_x}, ${mp.scale_y}'
	
	this.command(cmd)
}

pub fn (mut this Plot)disable_multiplot() {
	this.multiplot = false
	this.command('unset multiplot')
}