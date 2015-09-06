package entity.calibrate;

import luxe.Color;
import luxe.Vector;

import luxe.tween.Actuate;

import C;

class Seed extends luxe.Sprite {

	public var growTime: Float = C.nexus_grow_time; // durations of tween
	public var delayTime: Float = C.nexus_delay_time; // delay between phases of growing after being pressed


	public var radius: Float = 64;

	public var elemented: Bool = false; // elements are awakened and fed
	public var element_level: Int = 0;


	override public function new() {
		super({
			name: 'seed',
			name_unique: true,
			pos: new Vector(Main.w/2, Main.h/4),
			visible: false,
			color: Main.c3.clone(),
		});

		this.add( new component.Hitbox( {
			name: 'hitbox',
			body: luxe.collision.shapes.Polygon.create(pos.x, pos.y, 3, this.radius),
		}));

		this.add( new component.nexus.Pressor(C.nexus_pressor_time, growRotation));

		waitForElementWithdraw();
	}

	override public function update(dt: Float) {

		Luxe.draw.ngon({
			immediate: true,
			solid: false,
			sides: 3,
			r: this.radius,
			x: this.pos.x,
			y: this.pos.y,
			color: this.color,
			angle: -this.rotation_z,
			depth: -1,
		});

		if (this.get('pressor').showIndicator) {
			Luxe.draw.ngon({
				immediate: true,
				solid: false,
				sides: 3,
				r: this.radius + C.element_radius_indicator_extra,
				x: this.pos.x,
				y: this.pos.y,
				color: Main.c2.clone(),
				angle: -this.rotation_z,
				depth: -1,
			});		
		}

		if (!elemented && element_level == 3) {
			elemented = true;

			Luxe.events.fire('elementation.completed');
		}

	}

	public function growRotation(): Void {
		Luxe.audio.play('calibrate_seed');
		Actuate.tween(this, growTime, {rotation_z: C.nexus_grown_rotation}).onComplete(growSize);
	}

	public function growSize() {
		Actuate.tween(this, growTime, {radius: C.nexus_grown_radius}).delay(delayTime).onComplete(growPosition);
	}

	public function growPosition() {
		Luxe.audio.play('calibrate_grow');
		Actuate.tween(this.pos, growTime, {y: Main.h * 2/3}).delay(delayTime).onComplete(function(){
			Luxe.events.fire('the seed has grown');
		});
	}

	// Phase 2
	// public function addCore() {
	// 	coreAdded = true;
	// }

	// Phase 3
	function waitForElementWithdraw() {
		this.events.listen('elements withdrawn', function(e){
			getPositionReady();
		});
	}

	public function withdrawElements() {
		this.get('element.triangle').outOrbit();
		this.get('element.square').outOrbit();
		this.get('element.circle').outOrbit();

		this.get('core').getOut();
	}

	public function getPositionReady() {
		Actuate.tween(this.pos, growTime, {y: Main.h * 4/5});
	}

	
}