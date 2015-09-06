package component.maeko;

import luxe.Component;
import luxe.options.ComponentOptions;

import luxe.Color;
import luxe.Vector;
import luxe.Particles;

import C;

class Harvester extends Component {

	public var harvest_particles: ParticleSystem;

	public var harvest_contact: Bool = false;
	public var harvest_cooldown: Float = C.harvest_cooldown;

	override public function new(_options: ComponentOptions) {
		super(_options);

		harvest_particles = new ParticleSystem({
			name: 'maeko particles'
		});
		harvest_particles.add_emitter({
			name: 'main emitter',

			depth: 2,
			rotation: 45,
			direction: 90,
			life: 0.7,
			emit_time: 0.2,
			emit_count: 2,
			pos_random: new Vector(24, 24),

			start_size: new Vector(12, 12),
			start_size_random: new Vector(1, 1),
			start_color: Main.c2.clone(),
			speed: 2,
			speed_random: 1,

			end_size: new Vector(1, 1),
			end_color: new Color(1, 1, 1, 0),
			end_speed: 0,
		});
		harvest_particles.stop();
	}

	override public function update(dt: Float) {

		var host: entity.Maeko = cast entity;

		if (host.ammo < host.ammo_max) {
			harvest_contact = (host.get('hitbox').collide('esth') != null) ? true : false;

			// reset the cooldown
			if (harvest_cooldown < 0) {
				harvest_cooldown = C.harvest_cooldown;
				host.ammo += 1;

				Luxe.audio.play('trek_pickup');
			}

			// emit particles and countdown while in contact
			if (harvest_contact) {
				harvest_cooldown -= dt;
				if (!harvest_particles.enabled) harvest_particles.start(-1);
			} else {
				harvest_particles.stop();
			}

			harvest_particles.pos = host.pos;
		} else harvest_particles.stop();
		
	}

}