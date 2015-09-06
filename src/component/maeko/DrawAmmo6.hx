package component.maeko;

import luxe.Component;
import luxe.options.ComponentOptions;

import luxe.Color;
import luxe.Vector;
import luxe.Particles;

import C;

class DrawAmmo6 extends Component {

	public var obj_r: Float = 8; // object's radius

	public var solidity: Bool = false;
	public var depth_: Int = 2;

	public var r_1: Float = 48; // top tier
	public var r_2: Float = 53; // mid tier
	public var r_3: Float = 64; // bottom tier

	// override public function update (dt: Float) {
	function onrender(_) {

		var host: entity.Maeko = cast entity;

		// use the right side ammo first

		// top tier
		if (host.ammo >= 6) drawAmmo(
			host.pos.x + r_1 * Math.cos(host.radians + Math.PI/2 - Math.PI * 1.5/10),
			host.pos.y + r_1 * Math.sin(host.radians + Math.PI/2 - Math.PI * 1.5/10)
		);

		if (host.ammo >= 5) drawAmmo(
			host.pos.x + r_1 * Math.cos(host.radians - Math.PI/2 + Math.PI * 1.5/10),
			host.pos.y + r_1 * Math.sin(host.radians - Math.PI/2 + Math.PI * 1.5/10)
		);

		// mid tier
		if (host.ammo >= 4) drawAmmo(
			host.pos.x + r_2 * Math.cos(host.radians + Math.PI/2),
			host.pos.y + r_2 * Math.sin(host.radians + Math.PI/2)
		);

		if (host.ammo >= 3) drawAmmo(
			host.pos.x + r_2 * Math.cos(host.radians - Math.PI/2),
			host.pos.y + r_2 * Math.sin(host.radians - Math.PI/2)
		);

		// bottom tier
		if (host.ammo >= 2) drawAmmo(
			host.pos.x + r_3 * Math.cos(host.radians + Math.PI/2 + Math.PI * 9/10),
			host.pos.y + r_3 * Math.sin(host.radians + Math.PI/2 + Math.PI * 9/10)
		);

		if (host.ammo >= 1) drawAmmo(
			host.pos.x + r_3 * Math.cos(host.radians - Math.PI/2 - Math.PI * 9/10),
			host.pos.y + r_3 * Math.sin(host.radians - Math.PI/2 - Math.PI * 9/10)
		);
	}

	public function drawAmmo(_x: Float, _y: Float) {

		var host: entity.Maeko = cast entity;

		Luxe.draw.ngon({
			x: _x,
			y: _y,
			sides: 3,
			r: obj_r,
			solid: solidity,
			immediate: true,
			color: Main.c2.clone(),
			angle: 90 - host.rotation_z, // lol clever code again
			depth: depth_,
		});
	}

	override function init() {
		Luxe.on(Luxe.Ev.render, onrender);
	}

	override function ondestroy() {
		super.ondestroy();
		Luxe.off(Luxe.Ev.render, onrender);
	}

}