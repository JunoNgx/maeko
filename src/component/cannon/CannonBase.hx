package component.cannon;

import luxe.Component;
import luxe.options.ComponentOptions;

import luxe.Color;
import luxe.Vector;

class CannonBase extends Component {

	public function fire() {
		playSfx();
	}

	public function playSfx() {
		var roll: Int = Luxe.utils.random.int(1, 5);

		switch(roll) {
			case 1:
				Luxe.audio.play('ayucannon1');
			case 2:
				Luxe.audio.play('ayucannon2');
			case 3:
				Luxe.audio.play('ayucannon3');
			case 4:
				Luxe.audio.play('ayucannon4');
		}
	}

}