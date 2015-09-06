package component.helius;

import luxe.Component;
import luxe.options.ComponentOptions;

import luxe.Vector;
import luxe.Color;

import luxe.collision.Collision;
import luxe.tween.Actuate;

import C;

// health indicator
class Lukas extends Component {

	override public function new() {
		super({
			name: 'lukas'
		});
	}

	override public function update(dt: Float) {
		var host: entity.end.Helius = cast entity;

		if (host.hp > 3) {
			Luxe.draw.circle({
				immediate: true,
				x: entity.pos.x + 32,
				y: entity.pos.y + 24,
				r: 6,
				color: Main.c5.clone(),
				depth: -1,
			});
		}

		if (host.hp > 2) {
			Luxe.draw.circle({
				immediate: true,
				x: entity.pos.x - 32,
				y: entity.pos.y + 24,
				r: 6,
				color: Main.c5.clone(),
				depth: -1,
			});
		}

		if (host.hp > 1) {
			Luxe.draw.circle({
				immediate: true,
				x: entity.pos.x + 12,
				y: entity.pos.y - 32,
				r: 6,
				color: Main.c5.clone(),
				depth: -1,
			});
		}

		if (host.hp > 0) {
			Luxe.draw.circle({
				immediate: true,
				x: entity.pos.x - 12,
				y: entity.pos.y - 32,
				r: 6,
				color: Main.c5.clone(),
				depth: -1,
			});
		}

	}

}
