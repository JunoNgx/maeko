package ui;

import luxe.Color;
import luxe.Vector;
import luxe.Entity;

import luxe.tween.Actuate;

class ProxBar extends Entity {

	public static var length_max: Float = 1200;
	public static var value_max: Float = 90;

	public var length: Float;
	public var value: Float;
	public var fillRate: Float;

	public var decre: Bool = true;

	public function new(_options: luxe.options.EntityOptions) {
		super(_options);

		value = 0;
	}

	override public function update(dt: Float) {
		if (value > value_max) value = value_max;
		if (value < 0) value = 0;
		fillRate = value / value_max;
		length = length_max * fillRate;

		if (decre) value -= dt; // constantly decreasing value when true

		Luxe.draw.box({
			x: 40, y: 20,
			h: 5, w: length,
			color: new Color().rgb(0x00f67b),
			immediate: true,
			depth: 100,
		});
	}

	public function addlength(_value: Float) {
		decre = false; // stop manually decreasing for tweening
		Actuate.tween(this, 0.5, {value: value + _value})
			.onComplete(function() {this.decre = true;});
	}

}