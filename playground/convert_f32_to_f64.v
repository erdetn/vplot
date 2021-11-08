module main

fn print_array(a []f64) {
	if a.len == 0 {
		println('empty array')
	}
	dump(a)
}

fn main() {
	v1 := [f32(0.1), 0.2, 0.3, 0.4]
	dump(v1)
	dump(typeof(v1[0]).name)

	v2 := v1.map(f64(it))
	dump(v2)
	dump(typeof(v2[0]).name)

	print_array([]f64{})
	print_array([f64(0.1), -0.2, 0.3])
}