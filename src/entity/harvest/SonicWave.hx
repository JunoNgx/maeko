package entity.harvest;

import luxe.Sprite;
import luxe.Vector;
import luxe.Color;

import luxe.tween.Actuate;
import C;

class SonicWave extends Sprite {

	public var radius: Float = 0.1;

	override public function new() {
		super({
			name: 'sonicwave',
			name_unique: true,
			visible: false,
			pos: new Vector(Main.w/2, Main.h * 4/5),
			color: Main.c3.clone(),
		});

		burst();
	}

	override public function update(dt: Float) {
		Luxe.draw.ring({
			immediate: true,
			x: this.pos.x,
			y: this.pos.y,
			r: this.radius,
			color: this.color,
			depth: 5,
		});
	}

	public function burst() {
		Actuate.tween(this, 0.5, {radius: 720})
			.ease(luxe.tween.easing.Quad.easeIn)
			.onComplete(destroy);
	}

}