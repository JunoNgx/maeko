package component.maeko.cannon;

import luxe.Component;
import luxe.options.ComponentOptions;

import luxe.Input;
import luxe.Color;
import luxe.Vector;

class CannonBase extends Component {

	override public function new() {
		super({name: 'cannon'});
	}

	override public function onmouseup(e: MouseEvent) {
		
		if(Main.state.enabled('pause')) return;
		if(Main.hitPause(Luxe.camera.screen_point_to_world(e.pos))) return;

		fire();	
	}

	public function fire() {

	}
}