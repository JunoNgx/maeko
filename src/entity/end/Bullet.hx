package entity.end;

import luxe.Color;
import luxe.Vector;

import C;

class Bullet extends entity.base.Projectile {

	override public function initiate() {
		this.name = 'bullet.' + id;

		this.radius = C.bullet_end_radius;

		this.hitbox = new component.Hitbox({
			name: 'hitbox',
			body: luxe.collision.shapes.Polygon.create(pos.x, pos.y, 3, this.radius),
		});
		this.add(hitbox);

		Luxe.events.fire('effect.flash', {
			pos: this.pos,
			dir: 180 + this.rotation_z,
		});
	}

	override public function draw() {

		Luxe.draw.ring({
			immediate: true,
			r: this.radius,
			x: this.pos.x,
			y: this.pos.y,
			color: Main.c3.clone(),
			depth: 2,
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
			maeko.get('cannon').barrel_cool(); // hacky workaround, to reset first regeneration
			this.destroy();
		} // against maeko
	}
}