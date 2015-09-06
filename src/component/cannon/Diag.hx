package component.cannon;

import luxe.Component;
import luxe.options.ComponentOptions;

import luxe.Color;
import luxe.Vector;

import component.cannon.CannonBase;

class Diag extends CannonBase {

	public static var rof: Float = 1.7;
	public var cooldown: Float = 1;

	override public function new() {
		super({
			name: 'ayuCannon.diag'
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

		var radians1 = host.radians - Math.PI/4;
		var bullet1 = new entity.trek.Bullet(
			new Vector (host.pos.x + host.barrel * Math.cos(radians1), host.pos.y + host.barrel * Math.sin(radians1)),
			C.bullet_trek_speed,
			radians1
		);

		var radians2 = host.radians + Math.PI/4;
		var bullet2 = new entity.trek.Bullet(
			new Vector (host.pos.x + host.barrel * Math.cos(radians2), host.pos.y + host.barrel * Math.sin(radians2)),
			C.bullet_trek_speed,
			radians2
		);
	}
}