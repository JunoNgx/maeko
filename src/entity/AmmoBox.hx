package entity;

import luxe.Sprite;
import luxe.Vector;
import luxe.Color;

import luxe.collision.Collision;

class AmmoBox extends Sprite {

	public static var radius: Int = 72;

	public var velocity: component.Velocity;
	public var hitbox: component.Hitbox;
	public static var speed: Float = 2000;

	public var inContact: Bool = false;
	public var rotation_spd: Float;

	override public function new() {
		super({
			name: 'ammobox',
			name_unique: true,
			pos: new Vector (Main.w/2, Main.h/2),
			size: new Vector(4, 4),
		});

		velocity = new component.Velocity({
			name: 'velocity'
		});
		this.add(velocity);

		hitbox = new component.Hitbox({
			name: 'hitbox',
			body: luxe.collision.shapes.Polygon.create(pos.x, pos.y, 6, radius),
		});
		this.add(hitbox);

		this.add(new component.KillBounds({name: 'killbounds'}));

		this.pos = new Vector(Luxe.utils.random.float(0, Main.w), 0);
		this.velocity.x = Luxe.utils.random.float(-200, 200);
		this.velocity.y = 100;
		this.rotation_spd = Luxe.utils.random.float(-Math.PI/3, Math.PI/3);
		this.inContact = false;

		states.Play.pAmmo.push(this);
	}

	override public function update(dt: Float) {
		this.radians += rotation_spd * dt;

		var t_color: Color;

		inContact = this.hitbox.contact('maeko');

		if (inContact) {
			t_color = new Color().rgb(0xB6E5C3);
		} else {
			t_color = new Color().rgb(0xA03432);
		}

		Luxe.draw.ngon({
			x: this.pos.x,
			y: this.pos.y,
			sides: 6,
			r: radius,
			color: t_color,
			angle: - this.rotation_z,
			immediate: true,
		});

		// collision processing

		// var maeko: entity.Maeko = Luxe.scene.get('maeko');
		// if (Collision.shapeWithShape(this.hitbox.body, maeko.hitbox.body) == null) {
		// 	inContact = false;
		// } else inContact = true;
	}

	override public function destroy(?_from_parent:Bool=false) {
		super.destroy(_from_parent);

		states.Play.pAmmo.remove(this);
	}
}