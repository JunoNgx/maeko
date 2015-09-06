package states;
import luxe.Sprite;
import luxe.Input;
import luxe.States;
import luxe.Color;
import luxe.Vector;
import luxe.Camera;

import luxe.tween.Actuate;

import C;

class Credits extends State {

	override public function onenter<T> (_:T) {
		Main.camReset();
		Luxe.renderer.clear_color = new Color(0, 0, 0, 1);

		Luxe.timer.schedule(4, cycleCount);
	}

	function cycleCount() {
		var text1 = new entity.FadingText(
			'cycles taken: ' + Main.p_cycle,
			5,
			0.5,
			64
		);

		Luxe.timer.schedule(8, mainCreator);
	}

	function mainCreator() {
		var text1 = new entity.FadingText(
			'concept, design, programming, audio & music\n\nby',
			4,
			0.4,
			32,
			new Color(1, 0, 0.5, 0)
		);

		var text2 = new entity.FadingText(
			'Juno Nguyen',
			4,
			0.6,
			32,
			new Color(0, 0.5, 1, 0)
		);

		Luxe.timer.schedule(6, videogames);
		Luxe.audio.play('credits');
	}

	function videogames() {
		var text1 = new entity.FadingText(
			'videogames played in the development process',
			3,
			0.3,
			32
		);

		var text2 = new entity.FadingText(
			'Bloodborne\n\nWolfenstein: The New Order\n\nDark Echo\n\nLife is Strange, Episode 4: Dark Room',
			3,
			0.6,
			32,
			new Color(1, 0, 0.5, 0)
		);

		Luxe.timer.schedule(5, specialThanks);
	}

	function specialThanks() {
		var text1 = new entity.FadingText(
			'special thanks',
			3,
			0.4,
			32
		);

		var text2 = new entity.FadingText(
			'Sven Bergström\n\nsnõwkit gitter chat community',
			3,
			0.6,
			32,
			new Color(1, 0, 0.5, 0)
		);

		Luxe.timer.schedule(5, verySpecialThanks);
	}

	function verySpecialThanks() {
		var text1 = new entity.FadingText(
			'very special thanks',
			3,
			0.4,
			32,
			new Color(1, 0, 0.5, 0)
		);

		var text2 = new entity.FadingText(
			'Sebastian Gosztyla',
			3,
			0.6,
			32,
			new Color(0, 0.5, 1, 0)
		);

		Luxe.timer.schedule(5, madeWithLuxe);
	}

	function madeWithLuxe() {
		var luxe = new entity.FadingTexture('assets/MadeWithLuxe.png', 3);
		Luxe.timer.schedule(6, postCredits);
	}

	function postCredits() {
		
		var seed_col = new Color(1, 0, 0.5, 0);
		var seed = Luxe.draw.ngon({
			// immediate: true,
			solid: false,
			sides: 3,
			r: 128,
			x: Main.w/2,
			y: Main.h/2,
			color: seed_col,
			angle: -180,
		});

		Actuate.tween(seed.color, 1, {a: 1})
			.repeat(1)
			.reflect()
			.delay(1)
			.onComplete(function(){
				Luxe.timer.schedule(3, resetGame);
				Luxe.audio.play('evolved');

				// Must the post-credits scene to get a winning status XD
				Luxe.io.string_save('credits', '1');
			});
	}

	function resetGame() {
		Main.state.set('menu');
	}

	override public function onleave<T> (_:T) {
		Luxe.timer.reset();
		Luxe.scene.empty();
		Luxe.events.clear();
	}

	override function onmouseup( event: MouseEvent) {
		resetGame();
		Luxe.audio.stop('credits');
	}

}
