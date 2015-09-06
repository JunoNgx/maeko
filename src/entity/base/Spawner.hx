package entity.base;

import luxe.Entity;
import luxe.Vector;
import luxe.Color;

class Spawner extends Entity {

	public var lifetime: Float = 0;
	public var isSpawning: Bool;
	public var cooldown: Float;

	override public function new() {
		super({
			name: 'spawner',
		});

		initiate();
	}

	override public function update(dt: Float) {
		lifetime += dt;
	}

	public function initiate() {
		
	}

}