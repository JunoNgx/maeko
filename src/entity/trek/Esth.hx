package entity.trek;

import luxe.Sprite;
import luxe.Vector;
import luxe.Color;

import luxe.collision.Collision;
import luxe.tween.Actuate;

import C;

class Esth extends Sprite {

	// The sarced source of energy, hanging onto Krist

	public var hitbox: component.Hitbox;

	public var inContact: Bool = false;

	public var radius: Float = 128; // default when not set
	public var col: Color = Main.c3.clone().toColorHSL();

	override public function new(_radius: Float) {
		super({
			name: 'esth',
			name_unique: true,
			visible: false,
		});

		this.radius = _radius;
		hitbox = new component.Hitbox({
			name: 'hitbox',
			body: luxe.collision.shapes.Polygon.create(pos.x, pos.y, 4, this.radius),
		});
		this.add(hitbox);

		this.inContact = false;
	}

	override public function update(dt: Float) {

		var t_color: Color;

		inContact = (hitbox.collide('maeko') != null) ? true : false;

		if (inContact) {
			Actuate.tween(this.col, 0.1, {l:1}).repeat(-1).reflect();
		} else {
			Actuate.tween(this.col, 0.1, {l: Main.c3.clone().toColorHSL().l});
		}

		Luxe.draw.ngon({
			x: this.pos.x,
			y: this.pos.y,
			sides: 4,
			r: radius,
			color: col,
			angle: - this.rotation_z,
			immediate: true,
			depth: -1,
		});
	}

	// function onrender(_) {
	// 	Luxe.draw.ngon({
	// 		x: this.pos.x,
	// 		y: this.pos.y,
	// 		solid: false,
	// 		sides: 4,
	// 		r: radius,
	// 		color: col,
	// 		angle: - this.rotation_z,
	// 		immediate: true,
	// 		depth: -1,
	// 	});
	// }

	// override function init() {
	// 	Luxe.on(Luxe.Ev.render, onrender);
	// }

	// override function destroy(?_from_parent:Bool=false) {
	// 	super.destroy(_from_parent);
	// 	Luxe.off(Luxe.Ev.render, onrender);
	// }
}