package entity.end;

import luxe.Sprite;
import luxe.Input;
import luxe.States;
import luxe.Color;
import luxe.Vector;
import luxe.Camera;

import luxe.collision.Collision;
import luxe.tween.Actuate;

import C;

class State extends luxe.State {

	var muzzleflash: crew.Muzzleflash;
	var fader: ui.Fader;

	var p: entity.Maeko;
	var sol: entity.end.Helius;

	override public function onenter<T> (_:T) {
		
		Main.camReset();
		Main.c1 = new Color().rgb(0xace1af); // celadon, maeko & barrier
		Main.c2 = new Color().rgb(0x555555); // gray, particles
		Main.c3 = new Color().rgb(0xffffff); // white, helius & bullets
		Main.c4 = new Color().rgb(0xff007b); // background, maroon, this intense color is for artistic purpose
		// Main.c4 = new Color().rgb(0x111111); // background, grey, for debug and less eyeache
		Main.c5 = new Color().rgb(0xd7004f); // background decorative, decorative particles
		Luxe.renderer.clear_color = Main.c4;
		Main.addPauseKey();
		fader = new ui.Fader(0, 1);

		if (Luxe.utils.random.bool(0.3)) spawnCycleText();

		getReadyCrew();
		setupCommunication();
		createBeaters();

		fader.fadeIn(1, function(){
			spawnMaeko();
			spawnHelios();
		});

		Luxe.events.listen('helius destroyed', function(e){
			win();
		});

		Luxe.events.listen('maeko is doomed', function(e){
			fail();
		});
	}

	function getReadyCrew() {
		muzzleflash = new crew.Muzzleflash();

		Luxe.events.listen('effect.flash', function(_e: EndFlashEvent) {
			muzzleflash.flash(_e.pos, _e.dir);
		});

		Main.listenToExplosion();
	}

	function setupCommunication() {
		Luxe.events.listen('request maeko position', function(e){
			Luxe.events.fire('sending maeko position', {pos: p.pos});
		});
	}

	function spawnMaeko() {
		p = new entity.Maeko(9);
		// p.remove('accel');
		p.add(new component.maeko.cannon.Circle());
		p.add(new component.maeko.DrawAmmo9({name: 'drawammo'}));
		Actuate.tween(p.pos, 3, {y: Main.h * 3/4}).onComplete(function(){
			p.addKeepBounds();
			// p.add(new component.maeko.AccelMove({name: 'accel'}));
		});
	}

	function spawnHelios() {
		sol = new entity.end.Helius();
		Actuate.tween(sol.pos, 3, {y: Main.h * 1/4}).onComplete(function(){
			sol.barrier.activate();
			var tim = new GTimer(2, function(){
				sol.barrageFire();
			});
		});
	}

	function spawnCycleText() {
		var t = new GTimer(2, function() {
			var cycle = new entity.FadingText('cycle ' + Main.p_cycle, 3, 0.6);
		});
	}


	function createBeaters(){
		// the background fluctuating squares
		// scenery, serving as decoration to create an industrial-atmosphere
		var easeOptions = [
			// luxe.tween.easing.Back.easeInOut,
			luxe.tween.easing.Bounce.easeOut,
			luxe.tween.easing.Cubic.easeInOut,
			luxe.tween.easing.Elastic.easeIn,
			// luxe.tween.easing.Elastic.easeOut,
			// luxe.tween.easing.Elastic.easeInOut,
			luxe.tween.easing.Expo.easeIn,
			luxe.tween.easing.Quad.easeIn,
			// luxe.tween.easing.Quad.easeOut,
			// luxe.tween.easing.Quad.easeInOut,
			luxe.tween.easing.Sine.easeIn,
			luxe.tween.easing.Quint.easeIn,
			// luxe.tween.easing.Sine.easeInOut,
		];

		var amt = 8;
		for (i in 0...amt) {
			var beater = new Sprite({
				size: new Vector(48, 48),
				pos: new Vector(Main.w * (i+1)/(amt+1), Main.h * 1/4),
				color: Main.c5.clone(),
				depth: -10
			});

			Actuate.tween(beater.pos, Math.random() + 0.5, {y: Main.h * 3/4})
				.delay(Math.random() + 1)
				.repeat()
				.reflect()
				.ease(easeOptions[Luxe.utils.random.int(0, easeOptions.length)]);
		}
	}

	function win() {
		Main.removePauseKey();
		var t = new GTimer(3, outro);
	}

	function fail() {
		Main.updateCycleCount();
		Luxe.audio.play('maeko_destroy');

		var t = new GTimer(3, function(){
			Main.state.set('end');
		});
	}

	function outro() {
		// TODO stop music

		var grey = new Color().rgb(0x222222);
		Main.c4.tween(1, {r: grey.r, g: grey.g, b: grey.b});
		var pb = new Color().rgb(0x007bff); // primitive blue, from earlier chapters
		p.color.tween(1, {r: pb.r, g: pb.g, b: pb.b});

		Luxe.camera.focus(new Vector(Main.w/2, -Main.h/2));

		p.get('accel').deactivate();
		p.remove('accel');
		p.remove('drawammo');
		p.remove('bounds.keep');
		p.remove('cannon');
		p.velocity.x = 0;
		p.velocity.y = 0;
		p.radians = -Math.PI/2;

		Actuate.tween(p.pos, 3, {x: Main.w/2, y: -Main.h * 1/4}).delay(1.5)
			.onComplete(function(){
				summonCourt();

				Actuate.tween(p, 1, {radians: -Math.PI/2}); // workaround hack, too tired
			});
	}

	function summonCourt() {

		// Record winning status progress
		Luxe.io.string_save('end', '1');

		var wheel = new entity.end.Wheel();

		for (i in 0...4) {
			Luxe.timer.schedule(1.5 * i, function(){
				var prae1 = new entity.end.Praetorian(1);
				Actuate.tween(prae1.pos, 1.5, {y: -Main.h * (i+1)/5}).delay(0.5);

				var prae2 = new entity.end.Praetorian(2);
				Actuate.tween(prae2.pos, 1.5, {y: -Main.h * (i+1)/5}).delay(0.5);
			});
		}

		// summon Preatorian chief
		Luxe.timer.schedule(7, function(){
			var prae = new entity.end.Praetorian(3);
			Actuate.tween(prae.pos, 3, {y: -Main.h * 3/4})
				.onComplete(function(){
					Luxe.audio.play('end_praetorian_chief');

					Luxe.timer.schedule(6, function(){
						
						switchCredits();
						Luxe.audio.play('end_dramatic');
					});
				});
		});
	}

	function switchCredits() {
		Main.state.set('credits');
	}

	override public function onleave<T> (_:T) {
		Luxe.timer.reset();
		Luxe.scene.empty();
		Luxe.events.clear();

		Actuate.reset();
	}

	override function update( dt:Float ) {
        //don't update if paused
        if(Main.state.enabled('pause')) return;
    }
}

typedef EndFlashEvent = {
	pos: Vector,
	dir: Float,
}