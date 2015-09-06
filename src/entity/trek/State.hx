package entity.trek;

import luxe.Sprite;
import luxe.Input;
import luxe.States;
import luxe.Color;
import luxe.Vector;
import luxe.Camera;
import luxe.Text;

import luxe.collision.Collision;
import luxe.tween.Actuate;

// import snow.types.Types;

import C;

class State extends luxe.State {

	var fader: ui.Fader;

	var muzzleflash: crew.Muzzleflash;
	var spawner: entity.trek.Spawner;

	var p: entity.Maeko;
	var helipad: entity.trek.Helipad;

	public static var debug: Text;

	override public function onenter<T> (_isReset:T) {

		Main.camReset();
		Main.c1 = new Color().rgb(0xACD85C); // maeko & ayu
		Main.c2 = new Color().rgb(0xffffff); // particles & ammo
		Main.c3 = new Color().rgb(0x555555); // krist & esth & hessel
		Main.c4 = new Color().rgb(0x549189); // background, green
		// Main.c4 = new Color().rgb(0xA6E6C4); // background, green
		// Main.c5 = new Color().rgb(0xB1586A); // maroon, helipad
		Main.c5 = new Color().rgb(0xA6E6C4); // lighter green, helistar
		Luxe.renderer.clear_color = Main.c4;
		Main.addPauseKey();

		spawnHelipad();
		spawnHelistar();
		fader = new ui.Fader(0, 1);
		fader.fadeIn(1, function() {
			spawnMaeko();
			if (!(cast _isReset: Bool)) {
				spawnText();
			} else spawnCycleText();
			Luxe.audio.loop('trek_bgm');
		});

		setupProgressNotification();
		
		debug = new Text({});

		getReadyCrew( );
		spawner = new entity.trek.Spawner();

		Luxe.events.listen('trek completed', function(e){
			win();
		});

		Luxe.events.listen('maeko is doomed', function(e){
			fail();
		});
	}

	function spawnMaeko() {
		p = new entity.Maeko(8);
		// p.pos = new Vector(Main.w/2, Main.h * 3/2);
		Actuate.tween(p.pos, 1, {y: Main.h/2}).onComplete(function(){
			p.add(new component.maeko.cannon.Square());
			p.add (new component.maeko.DrawAmmo8({
				name: 'drawammo'
			}));
			p.add( new component.maeko.Harvester({
				name: 'harvester'
			}));
			p.addKeepBounds();
		});
	}

	function spawnHelipad() {
		helipad = new entity.trek.Helipad();
	}

	function spawnHelistar() {
		for (i in 0...10) {
			var heli = new entity.trek.Helistar();
		}
	}

	function getReadyCrew() {
		muzzleflash = new crew.Muzzleflash();
		
		Luxe.events.listen('effect.flash', function(_e: FlashEvent) {
			muzzleflash.flash(_e.pos, _e.dir);
		});

		Main.listenToExplosion();
	}

	function spawnText() {

		var t1 = new GTimer(2, function() {
			var tutorText1 = new entity.FadingText('cross', 5, 0.3);
		});

		var t2 = new GTimer(4, function() {
			var tutorText2 = new entity.FadingText('survive', 5, 0.7);
		});
	}

	function spawnCycleText() {
		var t = new GTimer(2, function() {
			var cycle = new entity.FadingText('cycle ' + Main.p_cycle, 3, 0.7);
		});
	}

	function setupProgressNotification() {
		var t1 = new GTimer(C.trek_timemark1, function() {
			var progress1 = new entity.FadingText('making progress');
			Luxe.audio.play('trek_progress');
		});

		var t2 = new GTimer(C.trek_timemark2, function() {
			var progress2 = new entity.FadingText('almost there');
			Luxe.audio.play('trek_progress');
		});
	}

	function win() {
		Main.removePauseKey();
		Luxe.audio.play('trek_progress');
		
		p.remove('bounds.keep');

		Actuate.tween(p.pos, 2, {y: -Main.h * 1/2})
			.onComplete(function(){
				// p.destroy();
				p.get('accel').deactivate();
				spawner.stopSpawning();

				var tim = new GTimer(4, function(){
					Luxe.audio.stop('trek_bgm');

					// Record winning status progress
					Luxe.io.string_save('trek', '1');

					var wheel = new entity.trek.Wheel(function(){
						fader.fadeOut(2, switchToEnd);
					});
				});
			});
	}

	public function switchToEnd() {
		Main.state.set('end');
		Luxe.audio.stop('trek_bgm');
	}

	function fail() {
		Main.updateCycleCount();
		Luxe.audio.stop('trek_bgm');
		Luxe.audio.play('maeko_destroy');

		var t = new GTimer(3, function(){
			Main.state.set('trek', true);
		});
		
	}

	override public function onleave<T> (_:T) {
		Luxe.timer.reset();
		Luxe.scene.empty();
		Luxe.events.clear();

		Actuate.reset();
		Luxe.audio.stop('trek_bgm');
	}

	override function update( dt:Float ) {
        //don't update if paused
        if(Main.state.enabled('pause')) return;
    }
}


typedef FlashEvent = {
	pos: Vector,
	dir: Float,
}

typedef ValueEvent = {
	value: Float
}