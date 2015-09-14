package component.helius;

import luxe.Component;
import luxe.options.ComponentOptions;

import luxe.Vector;
import luxe.Color;

import luxe.tween.Actuate;

import C;

class Railgun extends Component {

	override public function new() {
		super({
			name: 'railgun'
		});
	}

	public function fire(_degree: Float) {
		var host: luxe.Sprite = cast entity;
		var rail = new entity.end.Rail(host, _degree);

		Luxe.audio.play('helius_railgun');
	}
}