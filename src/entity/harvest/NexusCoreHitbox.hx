package entity.harvest;

import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

import luxe.tween.Actuate;

import C;

class NexusCoreHitbox extends Sprite {

	public var radius: Float = 12;
	public var isCompromised: Bool = false;

	override public function new() {
		super({
			name: 'nexus_core',
			name_unique: true,
			pos: new Vector(Main.w/2, Main.h * 4/5),
			visible: false,
		});

		this.add( new component.Hitbox( {
			name: 'hitbox',
			body: luxe.collision.shapes.Polygon.create(pos.x, pos.y, 12, this.radius),
		}));
	}

	override public function update(dt: Float) {
		if (this.get('hitbox').collide('karl') != null && !isCompromised) {
			this.isCompromised = true;
			Luxe.events.fire('core is compromised');
			// trace('core is compromised');
		}
	}
}