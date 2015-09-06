package entity.harvest;

import luxe.Sprite;
import luxe.Entity;

import C;

// This is also a base for (hostile) bullets
class Shot extends entity.base.Projectile {

	override public function initiate() {
		this.name = 'shot.' + id;
		
		this.radius = C.shot_harvest_radius;

		this.hitbox = new component.Hitbox({
			name: 'hitbox',
			body: luxe.collision.shapes.Polygon.create(pos.x, pos.y, 3, this.radius),
		});
		this.add(hitbox);
	}

	override public function draw() {
		var rotation2 = 90 + this.rotation_z;

		this.hitbox.body.rotation = rotation2;

		Luxe.draw.ngon({
			immediate: true,
			solid: false,
			sides: 3,
			r: C.shot_harvest_radius,
			x: this.pos.x,
			y: this.pos.y,
			color: Main.c2.clone(),
			angle: -rotation2,
		});

		// debug
		// Main.sDrawer.drawPolygon(this.hitbox.body);
	}

	override public function collide() {
		var target = hitbox.collide('karl');
		if (target != null) {
			var karl: entity.harvest.Karl = cast target;

			Luxe.events.fire('effect.flash', {
				pos: this.pos,
				dir: this.rotation_z,
			});
			

			karl.hit();
			this.destroy();
		}
	}

}