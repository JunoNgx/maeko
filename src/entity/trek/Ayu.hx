package entity.trek;

import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

import phoenix.geometry.Geometry;
import phoenix.geometry.Vertex;
import phoenix.Batcher.PrimitiveType;

import luxe.collision.Collision;
import luxe.tween.Actuate;

import C;

class Ayu extends Sprite {

	public var barrel: Float = 48; // offset when bullet is spawned from entity

	public var velocity: component.Velocity;
	public var hitbox: component.Hitbox;
	public var type: Int;

	public var hp: Int = 1;

	override public function new(_type: Int, _pos_x: Float, _pos_y: Float, _dir: Float){
		super({
			name: 'ayu',
			name_unique: true,
			pos: new Vector(_pos_x, _pos_y),
			size: new Vector(64, 32),
			color: Main.c1.clone(),
		});

		velocity = new component.Velocity({name: 'velocity'});
		this.add(velocity);

		hitbox = new component.Hitbox({
			name: 'hitbox',
			body: luxe.collision.shapes.Polygon.rectangle(pos.x, pos.y, 64, 32, true)
		});
		this.add(hitbox);

		this.add(new component.bounds.Kill({
			name: 'killbounds',
			top: -150,
			bottom: Main.h + 70,
			left: -150,
			right: Main.w + 150
		}));

		this.radians = _dir;
		this.velocity.x = C.ayu_speed * Math.cos(_dir);
		this.velocity.y = C.ayu_speed * Math.sin(_dir);

		type = _type;

		switch(type) { // I formerly used a more complicated polygon graphic
			case 1:
				this.add( new component.cannon.Frontal());
				this.hp = 1;

				// this.geometry = new Geometry({
				// 	batcher: Luxe.renderer.batcher,
				// });
				// this.geometry.primitive_type = PrimitiveType.triangle_fan;
				// this.geometry.add(new Vertex(new Vector(32, -28), this.color));
				// this.geometry.add(new Vertex(new Vector(32, 28), this.color));
				// this.geometry.add(new Vertex(new Vector(-32, 16), this.color));
				// this.geometry.add(new Vertex(new Vector(-32, -16), this.color));

			case 2:
				this.add( new component.cannon.Lateral());
				this.hp = 2;

				// this.geometry = new Geometry({
				// 	batcher: Luxe.renderer.batcher,
				// });
				// this.geometry.primitive_type = PrimitiveType.triangle_fan;
				// this.geometry.add(new Vertex(new Vector(32, 0), this.color));
				// this.geometry.add(new Vertex(new Vector(-16, 20), this.color));
				// this.geometry.add(new Vertex(new Vector(-32, 0), this.color));
				// this.geometry.add(new Vertex(new Vector(-16, -20), this.color));
			case 3:
				this.add( new component.cannon.Diag());
				this.hp = 3;

				// this.geometry = new Geometry({
				// 	batcher: Luxe.renderer.batcher,
				// });
				// this.geometry.primitive_type = PrimitiveType.triangle_fan;
				// this.geometry.add(new Vertex(new Vector(32, 0), this.color));
				// this.geometry.add(new Vertex(new Vector(-32, 28), this.color));
				// this.geometry.add(new Vertex(new Vector(-16, 0), this.color));
				// this.geometry.add(new Vertex(new Vector(-32, -28), this.color));
		}

		// states.Play.pAyu.push(this);
	}

	override public function update(dt: Float) {
		switch(type) { // I formerly used a more complicated polygon graphic
			case 1:
				drawSquare(
					this.pos.x + 32 * Math.cos(this.radians),
					this.pos.y + 32 * Math.sin(this.radians)
				);
			case 2:
				drawSquare(
					this.pos.x + 12 * Math.cos(this.radians + Math.PI/2),
					this.pos.y + 12 * Math.sin(this.radians + Math.PI/2)
				);

				drawSquare(
					this.pos.x + 12 * Math.cos(this.radians - Math.PI/2),
					this.pos.y + 12 * Math.sin(this.radians - Math.PI/2)
				);
			case 3:
				drawSquare(
					this.pos.x + 32 * Math.cos(this.radians + Math.PI/6),
					this.pos.y + 32 * Math.sin(this.radians + Math.PI/6)
				);

				drawSquare(
					this.pos.x + 32 * Math.cos(this.radians - Math.PI/6),
					this.pos.y + 32 * Math.sin(this.radians - Math.PI/6)
				);
		}

		// debug
		// Main.sDrawer.drawPolygon(this.hitbox.body);
	}

	function drawSquare(_x, _y) {
		Luxe.draw.ngon({
			x: _x,
			y: _y,
			sides: 4,
			r: 14,
			solid: true,
			immediate: true,
			color: Main.c5.clone(),
			angle: -this.rotation_z,
			depth: 1,
		});
	}

	public function hit(_dmg: Int) {
		this.hp -= _dmg;
		playHitSfx();
		
		if (this.hp == 0) {

			Luxe.events.fire('effect.explosion', {pos: this.pos});
			Luxe.camera.shake(20); // only shake when destroyed from being hit
			playDestroySfx();

			this.destroy();

			if (Luxe.utils.random.bool(0.25)) {
				var hessel = new entity.trek.Hessel(this.pos);
			}

		}

		Actuate.tween(this.color, 0.1, {r: 1, g: 1, b: 1}).repeat(1).reflect(true);
		Actuate.tween(this, 0.1, {radians: this.radians + Luxe.utils.random.float(-Math.PI/4, Math.PI/4)}).repeat(1).reflect(true);
	}

	function playHitSfx() {
		var roll: Int = Luxe.utils.random.int(1, 4);

		switch(roll) {
			case 1:
				Luxe.audio.play('trek_ayu_hit1');
			case 2:
				Luxe.audio.play('trek_ayu_hit2');
			case 3:
				Luxe.audio.play('trek_ayu_hit3');
		}
	}

	function playDestroySfx() {
		Luxe.audio.play('trek_ayu_destroy');
	}
}