package entity;

import luxe.Vector;
import luxe.Color;

import phoenix.geometry.Geometry;
import phoenix.geometry.Vertex;
import phoenix.Batcher.PrimitiveType;

import luxe.Particles;
import luxe.tween.Actuate;

import luxe.collision.Collision;

import C;

typedef PosEvent = {
	x: Float,
	y: Float
}

class Maeko extends luxe.Sprite {

	public var barrel: Int = 48;

	public var velocity: component.Velocity;
	public var hitbox: component.Hitbox;

	public var ammo: Int;
	public var ammo_max: Int;

	override public function new(_maxAmmo: Int) {
		super({
			name: 'maeko',
			name_unique: true,
			pos: new Vector(Main.w/2, Main.h * 3/2),
			color: Main.c1.clone(),
			centered: false, // sigh, wasted my time. workaround for using luxe.sprite instead of luxe.visual
		});

		createGeometry();

		ammo_max = _maxAmmo;
		refillAmmo();

		velocity = new component.Velocity({
			name: 'velocity'
		});
		this.add(velocity);

		this.add(new component.maeko.AccelMove({
			name: 'accel'
		}));

		hitbox = new component.Hitbox({
			name: 'hitbox',
			body: luxe.collision.shapes.Polygon.create(pos.x, pos.y, 4, 32)
		});
		this.add(hitbox);
		this.radians = -Math.PI/2;
	}

	function createGeometry() {

		var ant_hl: Float = 22; // anterior half length
		var pos_hl: Float = 36; // anterior half length
		var hh: Float = 24; // half height

		this.geometry = new Geometry({
			batcher: Luxe.renderer.batcher,
			// origin: new Vector(-hh, -ant_hl)
		});
		this.geometry.primitive_type = PrimitiveType.triangle_fan;
		this.geometry.add(new Vertex(new Vector(hh, -ant_hl), this.color));
		this.geometry.add(new Vertex(new Vector(hh, ant_hl), this.color));
		this.geometry.add(new Vertex(new Vector(-hh, pos_hl), this.color));
		this.geometry.add(new Vertex(new Vector(-hh, -pos_hl), this.color));
	}

	// override public function update(dt: Float) {

	// 	Luxe.draw.text({
	// 		text: '${ammo}',
	// 		pos: new Vector(this.pos.x, this.pos.y - 64),
	// 		point_size: 48,
	// 		align: right,
	// 		immediate: true,
	// 	});

	// 	// Main.sDrawer.drawPolygon(this.hitbox.body);

	// 	// Luxe.draw.ngon({
	// 	// 	x: this.pos.x,
	// 	// 	y: this.pos.y,
	// 	// 	immediate: true,
	// 	// 	angle: -this.rotation_z,
	// 	// });

	// }

	public function moveToCenter() {
		Actuate.tween(this.pos, 1, {y: Main.h/2}).delay(2).onComplete(addKeepBounds);
	}

	public function addKeepBounds() {
		this.add(new component.bounds.Keep({ name: 'bounds.keep' }));
	}

	public function hit() {
		if (this.ammo > 0) {

			Luxe.camera.shake(20);
			this.ammo = 0;
			
			//TODO audio feedback

		} else {

			this.destroy();
			Luxe.events.fire('maeko is doomed');
			trace('maeko destroyed');
		}

		Luxe.events.fire('effect.explosion.large', {pos: this.pos});
		Luxe.camera.shake(100);
		
	}

	public function refillAmmo() {
		ammo = ammo_max;
	}
}