package entity.trek;

import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

// import entity.Esth;

import C;

class Krist extends Sprite {

	// Krist: crystal; comet; rox; meteors; bearer of esth

	public var velocity: component.Velocity;
	public var hitbox: component.Hitbox;

	public var esth: Esth;
	public var isSmall: Bool;
	public var rotation_spd: Float;
	public var radius: Float;

	override public function new(_pos: Vector, _dir: Float, _isSmall: Bool) {
		super({
			name: 'krist',
			name_unique: true,
			pos: _pos,
			visible: false,
		});

		velocity = new component.Velocity({
			name: 'velocity',
		});
		this.add(velocity);

		this.add(new component.bounds.Kill({name: 'killbounds'}));

		// velocity and direction
		var actual_speed = C.krist_speed + Luxe.utils.random.float(-C.krist_radius_variance, C.krist_radius_variance);
		this.velocity.x = actual_speed * Math.cos(_dir);
		this.velocity.y = actual_speed * Math.sin(_dir);

		this.rotation_spd = Luxe.utils.random.float(-Math.PI/3, Math.PI/3);

		// size and create an esth child
		this.isSmall = _isSmall;
		if (!this.isSmall) {
			this.radius = C.krist_radius + Luxe.utils.random.float(-C.krist_radius_variance, C.krist_radius_variance);
			esth = new entity.trek.Esth(this.radius + Luxe.utils.random.int(C.esth_radius_min, C.esth_radius_max));
		} else {
			this.radius = C.krist_small_radius + Luxe.utils.random.float(-C.krist_small_radius_variance, C.krist_small_radius_variance);
			esth = new entity.trek.Esth(this.radius + Luxe.utils.random.int(C.esth_small_radius_min, C.esth_small_radius_max));
		}

		// create hitbox only after radius is decided
		hitbox = new component.Hitbox({
			name: 'hitbox',
			body: luxe.collision.shapes.Polygon.create(pos.x, pos.y, 4, this.radius),
		});
		this.add(hitbox);
		
		// states.Play.pKrist.push(this);
		// 
		
	}

	override public function update(dt: Float) {
		this.radians += rotation_spd * dt;

		esth.radians = this.radians;
		esth.pos = this.pos;

		Luxe.draw.ngon({
			x: this.pos.x,
			y: this.pos.y,
			sides: 4,
			r: radius,
			color: Main.c3,
			angle: - this.rotation_z,
			immediate: true,
			solid: true,
			depth: -1,
		});

		// // For debug purpose
		// Luxe.draw.text({
		// 	text: '${Math.floor(radius)}' + '${isSmall}',
		// 	pos: new Vector(this.pos.x, this.pos.y - 64),
		// 	point_size: 48,
		// 	align: right,
		// 	immediate: true,
		// });

		// states.Play.sDrawer.drawPolygon(this.hitbox.body);
	}

	override public function destroy(?_from_parent:Bool=false) {
		super.destroy(_from_parent);

		esth.destroy();
		// Luxe.off(Luxe.Ev.render, onrender);
	}

	public function hit() {

		if (this.isSmall) {
			Luxe.events.fire('effect.explosion', {pos: this.pos});
			Luxe.camera.shake(10);
		} else {
			Luxe.events.fire('effect.explosion.large', {pos: this.pos});
			Luxe.camera.shake(20);
			this.createFragments();
		}

		Main.trekExpSfx();

		this.destroy();
	}

	public function createFragments() {
		var amt = Luxe.utils.random.int(2, 4);

		for (i in 0...amt) {
			var krist = new Krist(
				this.pos,
				Luxe.utils.random.float(0, Math.PI * 2),
				true
			);
		}
	}

	// function onrender(_) {
	// 	Luxe.draw.ngon({
	// 		x: this.pos.x,
	// 		y: this.pos.y,
	// 		sides: 4,
	// 		r: radius,
	// 		color: Main.c3,
	// 		angle: - this.rotation_z,
	// 		immediate: true,
	// 		solid: true,
	// 		depth: -1,
	// 	});
	// }

	// override function init() {
	// 	Luxe.on(Luxe.Ev.render, onrender);
	// }

}