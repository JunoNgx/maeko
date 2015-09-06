package entity;

import luxe.Color;
import luxe.Vector;

import luxe.tween.Actuate;

import C;

class FadingTexture extends luxe.Sprite {

	override public function new(_textureid: String, ?_time: Float, ?_xPos: Float, ?_yPos: Float) {

		if (_time == null) _time = 5;
		if (_xPos == null) _xPos = 0.5; // relative x coordinates
		if (_yPos == null) _yPos = 0.5; // relative y coordinates

		super({
			name: 'fadingTexture',
			name_unique: true,
			texture: Luxe.resources.texture(_textureid),
			pos: new Vector(Main.w * _xPos, Main.h * _yPos),
		});

		this.color.a = 0;

		Actuate.tween(this.color, 1, {a: 1}).onComplete(function(){
			Actuate.tween(this.color, 1, {a: 0}).delay(_time).onComplete(destroy);
		});
	}
}