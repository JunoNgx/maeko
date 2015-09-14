package entity.trek;

import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

import luxe.collision.Collision;
import luxe.tween.Actuate;

import C;

class Hessel extends Sprite {

	// powerup pickup which speeds up progress in trek chapter

	public var velocity: component.Velocity;
	public var hitbox: component.Hitbox;

	public var flash_cooldown: Float = 0;
	public var rotation_spd: Float;

	override public function new(_pos: Vector){
		super({
			name: 'hessel',
			name_unique: true,
			// size: new Vector(32, 32),
			color: Main.c3.clone(),
			visible: false,
			pos: _pos,
		});

		hitbox = new component.Hitbox({
			name: 'hitbox',
			body: luxe.collision.shapes.Polygon.create(pos.x, pos.y, 4, C.hessel_radius)
		});
		this.add(hitbox);

		velocity = new component.Velocity({name: 'velocity'});
		this.add(velocity);

		this.add(new component.bounds.Kill({
			name: 'killbounds'
		}));

		// this.pos = new Vector(Luxe.utils.random.float(0, Main.w), 0);
		this.velocity.x = Luxe.utils.random.float(-150, 150);
		this.velocity.y = 150;

		this.rotation_spd = Luxe.utils.random.float(-Math.PI/3, Math.PI/3);
		flash();
	}

	override public function update(dt: Float) {
		this.radians += rotation_spd * dt;
		collide();

		if (flash_cooldown > 0) {
			flash_cooldown -= dt;
		} else {
			flash();
			flash_cooldown = C.hessel_flash_cooldown;
		}

		Luxe.draw.ngon({
			x: this.pos.x,
			y: this.pos.y,
			sides: 4,
			r: C.hessel_radius,
			color: this.color,
			angle: - this.rotation_z,
			immediate: true,
			solid: true,
			depth: -1,
		});
	}

	function collide() {
		var target = hitbox.collide('maeko');
		if (target != null) {
			var maeko: entity.Maeko = cast target;
			
			maeko.ammo += 4;
			if (maeko.ammo > maeko.ammo_max) maeko.ammo = maeko.ammo_max;
			Luxe.audio.play('trek_pickup');
			
			this.destroy();
		} // collide against maeko
	}

	function flash() {
		Actuate.tween(this.color, 0.1, {r: 1, g: 1, b: 1}).repeat(1).reflect(true);
	}

// 	function onrender(_) {
// 		Luxe.draw.ngon({
// 			x: this.pos.x,
// 			y: this.pos.y,
// 			sides: 4,
// 			r: C.hessel_radius,
// 			color: this.color,
// 			angle: - this.rotation_z,
// 			immediate: true,
// 			solid: true,
// 			depth: -1,
// 		});
// 	}

// 	override function init() {
// 		Luxe.on(Luxe.Ev.render, onrender);
// 	}

// 	override function destroy(?_from_parent:Bool=false) {
// 		super.destroy(_from_parent);
// 		Luxe.off(Luxe.Ev.render, onrender);
// 	}

}