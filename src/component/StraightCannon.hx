package component;

import luxe.Component;
import luxe.options.ComponentOptions;

import luxe.Color;
import luxe.Vector;

class StraightCannon extends Component {

	public static var rof: Float = 1.7;
	public var cooldown: Float = 1;

	override public function new() {
		super({
			name: 'straightCannon'
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
		var bullet = new entity.Bullet(
			host.pos.x + host.barrel * Math.cos(host.radians),
			host.pos.y + host.barrel * Math.sin(host.radians),
			host.radians
		);
	}
}