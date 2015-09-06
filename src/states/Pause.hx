package states;
import luxe.Sprite;
import luxe.Input;
import luxe.States;
import luxe.Color;
import luxe.Vector;
import luxe.Camera;

import luxe.tween.Actuate;

import C;

class Pause extends State {

	public var background: Sprite;

	public var resume: entity.menu.Button;
	public var quit: entity.menu.Button;

	override public function onenabled<T> (_:T) {
		Main.camReset();
		
		background = new Sprite({
			pos: new Vector(Main.w/2, Main.h/2),
			color: new Color(0, 0, 0, 0.77),
			size: new Vector(Main.w, Main.h),
			depth: 20,
		});

		Luxe.timescale = 0;
		Actuate.pauseAll();

		addButtons();
	}

	function addButtons() {

		resume = new entity.menu.Button({
			name: 'button.resume',
			visible: false,
			pos: new Vector(Main.w * 0.65, Main.h * 0.3),
			color: new Color(1, 1, 1),
			label: 'resume',
			depth: 22,
		}, function() {
			Main.state.disable('pause');
		});

		quit = new entity.menu.Button({
			name: 'button.quit',
			visible: false,
			pos: new Vector(Main.w * 0.65, Main.h * 0.7),
			label: 'leave',
			depth: 22,
		}, function() {
			Main.state.disable('pause');
			Main.state.set('menu');
		});

	}

	override function onmouseup(e: MouseEvent) {
		// warning: hacky and clunky codes ahead
		if (resume.frame.point_inside(Luxe.camera.screen_point_to_world(e.pos))) {
			resume.trigger();
		}

		if (quit.frame.point_inside(Luxe.camera.screen_point_to_world(e.pos))) {
			quit.trigger();
		}
	}

	override public function ondisabled<T> (_:T) {
		resume.destroy();
		quit.destroy();
		background.destroy();

		Luxe.timescale = 1;
		Actuate.resumeAll();
	}

	// override function onkeyup( e:KeyEvent ) {

 //        if(Luxe.time < 1) return;

 //            //escape resumes the game by
 //            //disabling the pause state
 //        if(e.keycode == Key.space) {
 //            Main.state.disable('pause');
 //        }

 //    } //onkeyup

}
