package component.nexus;

import luxe.Component;
import luxe.options.ComponentOptions;

import luxe.Vector;
import luxe.Color;

import luxe.tween.Actuate;

import C;

class Core extends Component {

	public var growTime: Float = C.core_grow_time;
	public var radius: Float = 1;

	override public function new(_options: ComponentOptions) {
		super(_options);

		Actuate.tween(this, growTime, {radius: 12});
	}

	override public function update(dt: Float) {
		var host: luxe.Sprite = cast entity;

		Luxe.draw.circle({
			immediate: true,
			x: this.pos.x,
			y: this.pos.y,
			r: this.radius,
			color: Main.c3.clone(),
		});
	}

	public function getOut() {
		Actuate.tween(this, growTime, {radius: 0}).delay(1).onComplete(function(){
			entity.events.fire('elements withdrawn');
		});
	}
}