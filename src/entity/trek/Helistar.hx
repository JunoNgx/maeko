package entity.trek;

import luxe.Color;
import luxe.Vector;

import luxe.tween.Actuate;

import C;

class Helistar extends luxe.Sprite {

	public var velocity: component.Velocity;
	public var radius: Float = 16;

	public var variant_index: Float;

	override public function new() {
		super({
			name: 'helistar',
			name_unique: true,
			visible: false,
			color: Main.c5.clone(),
		});

		velocity = new component.Velocity({ name: 'velocity' });
		this.add(velocity);

		this.color.a = 0.5;

		generateFirstPosition();
		resetVariance();
	}

	function generateFirstPosition() {
		this.pos = new Vector(
			Luxe.utils.random.float(-50, Main.w),
			Luxe.utils.random.float(-50, Main.h)
		);
	}

	function resetPosition() {
		var x: Float;
		var y: Float;

		var x_is_in: Bool = Luxe.utils.random.bool(0.5);

		if (x_is_in) {
			x = Luxe.utils.random.float(0, Main.w);
			y = Luxe.utils.random.float(-50, 0);
		} else {
			x = Luxe.utils.random.float(-50, 0);
			y = Luxe.utils.random.float(0, Main.h);
		}

		this.pos = new Vector(x, y);

		// do {
		// 	x = Luxe.utils.random.float(-50, Main.w);
		// 	y = Luxe.utils.random.float(-50, Main.h);
		// 	resetVariance();
		// } while ( x > 0 || y > 0);
	}

	function resetVariance() {
		variant_index = Math.random() + 1;

		radius = 12 * variant_index;
		this.velocity.x = 80 * variant_index;
		this.velocity.y = 45 * variant_index;
	}

	override function update(dt: Float) {

		this.radius += variant_index * 2 * dt;

		if ((this.pos.x > Main.w + 50) || (this.pos.y > Main.h + 50)) {
			resetPosition();
			resetVariance();
		}

		// Luxe.draw.ngon({
		// 	immediate: true,
		// 	solid: true,
		// 	sides: 3,
		// 	r: this.radius,
		// 	x: this.pos.x,
		// 	y: this.pos.y,
		// 	color: this.color,
		// 	angle: -180,
		// 	depth: -11,
		// });
	}

	function onrender(_) {
		Luxe.draw.ngon({
			immediate: true,
			solid: true,
			sides: 3,
			r: this.radius,
			x: this.pos.x,
			y: this.pos.y,
			color: this.color,
			angle: -180,
			depth: -11,
		});
	}

	override function init() {
		Luxe.on(Luxe.Ev.render, onrender);
	}

	override function destroy(?_from_parent:Bool=false) {
		super.destroy(_from_parent);
		Luxe.off(Luxe.Ev.render, onrender);
	}
}