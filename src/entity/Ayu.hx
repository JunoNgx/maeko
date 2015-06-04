package entity;

import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

import luxe.collision.Collision;

class Ayu extends Sprite {

	public var barrel: Float = 48; // offset when bullet is spawned from entity

	public var velocity: component.Velocity;
	public var hitbox: component.Hitbox;

	override public function new(_IsTrout: Bool){
		super({
			name: 'ayu',
			name_unique: true,
			size: new Vector(64, 32),
		});

		hitbox = new component.Hitbox({
			name: 'hitbox',
			body: luxe.collision.shapes.Polygon.rectangle(pos.x, pos.y, 64, 32, true)
		});
		this.add(hitbox);

		velocity = new component.Velocity({name: 'velocity'});
		this.add(velocity);

		this.add(new component.KillBounds({
			name: 'killbounds'
		}));

		this.pos = new Vector(Luxe.utils.random.float(0, Main.w), 0);
		this.velocity.x = Luxe.utils.random.float(-200, 200);
		this.velocity.y = 150;
		this.radians = Math.atan2(this.velocity.y, this.velocity.x);

		if (_IsTrout) {
			this.add( new component.SideCannon());
			this.color = new Color().rgb(0xff4b03);
		} else {
			this.add( new component.StraightCannon());
			this.color = new Color().rgb(0xf6007b);
		}

		states.Play.pAyu.push(this);
	}

	override public function destroy(?_from_parent:Bool=false) {
		super.destroy(_from_parent);

		states.Play.pAyu.remove(this);
	}

	// override public function update(dt: Float) {
	// 	if (hitbox.contact('shot')) this.destroy();
	// }

	// public function contact() {
	// 	var contact: Bool = false;
	// 	var targetList = new Array<luxe.Entity>();
	// 	Luxe.scene.get_named_like('shot', targetList);

	// 	// var ammoBodyList = new Array<luxe.collision.shapes.Shape>();
	// 	for (target in targetList) {
	// 		if (Collision.shapeWithShape(this.hitbox.body, target.get('hitbox').body) != null) {
	// 			contact = true;
	// 		}
	// 	}

	// 	return contact;
	// }
}