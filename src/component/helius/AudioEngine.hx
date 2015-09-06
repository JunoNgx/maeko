package component.helius;

import luxe.Component;
import luxe.options.ComponentOptions;

class AudioEngine extends Component {

	public var isPlaying: Bool;

	public var currentSound: luxe.Sound;
	public var library: Array<String>;
	public var cooldown: Float;
	
	override public function new() {
		super({
			name: 'engine'
		});

		library = [
			'helius_engine1',
			'helius_engine2',
			'helius_engine3',
			'helius_engine4',
			'helius_engine5',
			'helius_engine6',
			'helius_engine7',
		];
		playNow();
	}

	public function resetCooldown() {
		cooldown = Luxe.utils.random.float(C.engine_cooldown_min, C.engine_cooldown_max);
	}

	override public function update(dt: Float) {
		if (isPlaying){
			if (cooldown > 0) {
				cooldown -= dt;
			} else {
				Luxe.audio.play(library[Luxe.utils.random.int(0,7)]);
				resetCooldown();
			}
		}

		// Luxe.draw.text({
		// 	text: '${isPlaying}',
		// 	pos: new luxe.Vector(entity.pos.x, entity.pos.y - 64),
		// 	point_size: 48,
		// 	align: right,
		// 	immediate: true,
		// });
	}

	public function playNow() {
		resume();
		cooldown = 0;
	}

	public function resume() {
		isPlaying = true;
	}

	public function stop() {
		isPlaying = false;
	}

}
