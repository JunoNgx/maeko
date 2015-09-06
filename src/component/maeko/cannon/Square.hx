package component.maeko.cannon;

import luxe.Component;
import luxe.options.ComponentOptions;

import luxe.Input;
import luxe.Color;
import luxe.Vector;

class Square extends component.maeko.cannon.CannonBase {

	override public function fire() {
		var host: entity.Maeko = cast entity;
		if (host.ammo > 0) {

			Luxe.audio.play('trek_shoot');

			var spawnVector = new Vector(
				host.pos.x + host.barrel * Math.cos(host.radians),
				host.pos.y + host.barrel * Math.sin(host.radians)
			);
			var shot = new entity.trek.Shot(spawnVector, C.shot_speed, host.radians);
			host.ammo -= 1;

			Luxe.events.fire('effect.flash', {
				pos: spawnVector,
				dir: 180 + host.rotation_z, // bug?
			});
		}

	}
}