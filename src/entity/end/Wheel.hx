package entity.end;

import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

import luxe.tween.Actuate;

import C;

class Wheel extends luxe.Sprite {

	public var radius: Float = 48;
	
	override public function new() {
		super({
			name: 'wheel',
			pos: new Vector(Main.w/2, -Main.h/2),
			color: Main.c3.clone(),
			visible: false,
		});

		this.color.a = 0;
		fadeIn();
	}

	override function update(dt: Float) {
		Luxe.draw.ring({
			immediate: true,
			r: this.radius,
			x: this.pos.x,
			y: this.pos.y,
			color: this.color,
		});
	}

	public function fadeIn() {
		Actuate.tween(this.color, 1, {a: 1}).onComplete( function(){
			Luxe.audio.play('evolved');
		});
	}

}