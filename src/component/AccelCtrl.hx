package component;

import luxe.Component;
import luxe.options.ComponentOptions;

import C;

typedef AccelAxis = {
	var x: Float;
	var y: Float;
	var z: Float;
}

class AccelCtrl extends Component {
	
	// public var x: Float;
	// public var y: Float;

	public var x: Float = 0.0;
	public var y: Float = 0.0;
	public var z: Float = 0.0;

	public override function new(_options:ComponentOptions) {
		super(_options);

		Luxe.events.listen('accelAxis', function(e: AccelAxis){
			this.x = e.x;
			this.y = e.y;
			this.z = e.z;
		});
		trace('Accel control added');
		
	}

	// override public function onadded() {
	// 	Luxe.events.listen('accelAxis', function(e: AccelAxis){
	// 		this.x = e.x;
	// 		this.y = e.y;
	// 		this.z = e.z;
	// 	});
	// 	trace('Accel control added');
	// }

	override function update(dt: Float) {
		var velocity = entity.get('velocity');

		velocity.x = this.x * C.player_speed;
		velocity.y = this.y * C.player_speed;
	}
	
	// override function update(dt: Float) {
	// 	pos.x += this.x * dt;
	// 	pos.y += this.y * dt;
	// }
	
}

