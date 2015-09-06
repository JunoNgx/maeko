package entity;

import luxe.Sprite;
import luxe.Input;
import luxe.Color;
import luxe.Vector;

// This class is simply a visual signifier without functionality,
// indicating that the game may be paused
// Actual pause processing codes are in Main.hx
class PauseKeyGraphic extends Sprite {

	override public function new() {
		super({
			name: 'pauseKey',
			size: new Vector(60, 60),
			pos: new Vector( Main.w - 32, 32),
			depth: 12,
			texture: Luxe.resources.texture('assets/PauseButton.png'),
		});

		Main.pauseKeyIsPresent = true;
	}

	override public function destroy( ?_from_parent:Bool=false ) {
		super.destroy(_from_parent);

		Main.pauseKeyIsPresent = false;
	}
}