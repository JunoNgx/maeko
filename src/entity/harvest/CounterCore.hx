package entity.harvest;

import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

import luxe.tween.Actuate;

import C;

class CounterCore extends Sprite {

	override public function new(_position: Int) {
		super({
			name: 'counter',
			name_unique: true,
			size: new Vector (C.countercore_size, C.countercore_size),
			pos: new Vector(Main.w * _position/11, Main.h * 6/7),
			visible: false,
			scale: new Vector(0, 1),
		});

		scaleIn();
	}

	override public function update(dt: Float) {
		Luxe.draw.box({
			immediate: true,
			x: this.pos.x - C.countercore_size/2 * this.scale.x,
			y: this.pos.y - C.countercore_size/2 * this.scale.y,
			w: C.countercore_size * this.scale.x,
			h: C.countercore_size * this.scale.y,
			color: Main.c3.clone(),
		});
	}

	public function scaleIn() {
		Actuate.tween(this.scale, 0.5, {x: 1});
	}
}