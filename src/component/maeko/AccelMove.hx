package component.maeko;

import luxe.Component;
import luxe.options.ComponentOptions;

import luxe.Vector;
import luxe.tween.Actuate;

import C;

class AccelMove extends Component {

	public var isActive:Bool = true;

	public var offset_x: Float;
	public var offset_y: Float;

	override function update(dt: Float) {
		if (isActive) {
	
			var host: entity.Maeko = cast entity;

			offset_x = Main.accel_x - Main.center.x;
			if (offset_x < -0.5) offset_x = -0.5;
			if (offset_x > 0.5) offset_x = 0.5;

			offset_y = Main.accel_y - Main.center.y;
			if (offset_y < -0.5) offset_y = -0.5;
			if (offset_y > 0.5) offset_y = 0.5;

			host.velocity.x = offset_x * C.player_speed;
			host.velocity.y = offset_y * C.player_speed;

			if (!Main.state.enabled('pause')) Actuate.tween(host, 0.05, {radians : -Math.PI/2 + offset_x * Math.PI/2});
		}

	}

	public function deactivate() {
		isActive = false;
		
		var host: entity.Maeko = cast entity;
		host.velocity.x = 0;
		host.velocity.y = 0;
	}

	public function activate() {
		isActive = true;
	}
	
}

