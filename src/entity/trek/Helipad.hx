package entity.trek;

import luxe.Color;
import luxe.Vector;

import luxe.tween.Actuate;

import C;

class Helipad extends luxe.Sprite {

	public var radius: Float = 32;

	override public function new() {
		super({
			name: 'helipad',
			pos: new Vector(160, 90),
			visible: false,
			color: new Color().rgb(0xB1586A),
			
		});

		moveIn();
	}

	override function update(dt: Float) {

		Luxe.draw.ngon({
			immediate: true,
			solid: true,
			sides: 3,
			r: this.radius,
			x: this.pos.x,
			y: this.pos.y,
			color: this.color,
			angle: -180,
			depth: -10,
		});
	}

	public function moveIn() {

		Actuate.tween(this, C.trek_total_time, {radius: 900})
			.ease(luxe.tween.easing.Sine.easeIn);
			// .ease(luxe.tween.easing.Linear.easeNone );

		Actuate.tween(this.pos, C.trek_total_time, {x: Main.w/2, y: Main.h/2})
			.ease(luxe.tween.easing.Linear.easeNone )
			.onComplete(function(){
				Luxe.events.fire('trek completed');
			});
	}
}