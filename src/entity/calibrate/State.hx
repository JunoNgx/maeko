package entity.calibrate;

import luxe.Sprite;
import luxe.Input;
import luxe.States;
import luxe.Color;
import luxe.Vector;
import luxe.Camera;
import luxe.Text;

import luxe.tween.Actuate;

import C;

class State extends luxe.State {

	var fader: ui.Fader;

	var p: entity.Maeko;
	var nexus: entity.calibrate.Seed;

	override public function onenter<T> (_:T) {

		Main.camReset();
		Main.c1 = new Color().rgb(0x007bff); // maeko, blue
		Main.c2 = new Color().rgb(0xffffff); // main core color, mostly white
		Main.c3 = new Color().rgb(0xff007b); // buttons and stuff, red
		Main.c4 = new Color().rgb(0x282828); // background, dark grey
		Main.c5 = new Color().rgb(0xffffff); // likely unused
		Luxe.renderer.clear_color = Main.c4;
		
		fader = new ui.Fader(0, 1);
		fader.fadeIn(1, function(){
			spawnMaeko();
			spawnNexus();
			spawnText();
		});

		// Phase 1: grow the seed
		Luxe.events.listen('the seed has grown', function(e) {
			createElements();
			nexus.add(new component.nexus.Core({
				name: 'core',
			}));
		});

		// Phase 2: activate the elements
		Luxe.events.listen('add.element.triangle', function(e) {
			nexus.add(new component.nexus.Element({
				name: 'element.triangle',
				type: 'triangle',
			}));
			Luxe.audio.play('calibrate_element_pickup1');
			nexus.element_level += 1;
		});

		Luxe.events.listen('add.element.square', function(e) {
			nexus.add(new component.nexus.Element({
				name: 'element.square',
				type: 'square',
			}));
			Luxe.audio.play('calibrate_element_pickup2');
			nexus.element_level += 1;
		});

		Luxe.events.listen('add.element.circle', function(e) {
			nexus.add(new component.nexus.Element({
				name: 'element.circle',
				type: 'circle',
			}));
			Luxe.audio.play('calibrate_element_pickup3');
			nexus.element_level += 1;
		});

		// Phase 3: elementation completed, kill Maeko, move the nexus, and run states.Harvest
		Luxe.events.listen('elementation.completed', function(e) {
			// Luxe.timer.schedule(2, nexus.withdrawElements);
			var timer = new GTimer(2, nexus.withdrawElements);

			Luxe.audio.play('calibrate_completed');
			// Record winning status progress
			Luxe.io.string_save('calibrate', '1');

			Actuate.tween(p.pos, 2.4, {y: Main.h * 3/2}).delay(10).onComplete(function(){
				p.destroy();
				switchToHarvest();
				// Luxe.audio.play('calibrate_completed2');
			});

		// Actuate.tween(p.color, 3, {a:0}).delay(1).onComplete(function(){
		// 		p.destroy();
		// 		switchToHarvest();
		// 	});

		});
	}

	override public function onleave<T> (_:T) {
		Luxe.timer.reset();
		Luxe.scene.empty();
		Luxe.events.clear();
	}

	function spawnMaeko() {
		p = new entity.Maeko(0);
		p.add (new component.maeko.Calibrator());
		p.addKeepBounds();
		p.pos = new Vector(Main.w/2, Main.h/2);
	}

	function spawnNexus() {
		nexus = new entity.calibrate.Seed( );
	}

	function spawnText() {

		var t1 = new GTimer(1, function() {
			var tutorText1 = new entity.FadingText('tilt to move', 7, 0.4);
			trace('created tilt to move');
		});

		var t2 = new GTimer(3, function() {
			var tutorText2 = new entity.FadingText('touch to calibrate', 7, 0.6);
			trace('created touch to calibrate');
		});
		
	}

	function createElements(){
		Luxe.audio.play('calibrate_element_spawn');

		var tria = new entity.calibrate.element.Triangle();
		var squa = new entity.calibrate.element.Square();
		var circ = new entity.calibrate.element.Circle();
	}

	function switchToHarvest() {
		Main.state.set('harvest', {
			fadeIn: false,
			showTutorial: true,
		});
	}

	override function update( dt:Float ) {
        //don't update if paused
        if(Main.state.enabled('pause')) return;
    }

}
