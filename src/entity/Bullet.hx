package entity;

import luxe.Sprite;
import luxe.Vector;
import luxe.Color;

class Bullet extends luxe.Sprite {

	static var speed: Float = 400;

	public var velocity: component.Velocity;
	public var hitbox: component.Hitbox;

	override public function new(_x: Float, _y: Float, _hRad: Float) {
		super({
			name: 'bullet',
			name_unique: true,
			size: new Vector(32, 32),
			color: new Color().rgb(0xff4b03),
			pos: new Vector(_x, _y)
		});
		
		velocity = new component.Velocity({name: 'velocity'});
		this.add(velocity);

		hitbox = new component.Hitbox({
			name: 'hitbox',
			// body: luxe.collision.shapes.Polygon.create(pos.x, pos.y, 4, 24),
			body: luxe.collision.shapes.Polygon.square(pos.x, pos.y, 32, true),
		});
		this.add(hitbox);

		this.velocity.x = speed * Math.cos(_hRad);
		this.velocity.y = speed * Math.sin(_hRad);
		this.radians = _hRad;

		this.add(new component.KillBounds({name: 'killbounds'}));

		states.Play.pBullet.push(this);
	}

	override public function destroy(?_from_parent:Bool=false) {
		super.destroy(_from_parent);

		states.Play.pBullet.remove(this);
	}
}