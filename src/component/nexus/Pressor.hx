package component.nexus;

import luxe.Component;
import luxe.options.ComponentOptions;

import luxe.Vector;
import luxe.Color;

import C;

class Pressor extends Component {

	public var pressTime: Float;
	public var outcome: Void -> Void;

	public var pressProg: Float = 0; // How far to completion the button has been pressed
	public var showIndicator: Bool = false;
	public var completed: Bool = false;

	override public function new(_pressTime: Float, _outcome: Void -> Void) {
		super({
			name: 'pressor'
		});

		pressTime = _pressTime;
		outcome = _outcome;
	}

	override public function update(dt: Float) {
		var host: luxe.Sprite = cast entity;

		// clever and unmaintainable codes below!!
		// set color correspond to pressing completion
		host.color = new ColorHSL(
			Main.c3.toColorHSL().h,
			Main.c3.toColorHSL().s,
			Main.c3.toColorHSL().l + pressProg * (1 - Main.c3.toColorHSL().l)
		).toColor();

		if (!completed){
		
			if (host.has('hitbox')){ // make sure host has a hitbox
				if (host.get('hitbox').collide('maeko') != null) {
					showIndicator = true; // to show that button is being pressed
					if (pressProg < 1) pressProg += dt/pressTime;
				} else {
					showIndicator = false;
					if (pressProg > 0) pressProg -= dt;
				} // else
			} // if host has hitbox

			if (pressProg > 1) {
				outcome();
				showIndicator = false;
				completed = true;
			} // pressProg > 1
		}
	}

}