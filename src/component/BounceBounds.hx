package component;

import luxe.Component;
import luxe.options.ComponentOptions;

typedef BounceBoundsOptions = {
	> ComponentOptions,

	@:optional var top: Int;
	@:optional var bottom: Int;
	@:optional var left: Int;
	@:optional var right: Int;
}

class BounceBounds extends Component {

	// public var dir_x: Float;
	// public var dir_y: Float;

	var top: Int;
	var bottom: Int;
	var left: Int;
	var right: Int;

	public function new(_options:BounceBoundsOptions) {
		super(_options);

		this.top 		= ( _options.top != null ) 		? _options.top 		: 0;
		this.bottom 	= ( _options.bottom != null ) 	? _options.bottom 	: Main.h;
		this.left 		= ( _options.left != null ) 	? _options.left 	: 0;
		this.right 		= ( _options.right != null ) 	? _options.right 	: Main.w;
	}

	override function update(dt: Float) {
		var velocity = entity.get('velocity');

		if (entity.pos.x > this.right || entity.pos.x < this.left) velocity.x *= -1;
		if (entity.pos.y > this.bottom || entity.pos.y < this.top) velocity.y *= -1;
	}

}