package entity.trek;

import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

import luxe.tween.Actuate;

import C;

class Wheel extends luxe.Sprite {

	public var radius: Float = 160;
	public var event: Void -> Void;
	
	override public function new(_event: Void -> Void) {
		super({
			name: 'wheel',
			pos: new Vector(Main.w/2, Main.h/2),
			color: Main.c2.clone(),
			visible: false,
		});

		event = _event;
		this.color.a = 0;

		fadeIn();

		trace('wheel created');
	}

	override function update(dt: Float) {
		Luxe.draw.ngon({
			immediate: true,
			solid: false,
			sides: 4,
			r: this.radius,
			x: this.pos.x,
			y: this.pos.y,
			color: this.color,
			angle: -this.rotation_z,
		});
	}

	public function fadeIn() {
		Actuate.tween(this.color, 1, {a: 1}).onComplete( function(){
			doThings();
			trace('wheel faded in');
			
			// Luxe.audio.play('wheel_trek');
		});
	}

	public function doThings() {
		Actuate.tween(this, 2, {radians: Math.PI * 2 * 4})
			.delay(1.5)
			.onComplete( function(){
				fadeOut();
				trace('wheel done things');

				Luxe.audio.play('evolved');
			});
	}

	public function fadeOut() {
		Actuate.tween(this.color, 1, {a: 0}).delay(1).onComplete( event );
	}

}