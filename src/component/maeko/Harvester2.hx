package component.maeko;

import luxe.Component;
import luxe.options.ComponentOptions;

import luxe.Vector;
import luxe.Color;

import luxe.tween.Actuate;

import C;

class Harvester2 extends Component {

	public var inContact: Bool = false;
	public var progress: Float = 0;

	public var radius: Float = 0.1;

	override public function new() {
		super({
			name: 'harvester'
		});
	}

	override public function update(dt: Float) {
		var host: entity.Maeko = cast entity;

		inContact = (host.get('hitbox').collide('nexus') != null) ? true : false;

		if (inContact && host.ammo < host.ammo_max) {
			if (progress < 1) progress += dt/C.harvester_time;

			Luxe.draw.ring({
				immediate: true,
				x: host.pos.x,
				y: host.pos.y,
				r: this.radius,
				color: Main.c2.clone(),
				depth: 1,
			});
		} else {
			if (progress > 0) progress = 0;
		}

		if (progress > 1) {
			progress = 0;

			Actuate.tween(this, 0.1, {radius: C.harvester_harvest_radius}).repeat(1).reflect(true).onComplete(function(){

				Luxe.audio.play('harvest_pickup');

				host.ammo +=1;
				this.radius = 1;
			});
		}
	}

}