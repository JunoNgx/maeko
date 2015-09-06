package entity;

import luxe.Vector;
import luxe.Color;
import luxe.Sprite;

import luxe.tween.Actuate;

import C;

class Explosion extends Sprite {

	public var scale_randomized: Float;
	public var time_out: Float;

	override public function new(_spawnPos: Vector, _isSmall: Bool) {
		super({
			name: 'explosion',
			name_unique: true,
			rotation_z: 45,
			color: Main.c2.clone(),
			scale: new Vector(0.1, 0.1),
			pos: _spawnPos,
			depth: 4,
		});

		if (_isSmall) {
			this.size = new Vector(64, 64);
		} else {
			this.size = new Vector(96, 96);
		}

		scale_randomized = Luxe.utils.random.float(C.explosion_scale_min, C.explosion_scale_max);
		time_out = Luxe.utils.random.float(C.explosion_time_min, C.explosion_time_max);

		scaleIn();
	}

	public function scaleIn() {
		Actuate.tween(this.scale, 0.1, {x: 1, y: 1}).onComplete(scaleOut);
	}

	public function scaleOut() {
		Actuate.tween(this.scale, time_out, {x: 0.1, y: 0.1}).onComplete(destroy);
	}
}