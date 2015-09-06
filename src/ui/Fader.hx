package ui;

import luxe.Sprite;
import luxe.Vector;
import luxe.Color;

import luxe.tween.Actuate;

class Fader extends Sprite {

	override public function new(_col: Float, _alpha: Float) {
		super({
			name: 'fader',
			pos: new Vector(Main.w/2, Main.h/2),
			size: new Vector(Main.w, Main.h),
			color: new Color(_col, _col, _col, _alpha),
			depth: 10,
		});
	}

	public function fadeIn(_time: Float, ?trigger: Void -> Void) {
		Actuate.tween(this.color, _time, {a: 0}).onComplete(function(){
			if(trigger != null) trigger();
		});
	}

	public function fadeOut(_time: Float, ?trigger: Void -> Void) {
		Actuate.tween(this.color, _time, {a: 1}).onComplete(function(){
			if(trigger != null) trigger();
		});
	}

}