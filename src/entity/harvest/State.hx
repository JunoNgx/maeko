package entity.harvest;

import luxe.Sprite;
import luxe.Input;
import luxe.States;
import luxe.Color;
import luxe.Vector;
import luxe.Camera;

import luxe.tween.Actuate;

import C;

typedef HarvestArgs = {
	fadeIn: Bool,
	showTutorial: Bool
}

class State extends luxe.State {

	var fader: ui.Fader;

	var p: entity.Maeko;
	var nexus: entity.harvest.Nexus;
	var spawner: entity.harvest.Spawner;

	var counters: Array<entity.harvest.Counter>;

	override public function onenter<T> (_data:T) {

		Main.camReset();
		Main.c1 = new Color().rgb(0x007bff); // maeko, blue
		Main.c2 = new Color().rgb(0xffffff); // main core color, mostly white
		Main.c3 = new Color().rgb(0xff007b); // buttons and stuff, red
		Main.c4 = new Color().rgb(0x282828); // background, dark grey
		Main.c5 = new Color().rgb(0xffffff); // likely unused
		Luxe.renderer.clear_color = Main.c4;
		Main.addPauseKey();
		
		var argsData: HarvestArgs = cast _data; // Thanks, Sven
		if( argsData.fadeIn ) { 
			fader = new ui.Fader(0, 1);
			fader.fadeIn(0.5);
		} else {
			fader = new ui.Fader(0, 0);
		}

		if( argsData.showTutorial ) {
			spawnText();
		} else {
			spawnCycleText();
		}

		Main.listenToExplosion();

		spawnMaeko();
		spawnNexus();
		createCounters();
		
		spawner = new entity.harvest.Spawner();

		Luxe.events.listen('evolution completed', function(e) {
			win();
		});

		Luxe.events.listen('core is compromised', function(e) {
			fail();
		});
		
	}

	override public function onleave<T> (_:T) {
		Luxe.timer.reset();
		Luxe.scene.empty();
		Luxe.events.clear();

		Luxe.timescale = 1;
	}

	// ===========================================================

	public function spawnMaeko() {
		p = new entity.Maeko(6);
		p.add(new component.maeko.cannon.Triangle());
		p.add(new component.maeko.DrawAmmo6({name: 'drawammo'}));
		p.add(new component.maeko.Harvester2());
		p.moveToCenter();
	}

	public function spawnNexus() {
		nexus = new entity.harvest.Nexus();
		// Luxe.timer.schedule(2, function(){
		var t1 = new GTimer(2, function(){
			nexus.initiateElements();
		});
	}

	public function createCounters() {
		counters = [];

		for (i in 1...9) {

			var interval = C.harvest_total_time/8;

			if (i<5) {
				var t1 = new GTimer(C.counter_delay_time * i, function() {
					var counter = new entity.harvest.Counter(i);
					Luxe.audio.play('harvest_counter_holder_thump');
				});
				var t2 = new GTimer(interval * i, function() {
					var counterCore = new entity.harvest.CounterCore(i);
					Luxe.audio.play('harvest_counter');
				});
			} else {
				var t1 = new GTimer(C.counter_delay_time * i, function() {
					var counterCore = new entity.harvest.Counter(i + 2);
					Luxe.audio.play('harvest_counter_holder_thump');
				});
				var t2 = new GTimer(interval * i, function() {
					var counterCore = new entity.harvest.CounterCore(i + 2);
					Luxe.audio.play('harvest_counter');
				});
			} // if else
		}

		var wintimer = new GTimer(C.harvest_total_time + 1, function() {
			Luxe.events.fire('evolution completed');
		});
	}

	function spawnText() {

		var t1 = new GTimer(2, function() {
			var tutorText1 = new entity.FadingText('touch to shoot', 5, 0.2);
		});

		var t2 = new GTimer(4, function() {
			var tutorText2 = new entity.FadingText('take shelter', 5, 0.6);
		});
	}

	function spawnCycleText() {
		var t = new GTimer(2, function() {
			var cycle = new entity.FadingText('cycle ' + Main.p_cycle, 3, 0.6);
		});
	}

	public function win() {
		Main.removePauseKey();
		spawner.stopSpawning();

		var waveTime = 1;
		var t1 = new GTimer(waveTime, function(){
			for (i in 0...7) {
				var t2 = new GTimer(i * 0.01, function() {
					var wave = new entity.harvest.SonicWave();
				});
			}
			Luxe.audio.play('sonicwave');
		});

		var killDelay = 0.5;
		var t1 = new GTimer(waveTime + killDelay, function(){
			var entities: Array<luxe.Entity> = [];
			Luxe.scene.get_named_like('karl', entities);
			for (ent in entities) {
				var karl: entity.harvest.Karl = cast ent;
				karl.hit();
			}
			Luxe.camera.shake(500);
		});

		var focusSwitchTime = 5;
		var t2 = new GTimer(waveTime + killDelay + focusSwitchTime, function(){
			Luxe.camera.focus(new Vector(Main.w/2, -Main.h/2 - 100)); // Too lazy to write something proper here
			p.destroy();

			// Record winning status progress
			Luxe.io.string_save('harvest', '1');
			
			// TODO change color here	
			var t3 = new GTimer(4, function(){
				var wheel = new entity.harvest.Wheel(switchToTrek);
			});
		});
	}

	public function switchToTrek() {
		Main.state.set('trek', false);
	}

	public function fail() {
		Main.updateCycleCount();
		
		p.get('accel').deactivate();

		Luxe.timer.reset();
		Main.clearEntitiesNamed('gTimer');
		Luxe.audio.play('core_compromised');
		
		Luxe.timescale = 0;
		Actuate.pauseAll();
		Actuate.reset();

		// var twTime = Actuate.tween(Luxe, 0.5, {timescale: 0});
		// Actuate.resume(twTime); // works on Web, but somehow doesn't work on Android
		var twZoom = Actuate.tween(Luxe.camera, 1, {zoom: 3}).delay(1);
		Actuate.resume(twZoom);
		var twFocu = Actuate.tween(Luxe.camera.view.center, 1, {y: Main.h * 4/5}).delay(1);
		Actuate.resume(twFocu);

		Luxe.timer.schedule(5, function(){ // use luxe.timer because timescale has been frozen

			var failedSpectacularly:Bool = (spawner.lifetime < C.harvest_timemark_2); // fail spectacularly, showing tutorial texts again if true

			Main.state.set('harvest', {
				fadeIn: true,
				showTutorial: failedSpectacularly,
			});
		});
	}

	override function update( dt:Float ) {
        //don't update if paused
        if(Main.state.enabled('pause')) return;
    }

	// override function onkeyup( e:KeyEvent ) {
	// 	//escape from the game at any time, mostly for debugging purpose
	// 	if(e.keycode == Key.space) {
	// 		// Actuate.tween(Luxe, 0.1, {timescale: 0.2});
	// 		// Luxe.timer.reset();
	// 		fail();
	// 	}
	// }
}