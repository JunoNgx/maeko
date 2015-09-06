package entity.end;

import luxe.Sprite;
import luxe.Entity;

import C;

class Shot extends entity.base.Projectile {

	override public function initiate() {
		this.name = 'shot.' + id;

		this.radius = C.shot_end_radius;

		this.hitbox = new component.Hitbox({
			name: 'hitbox',
			body: luxe.collision.shapes.Polygon.create(pos.x, pos.y, 12, this.radius),
		});
		this.add(hitbox);
	}

	override public function draw() {

		Luxe.draw.ring({
			immediate: true,
			x: this.pos.x,
			y: this.pos.y,
			r: this.radius,
			color: Main.c3.clone(),
			depth: 2,
		});
	}

	override public function collide() {

		var target = hitbox.collide('helius');
		if (target != null) {
			var sol: entity.end.Helius = cast target;

			if (sol.isVulnerable) {
				Luxe.events.fire('effect.flash', {
					pos: this.pos,
					dir: this.rotation_z,
				});

				sol.hit();
			}
			
			this.destroy();
		}

	}

}