package entity.menu;
import luxe.Sprite;
import luxe.Input;
import luxe.States;
import luxe.Color;
import luxe.Vector;
import luxe.Camera;

import C;

class State extends luxe.State {

	public var buttons: Array<entity.menu.Button>;
	public var fader: ui.Fader;

	public var reset: entity.menu.ResetButton;

	public var game_completed: Bool;

	override public function onenter<T> (_:T) {

		Main.camReset();
		Main.c1 = new Color().rgb(0xeeeeee); // likely unused
		Main.c2 = new Color().rgb(0xffffff); // likely unused
		Main.c3 = new Color().rgb(0xff007b); // likely unused
		Main.c4 = new Color().rgb(0xeeeeee); // likely unused
		Main.c5 = new Color().rgb(0x222222); // unused as well
		fader = new ui.Fader(0, 1);
		fader.fadeIn(1);

		// First thing first, check progress if game is completed
		if (Luxe.io.string_load('calibrate') == '1'
			&& Luxe.io.string_load('harvest') == '1'
			&& Luxe.io.string_load('trek') == '1'
			&& Luxe.io.string_load('end') == '1'
			&& Luxe.io.string_load('credits') == '1') {
			game_completed = true;
		} else game_completed = false;

		if (game_completed) {
			Luxe.renderer.clear_color = new Color().rgb(0xdddddd);
		} else {
			Luxe.renderer.clear_color = new Color().rgb(0x222222);
		}

		reset = new entity.menu.ResetButton(resetProgress, game_completed);

		addLogo();

		buttons = [];
		if (Luxe.io.string_load('calibrate') != '1') {
			fadeTo('calibrate');
		} else {
			addCalibrate();
			addHarvest();
			addTrek();
			addEnd();
		}

		// Last minute, I decided not to lock progress
		// if (Luxe.io.string_load('harvest') == '1') addHarvest();
		// if (Luxe.io.string_load('trek') == '1') addTrek();
		// if (Luxe.io.string_load('end') == '1') addEnd();

		// debug mode
		// addCalibrate();
		// addHarvest();
		// addTrek();
		// addEnd();

		// debug code for me to see if progress loading is working well
		// var debug = new luxe.Text({
		// 	text: Std.string(Luxe.io.string_load('calibrate') == '1')
		// 	+ Std.string(Luxe.io.string_load('harvest') == '1')
		// 	+ Std.string(Luxe.io.string_load('trek') == '1')
		// 	+ Std.string(Luxe.io.string_load('end') == '1')
		// 	+ Std.string(Luxe.io.string_load('credits') == '1')
		// });
	}

	public function addLogo() {
		if (game_completed) {
			var logo = new luxe.Sprite({
				texture: Luxe.resources.texture('assets/logo_completed.png'),
				pos: new Vector(Main.w * 2/7, Main.h * 1/3),
			});
		} else {
			var logo = new luxe.Sprite({
				texture: Luxe.resources.texture('assets/logo.png'),
				pos: new Vector(Main.w * 2/7, Main.h * 1/3),
			});
		}
	}

	public function resetProgress() {
		Luxe.io.string_save('cycle', '1');
		Main.loadProgress();

		Luxe.io.string_save('calibrate', '0');
		Luxe.io.string_save('harvest', '0');
		Luxe.io.string_save('trek', '0');
		Luxe.io.string_save('end', '0');
		Luxe.io.string_save('credits', '0');

		fadeTo('splash');
	}

	public function addCalibrate() {
		var _label: String;
		if (Luxe.io.string_load('calibrate') == '1') {
			_label = 'calibrate.';
		} else {
			_label = 'calibrate';
		}

		var button_calibrate = new entity.menu.Button({
			name: 'button.calibrate',
			visible: false,
			pos: new Vector(Main.w * 0.65, Main.h * 1/5),
			color: new Color().rgb(0xff007b),
			label: _label
		}, function() {
			fadeTo('calibrate');
		});
		buttons.push(button_calibrate);
	}

	public function addHarvest() {
		var _label: String;
		if (Luxe.io.string_load('harvest') == '1') {
			_label = 'harvest.';
		} else {
			_label = 'harvest';
		}

		var button_harvest = new entity.menu.Button({
			name: 'button.harvest',
			visible: false,
			pos: new Vector(Main.w * 0.65, Main.h * 2/5),
			color: new Color().rgb(0x007bff),
			label: _label
		}, function() {
			Main.state.set('harvest', {
				fadeIn: true,
				showTutorial: true,
			});
		});
		buttons.push(button_harvest);
	}

	public function addTrek() {
		var _label: String;
		if (Luxe.io.string_load('trek') == '1') {
			_label = 'trek.';
		} else {
			_label = 'trek';
		}

		var button_trek = new entity.menu.Button({
			name: 'button.trek',
			visible: false,
			pos: new Vector(Main.w * 0.65, Main.h * 3/5),
			// color: new Color().rgb(0x7BFF7B),
			color: new Color().rgb(0x40826D),
			label: _label
		}, function() {
			Main.state.set('trek', false);
		});
		buttons.push(button_trek);
	}

	public function addEnd() {
		var _label: String;
		if (Luxe.io.string_load('end') == '1') {
			_label = 'insurrect.';
		} else {
			_label = 'insurrect';
		}

		var button_end = new entity.menu.Button({
			name: 'button.end',
			visible: false,
			pos: new Vector(Main.w * 0.65, Main.h * 4/5),
			color: new Color().rgb(0xFFFF7B),
			label: _label
		}, function() {
			fadeTo('end');
		});
		buttons.push(button_end);
	}

	// override public function update(dt: Float) {
	// 	// Luxe.draw.text({
	// 	// 	immediate: true,
	// 	// 	text: 'profectus.4',
	// 	// 	pos: new Vector(Main.w * 2/7, Main.h * 1/3),
	// 	// 	align: center,
	// 	// 	align_vertical: center,
	// 	// 	point_size: 96,
	// 	// 	color: new Color(),
	// 	// });
	// }

	override public function onleave<T> (_:T) {
		Luxe.timer.reset();
		Luxe.scene.empty();
		Luxe.events.clear();
	}

	override function onmousedown(e: MouseEvent) {
		for (button in buttons) {
			if (button.frame.point_inside(Luxe.camera.screen_point_to_world(e.pos))) {
				fader.fadeOut(1, button.trigger);
				// ();

			}
		}
	}

	public function fadeTo(_state: String) {
		Main.state.set(_state);
	}
}
