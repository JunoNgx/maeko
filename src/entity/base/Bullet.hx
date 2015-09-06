package entity.base;

import luxe.Sprite;
import luxe.Vector;
import luxe.Color;

import C;

class Bullet extends luxe.Sprite {

	static var speed: Float = 400;

	public var velocity: component.Velocity;
	public var hitbox: component.Hitbox;

	override public function new(_x: Float, _y: Float, _hRad: Float) {
		super({
			name: 'bullet',
			name_unique: true,
			size: new Vector(32, 32),
			// color: Main.c2.clone(),
			pos: new Vector(_x, _y)
		});
		
		velocity = new component.Velocity({name: 'velocity'});
		this.add(velocity);

		this.add(new component.bounds.Kill({name: 'killbounds'}));

		this.initiate();
	}

	public function initiate() {

	}

	public function setVelo(_speed: Float, _dir: Float) {
		this.velocity.x = _speed * Math.cos(_dir);
		this.velocity.y = _speed * Math.sin(_dir);
	}

	public function collide() {

	}

	public function draw() {

	}

	override public function update(dt: Float) {

		collide();
		draw();
		
	}
}