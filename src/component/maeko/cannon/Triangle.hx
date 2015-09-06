package component.maeko.cannon;

import luxe.Component;
import luxe.options.ComponentOptions;

import luxe.Input;
import luxe.Color;
import luxe.Vector;

import C;

class Triangle extends component.maeko.cannon.CannonBase {

	override public function fire() {
		var host: entity.Maeko = cast entity;
		if (host.ammo > 0) {
			
			Luxe.audio.play('harvest_shoot');

			// Left Shot
			var spawnVectorLt = new Vector(
				host.pos.x + host.barrel * Math.cos(host.radians - Math.PI/10),
				host.pos.y + host.barrel * Math.sin(host.radians - Math.PI/10)
			);
			var shot = new entity.harvest.Shot(spawnVectorLt, C.shot_speed, host.radians);
			Luxe.events.fire('effect.flash', {
				pos: spawnVectorLt,
				dir: 180 + host.rotation_z,
			});

			// Right shot
			var spawnVectorRt = new Vector(
				host.pos.x + host.barrel * Math.cos(host.radians + Math.PI/10),
				host.pos.y + host.barrel * Math.sin(host.radians + Math.PI/10)
			);
			var shot = new entity.harvest.Shot(spawnVectorRt, C.shot_speed, host.radians);
			Luxe.events.fire('effect.flash', {
				pos: spawnVectorRt,
				dir: 180 + host.rotation_z,
			});

			// Take only one unit of ammunition
			host.ammo -= 1;
		}

	}
}