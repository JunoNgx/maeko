package entity;

import luxe.Text;

import luxe.Color;
import luxe.Vector;

import luxe.tween.Actuate;

import C;

class FadingText extends Text {

	// public var lifetime_max: Float;

	// public var counting: Bool = false;
	// public var lifetime: Float = 0;
	
	override public function new(_content: String, ?_time: Float, ?_yPos: Float, ?_size: Int, ?_color: Color) {

		// lifetime_max = (_time == null) ? 4 : _time;
		if (_time == null) _time = 5;
		if (_yPos == null) _yPos = 0.5;
		if (_size == null) _size = 48;
		if (_color == null) _color = new Color();

		super({
			name: 'fadingText',
			name_unique: true,
			text: _content,
			pos: new Vector(Main.w * 0.5, Main.h * _yPos),
			align: center,
			align_vertical: center,
			point_size: _size,
			color: _color,
			depth: -2,
			font: Main.arcon,
		});
		this.color.a = 0;

		// Actuate.tween(this.color, 1, {a: 1}).onComplete(function() { this.counting = true; });
		Actuate.tween(this.color, 1, {a: 1}).onComplete(function(){
			Actuate.tween(this.color, 1, {a: 0}).delay(_time).onComplete(destroy);
		});
	}

	// override public function update(dt: Float) {
	// 	if (counting) {
	// 		if (lifetime < lifetime_max) {
	// 			lifetime += dt;
	// 		} else {
	// 			Actuate.tween(this.color, 1, {a: 0}).onComplete(function() { this.destroy(); });
	// 			counting = false;
	// 		}
	// 	}
	// }

}