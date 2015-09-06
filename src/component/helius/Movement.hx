package component.helius;

import luxe.Component;
import luxe.options.ComponentOptions;

import luxe.Vector;
import luxe.Color;

// import luxe.collision.Collision;
import luxe.tween.Actuate;
import luxe.tween.actuators.GenericActuator;

import C;

class Movement extends Component {

	public var erratus: IGenericActuator;
	public var onLeft: Bool = true;

	public var maeko_pos: Vector;

	override public function new() {
		super({
			name: 'mover'
		});

		// retrieve player's position and store in variable when announced
		Luxe.events.listen('sending maeko position', function(e: MaekoPosEvent){
			maeko_pos = e.pos;
		});
		Luxe.events.fire('request maeko position'); // get the first position to prevent nullification
	}

	public function stop() {
		Actuate.pause(this.erratus);
	}

	public function erraMidStart() {
		var des_x: Float = 640; // assignment for debug purpose
		if (onLeft) {
			des_x = Luxe.utils.random.float(0, 320);
			onLeft = false;
		} else {
			des_x = Luxe.utils.random.float(Main.w - 320, Main.w);
			onLeft = true;
		}

		var des_y = Luxe.utils.random.float(0, Main.h/3);
		var distance = Math.sqrt((des_x - entity.pos.x) * (des_x - entity.pos.x) + (des_y - entity.pos.y) * (des_y - entity.pos.y));
		var time = distance / 300; // 700 pixels per second

		erratus = Actuate.tween(entity.pos, time, {x: des_x, y: des_y})
			.delay(0.5)
			.onComplete(erraMidStart);
	}

	public function erraTopStart() {

		Luxe.events.fire('request maeko position');
		var des_x: Float = maeko_pos.x;

		erratus = Actuate.tween(entity.pos, 0.5, {x: des_x, y: 32})
			.delay(1)
			.ease(luxe.tween.easing.Quad.easeInOut)
			.onComplete(function(){
				entity.get('barrier').deactivate();
				entity.get('railgun').fire(90);
				erraTopStart();
			});
	}

	public function goToBottom() {
		Actuate.tween(entity.pos, 0.5, {x: 32, y: Main.h - 32})
			.onComplete(function(){
				entity.get('barrier').deactivate();
				destructBottom();
			});
	}

	public function destructBottom() {
	
		// Fire railgun 16 times with half a second apart each
		for (i in 0...26) {
			var timer = new GTimer(i * 0.3, function(){
				entity.get('railgun').fire(-90);
			});
		}

		erratus = Actuate.tween(entity.pos, 8, {x: Main.w - 96, y: Main.h - 64})
			.ease(luxe.tween.easing.Quad.easeOut)
			.onComplete(function(){
				
				Luxe.events.fire('effect.explosion.large', {pos: entity.pos});
				Luxe.camera.shake(200);
				Luxe.audio.play('helius_destroy');
				entity.destroy();

				Luxe.events.fire('helius destroyed');

			});
	}

	public function centralize() {
		Actuate.tween(entity.pos, 0.7, {x: Main.w/2, y: Main.h * 1/4}).delay(1);
	}

}

typedef MaekoPosEvent = {
	pos: Vector
}