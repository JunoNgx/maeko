package entity.end;

import luxe.Vector;
import luxe.Color;

class Praetorian extends luxe.Sprite {

	public var radius: Float;

	override public function new (_side: Int) {
		super({
			name: 'praetorian',
			name_unique: true,
			visible: false
		});

		// 1: right; 2: left; 3: praetorian chief
		switch(_side) {
			case 1:
				radius = 32;
				pos = new Vector(Main.w * 1/4, -Main.h * 3);
			case 2:
				radius = 32;
				pos = new Vector(Main.w * 3/4, -Main.h * 3);
			case 3:
				radius = 64;
				pos = new Vector(Main.w * 2/4, -Main.h * 3);
		}
	}

	override function update (dt: Float) {
		Luxe.draw.ngon({
			immediate: true,
			sides: 3,
			r: this.radius,
			x: this.pos.x,
			y: this.pos.y,
			color: new Color().rgb(0xff007b),
			angle: -180,
			solid: true
		});

		if (this.radius == 64) {
			Luxe.draw.ngon({
				immediate: true,
				sides: 3,
				r: this.radius + 12,
				x: this.pos.x,
				y: this.pos.y,
				color: new Color().rgb(0xff007b),
				angle: -180,
				solid: false
			});
		}
	}
}