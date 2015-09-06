package entity.trek;

// import entity.base.Shot;

import luxe.Sprite;
import luxe.Entity;

import C;

class Shot extends entity.base.Projectile {

	override public function initiate() {
		this.name = 'shot.' + id;
		
		this.radius = C.shot_harvest_radius;

		this.hitbox = new component.Hitbox({
			name: 'hitbox',
			body: luxe.collision.shapes.Polygon.square(pos.x, pos.y, C.shot_trek_radius, true),
		});
		this.add(hitbox);
	}

	override public function draw() {

		Luxe.draw.ngon({
			immediate: true,
			solid: false,
			sides: 4,
			r: C.shot_trek_radius,
			x: this.pos.x,
			y: this.pos.y,
			color: this.color,
			angle: -this.rotation_z,
		});

		// debug
		// Main.sDrawer.drawPolygon(this.hitbox.body);
	}

	override public function collide() {
		var target = hitbox.collide('ayu');
		if (target != null) {
			var ayu: entity.trek.Ayu = cast target;

			Luxe.events.fire('effect.flash', {
				pos: this.pos,
				dir: this.rotation_z,
			});

			ayu.hit(1);
			this.destroy();
		} // ayu

		var target = hitbox.collide('krist');
		if (target != null) {
			var krist: entity.trek.Krist = cast target;

			Luxe.events.fire('effect.flash', {
				pos: this.pos,
				dir: this.rotation_z,
			});

			krist.hit();
			this.destroy();
		} // krist
	}

}