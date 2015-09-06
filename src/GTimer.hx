package;

// An utility class that acts alternatively to luxe.Timer
// utilising luxe.Entity for a more Luxe.timescale dependant
// timer

class GTimer extends luxe.Entity {

	public var cooldown: Float;
	public var cooldown_max: Float;
	public var event: Void->Void;
	public var count: Int;

	override public function new(_duration: Float, _event:Void->Void, ?_count:Int) {
		super({
			name: 'gTimer',
			name_unique: true,
			scene: Luxe.scene,
		});

		cooldown_max = _duration;
		event = _event;
		count = (_count == null) ? 1 : _count;
		// _count can be -1 for infinite loop

		cooldown = cooldown_max;
	}

	override public function update(dt: Float) {
		if (cooldown > 0) {
			cooldown -= dt;
		} else {
			event();
			count -= 1;
			cooldown = cooldown_max;
		}

		if (count == 0) this.destroy();
	}

}