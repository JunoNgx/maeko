package entity.menu;

import luxe.Sprite;
import luxe.options.SpriteOptions;
import luxe.Text;
import luxe.Color;
import luxe.Vector;
import luxe.Rectangle;

import C;

typedef ButtonOptions = {
	> SpriteOptions,

	var label: String;
}

class Button extends Sprite {

	public var frame: Rectangle;

	public var label: String;
	public var trigger: Void->Void;

	override public function new(_options: ButtonOptions, _trigger: Void -> Void) {
		super(_options);

		label = _options.label;
		trigger = _trigger;

		frame = new Rectangle(
			this.pos.x - C.button_w/5, //dirty hack!!
			this.pos.y - C.button_h/2, 
			C.button_w,
			C.button_h
		);
	}

	override public function update(dt: Float) {
		// Luxe.draw.rectangle({
		// 	immediate: true,
		// 	x: this.frame.x,
		// 	y: this.frame.y,
		// 	w: this.frame.w,
		// 	h: this.frame.h,
		// 	color: Main.c1.clone(),
		// });

		Luxe.draw.text({
			immediate: true,
			text: label,
			pos: this.pos,
			align: left,
			align_vertical: center,
			point_size: 48,
			font: Main.arcon,
			color: this.color,
			depth: this.depth,
		});
	}

}