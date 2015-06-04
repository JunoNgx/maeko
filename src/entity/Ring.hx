package entity;

import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

class Ring extends Sprite {

	// public var dir_x: Float;
	// public var dir_y: Float;

	public var velocity: component.Velocity;
	static var speed: Float = 200;

	override public function new() {
		super({
			name: 'ring',
			texture: Luxe.resources.texture('assets/Ring.png'),
			color: new Color().rgb(0x007bf6),
			pos: new Vector(Main.w/2, Main.h/2)
		});


		velocity = new component.Velocity({
			name: 'velocity',
			vx: speed * Luxe.utils.random.sign(0.5),
			vy: speed * Luxe.utils.random.sign(0.5),
		});
		this.add(velocity);

		this.add(new component.BounceBounds({
			name: 'bounceBounds',
		}));
	}

	override public function update(dt: Float) {
		Luxe.events.fire('ring.pos', {x: this.pos.x, y: this.pos.y});
	}
}