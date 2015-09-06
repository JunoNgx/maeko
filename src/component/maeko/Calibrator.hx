package component.maeko;

import luxe.Component;
import luxe.options.ComponentOptions;

import luxe.Input;
import luxe.Color;
import luxe.Vector;

import luxe.tween.Actuate;

class Calibrator extends Component {

	override public function new() {
		super({name: 'calibrator'});
	}

	override public function onmouseup(e: MouseEvent) {
		if(Main.state.enabled('pause')) return;
		
		calibrate();
	}

	public function calibrate() {
		var host: entity.Maeko = cast entity;
		
		Main.center = new Vector(Main.accel_x, Main.accel_y);

		Actuate.tween(host.pos, 0.5, {x: Main.w/2, y: Main.h/2});
	}
}