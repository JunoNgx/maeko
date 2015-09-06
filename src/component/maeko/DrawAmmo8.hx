package component.maeko;

import luxe.Component;
import luxe.options.ComponentOptions;

import luxe.Color;
import luxe.Vector;
import luxe.Particles;

import C;

class DrawAmmo8 extends Component {

	public var obj_r: Float = 5; // object's radius

	public var solidity: Bool = false;
	public var depth_: Int = 2;

	public var r_s: Float = 49;
	public var r_l: Float = 54;

	override public function update (dt: Float) {

		var host: entity.Maeko = cast entity;

		// left side
		if (host.ammo >= 7) drawAmmo(
			host.pos.x + r_s * Math.cos(host.radians - Math.PI/2 + Math.PI * 3/24),
			host.pos.y + r_s * Math.sin(host.radians - Math.PI/2 + Math.PI * 3/24)
		);
		if (host.ammo >= 5) drawAmmo(
			host.pos.x + r_l * Math.cos(host.radians - Math.PI/2 + Math.PI * 1/27),
			host.pos.y + r_l * Math.sin(host.radians - Math.PI/2 + Math.PI * 1/27)
		);
		if (host.ammo >= 3) drawAmmo(
			host.pos.x + r_l * Math.cos(host.radians - Math.PI/2 - Math.PI * 1/27),
			host.pos.y + r_l * Math.sin(host.radians - Math.PI/2 - Math.PI * 1/27)
		);
		if (host.ammo >= 1) drawAmmo(
			host.pos.x + r_s * Math.cos(host.radians - Math.PI/2 - Math.PI * 3/24),
			host.pos.y + r_s * Math.sin(host.radians - Math.PI/2 - Math.PI * 3/24)
		);

		// right side
		if (host.ammo >= 8) drawAmmo(
			host.pos.x + r_s * Math.cos(host.radians + Math.PI/2 - Math.PI * 3/24),
			host.pos.y + r_s * Math.sin(host.radians + Math.PI/2 - Math.PI * 3/24)
		);
		if (host.ammo >= 6) drawAmmo(
			host.pos.x + r_l * Math.cos(host.radians + Math.PI/2 - Math.PI * 1/27),
			host.pos.y + r_l * Math.sin(host.radians + Math.PI/2 - Math.PI * 1/27)
		);
		if (host.ammo >= 4) drawAmmo(
			host.pos.x + r_l * Math.cos(host.radians + Math.PI/2 + Math.PI * 1/27),
			host.pos.y + r_l * Math.sin(host.radians + Math.PI/2 + Math.PI * 1/27)
		);
		if (host.ammo >= 2) drawAmmo(
			host.pos.x + r_s * Math.cos(host.radians + Math.PI/2 + Math.PI * 3/24),
			host.pos.y + r_s * Math.sin(host.radians + Math.PI/2 + Math.PI * 3/24)
		);
	}

	public function drawAmmo(_x: Float, _y: Float) {

		var host: entity.Maeko = cast entity;

		Luxe.draw.ngon({
			x: _x,
			y: _y,
			sides: 4,
			r: obj_r,
			solid: solidity,
			immediate: true,
			color: new Color(1, 1, 1, 1),
			angle: -host.rotation_z,
			depth: depth_,
		});
	}

}