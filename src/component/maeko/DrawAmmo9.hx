package component.maeko;

import luxe.Component;
import luxe.options.ComponentOptions;

import luxe.Color;
import luxe.Vector;
import luxe.Particles;

import C;

class DrawAmmo9 extends Component {

	public var obj_r: Float = 8; // object's radius

	public var solidity: Bool = false;
	public var depth_: Int = 2;

	public var r_d: Float = 64; // distance to entity

	override public function update (dt: Float) {

		var host: entity.Maeko = cast entity;
		var side_amt = Math.ceil(host.ammo_max/2);

		// left side
		if (host.ammo >= 9) drawAmmo(
			host.pos.x + r_d * Math.cos(host.radians - Math.PI * 1/side_amt),
			host.pos.y + r_d * Math.sin(host.radians - Math.PI * 1/side_amt)
		);
		if (host.ammo >= 7) drawAmmo(
			host.pos.x + r_d * Math.cos(host.radians - Math.PI * 2/side_amt),
			host.pos.y + r_d * Math.sin(host.radians - Math.PI * 2/side_amt)
		);
		if (host.ammo >= 5) drawAmmo(
			host.pos.x + r_d * Math.cos(host.radians - Math.PI * 3/side_amt),
			host.pos.y + r_d * Math.sin(host.radians - Math.PI * 3/side_amt)
		);
		if (host.ammo >= 3) drawAmmo(
			host.pos.x + r_d * Math.cos(host.radians - Math.PI * 4/side_amt),
			host.pos.y + r_d * Math.sin(host.radians - Math.PI * 4/side_amt)
		);
		if (host.ammo >= 1) drawAmmo(
			host.pos.x + r_d * Math.cos(host.radians - Math.PI * 5/side_amt),
			host.pos.y + r_d * Math.sin(host.radians - Math.PI * 5/side_amt)
		);

		// right side
		if (host.ammo >= 8) drawAmmo(
			host.pos.x + r_d * Math.cos(host.radians + Math.PI * 1/side_amt),
			host.pos.y + r_d * Math.sin(host.radians + Math.PI * 1/side_amt)
		);
		if (host.ammo >= 6) drawAmmo(
			host.pos.x + r_d * Math.cos(host.radians + Math.PI * 2/side_amt),
			host.pos.y + r_d * Math.sin(host.radians + Math.PI * 2/side_amt)
		);
		if (host.ammo >= 4) drawAmmo(
			host.pos.x + r_d * Math.cos(host.radians + Math.PI * 3/side_amt),
			host.pos.y + r_d * Math.sin(host.radians + Math.PI * 3/side_amt)
		);
		if (host.ammo >= 2) drawAmmo(
			host.pos.x + r_d * Math.cos(host.radians + Math.PI * 4/side_amt),
			host.pos.y + r_d * Math.sin(host.radians + Math.PI * 4/side_amt)
		);

	}

	public function drawAmmo(_x: Float, _y: Float) {

		var host: entity.Maeko = cast entity;

		Luxe.draw.ring({
			x: _x,
			y: _y,
			r: obj_r,
			immediate: true,
			color: new Color(1, 1, 1, 1),
			depth: depth_,
		});
	}

}