package states;

import luxe.Color;
import luxe.Vector;
import luxe.Sprite;
import luxe.States;
import luxe.Input;
import phoenix.Texture;

class Splash extends State {

	public var lifetime: Float = 0;

	override function onenter<T> (_:T) {

		Main.camReset();
		Luxe.renderer.clear_color = new Color(0, 0, 0, 1);

		lifetime = 0;

		Luxe.timer.schedule(1, spawnAureoTetra);
		Luxe.timer.schedule(6, spawnMadeWithLuxe);
		Luxe.timer.schedule(10, spawnHeadphone);

		Luxe.timer.schedule(14, switchState);
	}

	function spawnAureoTetra() {
		var aureo = new entity.FadingTexture('assets/AureolineTetrahedron.png', 2);
	}

	function spawnMadeWithLuxe() {
		var luxe = new entity.FadingTexture('assets/MadeWithLuxe.png', 2);
	}

	function spawnHeadphone() {
		var headphones = new entity.FadingTexture('assets/Headphones.png', 2);
	}

	// Switch to the designated state, set above
	function switchState() {
		Main.state.set('menu');
	}

	// Optionally skip splash screen with a touch
	// only when a 3-second window period has passed
	override function onmouseup(e: MouseEvent) {
		if (lifetime > 3) switchState();
	}

	override function update(dt: Float) {
		lifetime += dt;
	}
	
	override function onleave<T> (_:T) {
		Luxe.timer.reset();
		Luxe.scene.empty();
	}


}
