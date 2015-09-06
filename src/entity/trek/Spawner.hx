package entity.trek;

import luxe.Vector;

class Spawner extends entity.base.Spawner {

	public var cooldown_ayu: Float = 0;
	public var cooldown_krist: Float = 0;
	public var cooldown_hessel: Float = 0;

	public var isSpawning_ayu: Bool = false;
	public var isSpawning_krist: Bool = false;
	public var isSpawning_hessel: Bool = false;

	override function initiate() {
		var timer = new GTimer (5, startSpawning);
	}

	public function startSpawning() {
		this.isSpawning_ayu = true; 
		this.isSpawning_krist = true; 
		this.isSpawning_hessel = true; 
	}

	override function update(dt: Float) {
		if (isSpawning_ayu) {
			if (cooldown_ayu > 0) {
				cooldown_ayu -= dt;
			} else {
				spawnAyu();
				cooldown_ayu = Luxe.utils.random.float(C.trek_spawn_ayu_min, C.trek_spawn_ayu_max);
			}
		} // spawning ayu

		if (isSpawning_krist) {
			if (cooldown_krist > 0) {
				cooldown_krist -= dt;
			} else {
				spawnKrist();
				cooldown_krist = Luxe.utils.random.float(C.trek_spawn_krist_min, C.trek_spawn_krist_max);
			}
		} // spawning krist

		if (isSpawning_hessel) {
			if (cooldown_hessel > 0) {
				cooldown_hessel -= dt;
			} else {
				spawnHessel();
				cooldown_hessel = Luxe.utils.random.float(C.trek_spawn_hessel_min, C.trek_spawn_hessel_max);
			}
		} // spawning Hessel
	}

	function spawnAyu() {

		var isFormatted: Bool = Luxe.utils.random.bool(0.5);

		if (isFormatted) {
			var formationCode = Luxe.utils.random.int(1, 8);

			switch (formationCode) {
				case 1: // three type1 from top

					var ayu = new entity.trek.Ayu(
						1,
						Main.w * 1/4,
						-70,
						Math.PI/2);

					var ayu = new entity.trek.Ayu(
						1,
						Main.w * 2/4,
						-70,
						Math.PI/2);

					var ayu = new entity.trek.Ayu(
						1,
						Main.w * 3/4,
						-70,
						Math.PI/2);


				case 2: // two type2 from top

					var ayu = new entity.trek.Ayu(
						2,
						Main.w * 1/3,
						Luxe.utils.random.float(-150, -30),
						Math.PI/2);

					var ayu = new entity.trek.Ayu(
						2,
						Main.w * 2/3,
						Luxe.utils.random.float(-150, -30),
						Math.PI/2);

				case 3: // two type3 from top

					var ayu = new entity.trek.Ayu(
						2,
						Main.w * 1/3,
						Luxe.utils.random.float(-150, -30),
						Math.PI/2);

					var ayu = new entity.trek.Ayu(
						2,
						Main.w * 2/3,
						Luxe.utils.random.float(-150, -30),
						Math.PI/2);

				case 4: // two type1 from lateral

					var ayu = new entity.trek.Ayu(
						1,
						-150,
						Luxe.utils.random.float(0, Main.h),
						0);

					var ayu = new entity.trek.Ayu(
						1,
						Main.w + 150,
						Luxe.utils.random.float(0, Main.h),
						Math.PI);

				case 5: // two type3 from lateral

					var ayu = new entity.trek.Ayu(
						3,
						-150,
						Luxe.utils.random.float(0, Main.h),
						0
					);

					var ayu = new entity.trek.Ayu(
						3,
						Main.w + 150,
						Luxe.utils.random.float(0, Main.h),
						Math.PI
					);

				case 6: // four type1 from lateral top corners

					var ayu = new entity.trek.Ayu(
						1,
						-150,
						-150,
						Math.PI * 1/4
					);

					var ayu = new entity.trek.Ayu(
						1,
						-150,
						-20,
						Math.PI * 1/4
					);


					var ayu = new entity.trek.Ayu(
						1,
						Main.w + 150,
						-150,
						Math.PI * 3/4
					);

					var ayu = new entity.trek.Ayu(
						1,
						Main.w + 150,
						-20,
						Math.PI * 3/4
					);

				case 7: // two random from top, give it into chaos hua!!

					var ayu = new entity.trek.Ayu(
						Luxe.utils.random.int(1,4),
						Luxe.utils.random.float(0, Main.w),
						-70,
						Math.PI/2
					);

					var ayu = new entity.trek.Ayu(
						Luxe.utils.random.int(1,4),
						Luxe.utils.random.float(0, Main.w),
						-70,
						Math.PI/2
					);
			}

		} else {
			var ayu = new entity.trek.Ayu(
				Luxe.utils.random.int(1,4),
				Luxe.utils.random.float(0, Main.w),
				Luxe.utils.random.float(-120, -20),
				Luxe.utils.random.float(Math.PI * 1/4, Math.PI * 3/4)
			);
		}

		
	}

	function spawnKrist() {
		var krist = new entity.trek.Krist(
			new Vector(Luxe.utils.random.float(0, Main.w), 0),
			Luxe.utils.random.float(Math.PI/4, Math.PI * 3/4),
			Luxe.utils.random.bool(0.5)
		);
	}

	function spawnHessel() {
		if (Luxe.utils.random.int(0, 4) == 0) {
			var hessel = new entity.trek.Hessel(new Vector(Luxe.utils.random.float(0, Main.w), 0));
		}
	}

	public function stopSpawning() {
		this.isSpawning_ayu = false; 
		this.isSpawning_krist = false; 
		this.isSpawning_hessel = false; 
	}

}