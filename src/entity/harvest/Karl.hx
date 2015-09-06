package entity.harvest;

import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

import luxe.tween.Actuate;

import C;

class Karl extends Sprite {

	public var move_freq: Float;
	public var move_dist: Float = 150;

	public var hitbox: component.Hitbox;

	public var hp: Int = 1;
	public var move_cooldown: Float = 0;
	public var isMoving: Bool = false;

	override public function new(_pos: Vector, _freq: Float) {
		super({
			name: 'karl',
			name_unique: true,
			color: Main.c1.clone(),
			visible: false,
			pos: _pos,
		});

		move_freq = _freq;

		hitbox = new component.Hitbox({
			name: 'hitbox',
			body: luxe.collision.shapes.Polygon.create(pos.x, pos.y, 3, C.karl_radius),
		});
		this.add(hitbox);

		this.add(new component.bounds.Kill({
			name: 'bounds.kill',
			top: -Main.h,
		}));

		this.radians = Math.atan2( 
			Main.h * 4/5 - this.pos.y,
			Main.w * 1/2 - this.pos.x
		);
	}

	override public function update(dt: Float) {

		var rotation2 = 90 + this.rotation_z;

		this.hitbox.body.rotation = rotation2;

		Luxe.draw.ngon({
			immediate: true,
			solid: true,
			sides: 3,
			r: C.karl_radius,
			x: this.pos.x,
			y: this.pos.y,
			color: this.color,
			angle: -rotation2,
		});

		if (move_cooldown < 0) {
			isMoving = true;
			crawl();
			move_cooldown = move_freq;
		} else {
			if (!isMoving) move_cooldown -= dt;
		}

		if (hp <= 0) this.destroy();

		// debug
		// Main.sDrawer.drawPolygon(this.get('hitbox').body);
	}

	public function crawl() {
		Actuate.tween(this.pos, 1, {
			x: this.pos.x + move_dist * Math.cos(this.radians),
			y: this.pos.y + move_dist * Math.sin(this.radians)
		}).onComplete(function() {
			isMoving = false;
		});
	}

	public function hit() {
		this.color.tween(0.1, {r:1, g:1, b:1}).onComplete(function(){
			this.color.tween(0.5, {r: Main.c1.r, g: Main.c1.g, b: Main.c1.b});
		});

		this.hp -= 1;

		if (this.hp == 0) {
			Luxe.events.fire('effect.explosion', {pos: this.pos});
			Luxe.audio.play('harvest_karl_destroy');
			Luxe.camera.shake(10); // only shake when destroyed from being hit
		}
	}

}