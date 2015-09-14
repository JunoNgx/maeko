package entity.end;

import luxe.Sprite;
import luxe.Color;
import luxe.Vector;

import luxe.tween.Actuate;

import C;

class Helius extends Sprite {

	public var hitbox: component.Hitbox;
	public var barrier: component.helius.Barrier;
	public var sharkus: component.helius.Sharkus;
	public var railgun: component.helius.Railgun;
	public var mover: component.helius.Movement;
	public var engine: component.helius.AudioEngine;

	public var hp: Int = 4;
	public var isVulnerable: Bool = false;

	public var radius: Float = 24;
	public var radius_ex: Float =  12;

	public var stopTrigger: GTimer; // to stop certain process

	override public function new() {
		super({
			name: 'helius',
			name_unique: true,
			pos: new Vector(Main.w/2, Main.h * -1/2),
			visible: false,
			color: Main.c3.clone(),
			rotation_z: 180,
		});

		// components
		hitbox = new component.Hitbox({
			name: 'hitbox',
			body: luxe.collision.shapes.Polygon.create(pos.x, pos.y, 3, this.radius),
		});
		this.add(hitbox);

		barrier = new component.helius.Barrier();
		this.add(barrier);

		railgun = new component.helius.Railgun();
		this.add(railgun);

		mover = new component.helius.Movement();
		this.add(mover);

		engine = new component.helius.AudioEngine();
		this.add(engine);

		this.add(new component.helius.Lukas());

		// behaviour
		this.events.listen('sharkus destroyed', function(e){
			engine.stop();
			this.goBeserk();
		});
	}

	public function barrageFire() {

		summonSharkus();
		mover.erraMidStart();

		var barrageTimer = new GTimer(C.barrageFire_delay, function(){

			if (hp > 2) {
				var shooting = new GTimer(0.2, sharkus.startShard);
				stopTrigger = new GTimer (C.barrage_time, function(){
					sharkus.stopShard();
					returnAndPrepare();
				});
			} else {
				var shooting = new GTimer(0.2, sharkus.startChunk);
				stopTrigger = new GTimer (C.barrage_time, function(){
					sharkus.stopChunk();
					returnAndPrepare();
				});
			}

		});

	}

	public function summonSharkus() {

		if (this.has('sharkus')) {
			sharkus.removeArm();
			stopTrigger = new GTimer(1, function(){
				sharkus = new component.helius.Sharkus();
				this.add(sharkus);
			});
		} else {
			sharkus = new component.helius.Sharkus();
			this.add(sharkus);
		}

	}

	public function goBeserk() {

		barrier.deactivate();
		// if (stopTrigger != null) stopTrigger.destroy();

		isVulnerable = true;
		mover.erraTopStart();

		stopTrigger = new GTimer (C.barrage_time_railtop, function(){
			Actuate.pause( this.mover.erratus);	

			returnAndPrepare();

			// var timerGo = new GTimer(2, function() {
			// 	returnAndPrepare();
			// });
		});
	}

	public function hit() {
		
		Luxe.audio.play('helius_hit');
		Luxe.camera.shake(200);
		Luxe.events.fire('effect.explosion.large', {pos: this.pos});
		this.hp -= 1;

		isVulnerable = false;
		if (stopTrigger != null) stopTrigger.destroy();

		Actuate.pause(mover.erratus);
		var retu = new GTimer(2, returnAndPrepare);
	}

	public function returnAndPrepare() {

		if (hp > 0) {
			mover.centralize();
			barrier.activate();
			engine.playNow();

			var timerShark = new GTimer(3, function(){
				barrageFire();
			});
		} else {
			mover.goToBottom(); // trigger the end of the game
		}
		
	}

	override public function update(dt: Float) {

		Luxe.draw.ngon({
			immediate: true,
			solid: true,
			sides: 3,
			r: this.radius,
			x: this.pos.x,
			y: this.pos.y,
			color: this.color,
			angle: -this.rotation_z,
			depth: -1,
		});

		Luxe.draw.ngon({
			immediate: true,
			solid: false,
			sides: 3,
			r: this.radius + this.radius_ex,
			x: this.pos.x,
			y: this.pos.y,
			color: this.color,
			angle: -this.rotation_z,
			depth: -1,
		});
	}
}