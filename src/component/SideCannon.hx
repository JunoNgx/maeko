package component;

import luxe.Component;
import luxe.options.ComponentOptions;

import luxe.Color;
import luxe.Vector;

class SideCannon extends Component {

	public static var rof: Float = 2.2;
	public var cooldown: Float = 1;

	override public function new() {
		super({
			name: 'sideCannon'
		});
	}

	override public function update(dt: Float) {
		if (cooldown > 0) {
			cooldown -= dt;
		} else {
			fire();
			cooldown = rof;
		}
	}

	public function fire() {
		var host: entity.Ayu = cast entity;
		
		var radians1 = host.radians - Math.PI/2;
		var bullet1 = new entity.Bullet(
			host.pos.x + host.barrel * Math.cos(radians1),
			host.pos.y + host.barrel * Math.sin(radians1),
			radians1
		);

		var radians2 = host.radians + Math.PI/2;
		var bullet2 = new entity.Bullet(
			host.pos.x + host.barrel * Math.cos(radians2),
			host.pos.y + host.barrel * Math.sin(radians2),
			radians2
		);
	}
}