package entity.base;

import luxe.Vector;
import luxe.Color;

import C;

class Projectile extends luxe.Sprite {

	public var velocity: component.Velocity;
	public var hitbox: component.Hitbox;

	public var radius: Float;

	override public function new(_pos: Vector, _speed: Float, _dir: Float) {
		super({
			name: 'projectile',
			name_unique: true,
			pos: _pos,
			visible: false,
		});
		
		velocity = new component.Velocity({name: 'velocity'});
		this.add(velocity);

		this.add(new component.bounds.Kill({name: 'killbounds'}));

		this.setVelo(_speed, _dir);
		this.radians = _dir;
		this.initiate();
	}

	public function initiate() {

	}

	public function setVelo(_speed: Float, _dir: Float) {
		this.velocity.x = _speed * Math.cos(_dir);
		this.velocity.y = _speed * Math.sin(_dir);
	}

	public function draw() {

	}

	public function collide() {

	}

	override public function update(dt: Float) {

		// radiansSync();
		collide();
		draw();
		
	}
	
}