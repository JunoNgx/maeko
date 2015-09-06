package entity.menu;

import luxe.Color;
import luxe.Vector;
import luxe.Text;
import luxe.Rectangle;

import luxe.Input;

import luxe.tween.Actuate;

import C;

class ResetButton extends luxe.Sprite {

	public var length: Float = 320;
	public var height: Float = 50;
	public var frame: Rectangle;

	public var event: Void -> Void;
	public var isTouched: Bool = false;
	public var progress: Float = 0;

	public var onWhiteBack: Bool;

	override public function new(_event: Void -> Void, _onWhiteBack: Bool) {
		super({
			name: 'reset button',
			visible: false,
			pos: new Vector (Main.w * 0.17, Main.h * 0.9),
		});

		onWhiteBack = _onWhiteBack;
		event = _event;
		frame = new Rectangle(
			this.pos.x - length/2,
			this.pos.y - height/2,
			length,
			height
		);
	}

	override public function update(dt: Float) {

		if (progress < 1) {

			if (isTouched) {
				progress += dt/C.reset_hold_time; // require C.reset_hold_time seconds of holding to erase progress
			} else {
				Actuate.tween( this, 0.1, {progress: 0});
			}

		} else {
			event();
		}

		var disp_color = new Color();

		if (!onWhiteBack) {
			disp_color = new Color(1, 1, 1, 0.1 + (progress * 0.9));
		} else {
			disp_color = new Color(0, 0, 0, 0.1 + (progress * 0.9));
		}

		Luxe.draw.text({
			immediate: true,
			text: 'hold to reset progress',
			pos: this.pos,
			align: center,
			align_vertical: center,
			point_size: 32,
			color: disp_color,
			font: Main.arcon,
		});

		// Luxe.draw.rectangle({
		// 	immediate: true,
		// 	x: this.frame.x,
		// 	y: this.frame.y,
		// 	w: this.frame.w,
		// 	h: this.frame.h,
		// 	color: new Color(0, 0, 0, 0.15 + (progress * 0.85)),
		// });
	}

	override function onmousedown(e: MouseEvent) {
		this.isTouched = this.frame.point_inside(Luxe.camera.screen_point_to_world(e.pos));
	}

	override function onmouseup(e: MouseEvent) {
		this.isTouched = false;
	}

}
