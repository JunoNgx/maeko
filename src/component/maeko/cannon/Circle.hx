package component.maeko.cannon;

import luxe.Component;
import luxe.options.ComponentOptions;

import luxe.Input;
import luxe.Color;
import luxe.Vector;

import C;

class Circle extends component.maeko.cannon.CannonBase {

	public var barrel_cooldown: Float; // cooldown from last shot so ammo can be regenerated
	public var aregen_cooldown: Float; // ammo regen cooldown

	override public function fire() {
		var host: entity.Maeko = cast entity;
		if (host.ammo > 0) {

			Luxe.audio.play('end_shot');

			var spawnVector = new Vector(
				host.pos.x + host.barrel * Math.cos(host.radians),
				host.pos.y + host.barrel * Math.sin(host.radians)
			);
			var shot = new entity.end.Shot(spawnVector, C.shot_speed, host.radians);
			host.ammo -= 1;

			Luxe.events.fire('effect.flash', {
				pos: spawnVector,
				dir: 180 + host.rotation_z, // bug?
			});

			barrel_cool();
		}

	}

	public function barrel_cool() {
		barrel_cooldown = C.reload_cooldown_first;
	}

	override public function update(dt: Float) {
		var host: entity.Maeko = cast entity;

		if (host.ammo < host.ammo_max) {
			if (barrel_cooldown > 0) {
				barrel_cooldown -= dt;
			} else {
				if (aregen_cooldown > 0) {
					aregen_cooldown -= dt;
				} else {
					aregen_cooldown = C.reload_cooldown_sub;
					host.ammo += 1;
					// Luxe.audio.play('end_pickup');
				}
		
			}
		}
	}
}