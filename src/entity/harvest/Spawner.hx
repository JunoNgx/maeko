package entity.harvest;

import luxe.Vector;

import luxe.options.EntityOptions;

class Spawner extends entity.base.Spawner {

	public var cooldown_max1: Float = 2;
	public var cooldown_max2: Float = 1;
	public var cooldown_max3: Float = 1;

	public var cooldown_wave: Float = 2.4;

	override public function initiate() {
		var t = new GTimer(4, function(){
			this.isSpawning = true;
		});
		cooldown = 0;
	}

	override public function update(dt: Float) {
		super.update(dt);

		if (isSpawning) {
			if (cooldown < 0) {

				// different stages of spawning
				// gets more difficult and overwhelming over time

				if (lifetime < C.harvest_timemark_1 ){ // Stage 1, single low frequency
					spawnSingle(1.5);
					cooldown = cooldown_max1;
				} else if (C.harvest_timemark_1 < lifetime && lifetime < C.harvest_timemark_2 ) { // Stage 2, slightly faster and higher frequency
					spawnSingle(1.2);
					cooldown = cooldown_max2;
				} else if (C.harvest_timemark_2 < lifetime && lifetime < C.harvest_timemark_3 ) { // Stage 3, double faster high frequency
					for (i in 0...2) {
						spawnSingle(2.0);
					}
					cooldown = cooldown_max3;
				} else { // Stage 4, overwhelming waves to panic the player
					spawnWave();
					cooldown = cooldown_wave;
				}

			} else {
				cooldown -= dt;
			}
		} // isSpawning
	}

	public function spawnSingle(_freq: Float) {
		var karl = new entity.harvest.Karl(new Vector(
			Luxe.utils.random.float(0, Main.w),
			Luxe.utils.random.float(- 200, 0)
		), _freq);
	}

	public function spawnWave() {
		var amt = 8; // actual == amt -1

		for (i in 1...amt) {
			if (i <= amt/2) {

				var karl = new entity.harvest.Karl(new Vector(
					Main.w * i/amt,
					-Main.h/4 * i/Math.ceil(amt/2)
				), 1.0);

			} else if (i > amt/2) {

				var karl = new entity.harvest.Karl(new Vector(
					Main.w * i/amt,
					-Main.h/4 * (amt - i)/Math.ceil(amt/2)
				), 1.0);

			}
		}
	}

	public function stopSpawning() {
		this.isSpawning = false;
	}
}