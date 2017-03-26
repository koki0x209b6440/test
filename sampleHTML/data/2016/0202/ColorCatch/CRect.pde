/* Convert RGB to YUV */
int Y_yuv(color rgb) {
	int y = int(0.299*red(rgb) + 0.587*green(rgb) + 0.114*blue(rgb));
	return y;
}

int Cb_yuv(color rgb) {
	int cb = int(0.169*red(rgb) - 0.331*green(rgb) + 0.500*blue(rgb));
	return cb;
}

int Cr_yuv(color rgb) {
	int cr = int(0.500*red(rgb) - 0.419*green(rgb) - 0.081*blue(rgb));
	return cr;
}


class CRect {
	int sx, sy, ex, ey;
	int small_x, small_y, large_x, large_y;
	color rgb;
	int yuv_y, yuv_cb, yuv_cr;
	int xyz_x, xyz_y, xyz_z;

	CRect(int x, int y) {
		this.sx = x;
		this.sy = y;
		this.ex = this.sx;
		this.ey = this.sy;
	}

	void update() {
		this.select();
		this.textcolor();
	}

	void update(int x, int y) {
		this.ex = x;
		this.ey = y;

		this.config();
		this.select();
		this.ave();
		this.yuv();
		this.textcolor();
	}

	private void config() {
		/* rect(x1, y1, x2, y2)で x1>x2 もしくは y1>y2 になると落ちる対策 */
		if (this.sx > this.ex) {
			this.small_x = this.ex;
			this.large_x = this.sx;
		} else {
			this.small_x = this.sx;
			this.large_x = this.ex;
		}
		if (this.sy > this.ey) {
			this.small_y = this.ey;
			this.large_y = this.sy;
		} else {
			this.small_y = this.sy;
			this.large_y = this.ey;
		}
	}

	private void select() {
		stroke(40, 0, 80);
		fill(255, 255, 255, 40);
		rect(this.small_x, this.small_y, (this.large_x - this.small_x), (this.large_y - this.small_y));
	}

	private void ave() {
		long sum_r = 0, sum_g = 0, sum_b = 0;
		long count = 0;

		for (int i=this.small_x; i<=this.large_x; i++) {
			for (int j=this.small_y; j<=this.large_y; j++) {
				color c = get(i, j);
				sum_r += red(c);
				sum_g += green(c);
				sum_b += blue(c);
				count++;
			}
		}

		this.rgb = color( int(sum_r/count), int(sum_g/count), int(sum_b/count) );
	}

	private void yuv() {
		this.yuv_y  = Y_yuv(this.rgb);
		this.yuv_cb = Cb_yuv(this.rgb);
		this.yuv_cr = Cr_yuv(this.rgb);
	}

	private void textcolor() {
		//PFont font = loadFont("SansSerif.plain-12.vlw");
		//textFont(font, 10);
		fill(0);
		String str_rgb = "RGB: " + int(red(this.rgb)) + ", " + int(green(this.rgb)) + ", " + int(blue(this.rgb));
		String str_yuv = "YUV: " + this.yuv_y    + ", " + this.yuv_cb     + ", " + this.yuv_cr;
		text(str_rgb, this.small_x+5, this.small_y+10);
		text(str_yuv, this.small_x+5, this.small_y+25);
	}
}
