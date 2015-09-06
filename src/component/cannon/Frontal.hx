package component.cannon;

import luxe.Component;
import luxe.options.ComponentOptions;

import luxe.Color;
import luxe.Vector;

import component.cannon.CannonBase;

class Frontal extends CannonBase {

	public static var rof: Float = 1.7;
	public var cooldown: Float = 1;

	override public function new() {
		super({
			name: 'ayuCannon.frontal'
		});
	}

	override public function update(dt: Float) {
		if (cooldown > 0) {
			cooldown -= dt;
		} else {
			fire();
			cooldown = rof;
		}
	}

	override public function fire() {
		super.fire();

		var host: entity.trek.Ayu = cast entity;
		var bullet = new entity.trek.Bullet(
			new Vector (host.pos.x + host.barrel * Math.cos(host.radians), host.pos.y + host.barrel * Math.sin(host.radians)),
			C.bullet_trek_speed,
			host.radians
		);
	}
}