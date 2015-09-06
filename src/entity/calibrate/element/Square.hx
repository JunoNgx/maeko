package entity.calibrate.element;

import luxe.Color;
import luxe.Vector;

import luxe.tween.Actuate;

import C;

class Square extends luxe.Sprite {

	public var growTime: Float = C.element_grow_time; // durations of tween
	public var delayTime: Float = C.element_delay_time; // delay between phases of growing after being pressed

	public var radius: Float = 1;
	public var radius_des: Float = 72;

	override public function new() {
		super({
			name: 'element.square',
			name_unique: true,
			pos: new Vector(Main.w * 1/4, Main.h * 1/4),
			visible: false,
			color: Main.c3.clone( ),
		});

		this.add(new component.Hitbox({
			name: 'hitbox',
			body: luxe.collision.shapes.Polygon.create(pos.x, pos.y, 4, this.radius_des)
		}));

		// this.add(new component.Pressor(2, function(){}));
		this.add(new component.nexus.Pressor(C.element_pressor_time, activate_grow));

		this.radians = -Math.PI/2;

		Actuate.tween(this, growTime, {radius: this.radius_des});
	}

	override public function update(dt: Float) {

		Luxe.draw.ngon({
			immediate: true,
			solid: false,
			sides: 4,
			r: this.radius,
			x: this.pos.x,
			y: this.pos.y,
			color: this.color,
			angle: -this.rotation_z,
			depth: -1,
		});

		if (this.get('pressor').showIndicator) {
			Luxe.draw.ngon({
				immediate: true,
				solid: false,
				sides: 4,
				r: this.radius + C.element_radius_indicator_extra,
				x: this.pos.x,
				y: this.pos.y,
				color: Main.c2.clone(),
				angle: -this.rotation_z,
				depth: -1,
			});
		}

	}

	public function activate_grow() {
		Actuate.tween(this, growTime, {radius: this.radius_des * 2}).delay(delayTime).onComplete(activate_move);
	}

	public function activate_move() {
		Actuate.tween(this, growTime, {radius: 1}).delay(delayTime);
		Actuate.tween(this.pos, growTime, {x: Main.w/2, y: Main.h * 2/3}).delay(delayTime).onComplete(function(){
			this.destroy();
			Luxe.events.fire('add.element.square');
		});
	}

}