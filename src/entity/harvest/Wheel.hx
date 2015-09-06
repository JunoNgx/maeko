package entity.harvest;

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
			pos: new Vector(Main.w/2, -Main.h/2 - 100),
			color: Main.c3.clone(),
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
			sides: 3,
			r: this.radius,
			x: this.pos.x,
			y: this.pos.y,
			color: this.color,
			angle: 180,
		});
	}

	public function fadeIn() {
		Actuate.tween(this.color, 1, {a: 1}).onComplete( function(){
			doThings();
			trace('wheel faded in');
			
			Luxe.audio.play('evolved');
		});
	}

	public function doThings() {
		Actuate.tween(this.color, 1, {r: 1, g: 1, b: 1})
			.delay(1.5)
			.repeat(1)
			.reflect()
			.onComplete( function(){
				fadeOut();
				trace('wheel done things');
			});
	}

	public function fadeOut() {
		Actuate.tween(this.color, 1, {a: 0}).delay(1).onComplete( event );
	}

}