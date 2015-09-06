package entity.trek;

import luxe.Color;
import luxe.Vector;

import C;

class Bullet extends entity.base.Projectile {

	override public function initiate() {
		this.name = 'bullet.' + id;

		this.radius = C.bullet_trek_radius;

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
			r: this.radius,
			x: this.pos.x,
			y: this.pos.y,
			color: Main.c2.clone(),
			angle: -rotation2,
		});

		// debug
		// Main.sDrawer.drawPolygon(this.hitbox.body);
	}

	override public function collide() {
		var target = hitbox.collide('maeko');
		if (target != null) {
			var maeko: entity.Maeko = cast target;

			Luxe.events.fire('effect.flash', {
				pos: this.pos,
				dir: this.rotation_z,
			});

			Luxe.audio.play('maeko_hit');
			maeko.hit();
			this.destroy();
		} // against maeko

		var target = hitbox.collide('krist');
		if (target != null) {
			var krist: entity.trek.Krist = cast target;

			Luxe.events.fire('effect.flash', {
				pos: this.pos,
				dir: this.rotation_z,
			});

			krist.hit();
			this.destroy();
		} // against krist
	}
}