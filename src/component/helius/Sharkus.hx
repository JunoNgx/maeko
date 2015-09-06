package component.helius;

import luxe.Component;
import luxe.options.ComponentOptions;

import luxe.Vector;
import luxe.Color;

import luxe.collision.Collision;
import luxe.tween.Actuate;

import C;

class Sharkus extends Component {

	public var body: luxe.collision.shapes.Polygon;

	public var actual_position: Vector;
	public var dist_to_host: Float = 1; 

	public var hp: Int = C.sharkus_maxHP;
	public var radius: Float = 1;
	public var flash_col: Color;

	public var shard_isFiring: Bool = false;
	public var shard_cooldown: Float = 0;
	public var shard_barrel_no: Int = 1;

	public var chunk_isFiring: Bool = false;
	public var chunk_cooldown: Float = 0;

	override public function new() {
		super({
			name: 'sharkus',
		});

		this.body = luxe.collision.shapes.Polygon.create(
			0, // workaround
			0,
			12,
			C.sharkus_radius
		);

		getReady();
	}

	function getReady() {
		this.flash_col = new Color(1, 1, 1, 0);
		this.hp = C.sharkus_maxHP;

		Luxe.audio.play('end_sharkus_summon');
		
		Actuate.tween(this, 1, {dist_to_host: 92, radius: C.sharkus_radius})
			.onComplete(function() {
				// entity.remove(this.name);
			});
	}

	public function removeArm() {
		Actuate.tween(this, 1, {dist_to_host: 0, radius: 1})
			.onComplete(function() {
				entity.remove(this.name);
			});
	}

	override function update(dt: Float) {

		this.actual_position = new Vector(entity.pos.x, entity.pos.y + this.dist_to_host);
		this.body.position = this.actual_position;

		shardUpdate(dt);
		chunkUpdate(dt);

		collide();

		draw();

	}

	function draw() {

		Luxe.draw.circle({
			immediate: true,
			x: this.actual_position.x,
			y: this.actual_position.y,
			r: this.radius,
			color: Main.c2.clone(),
			depth: -2,
		});

		// Abstractly drawing remaining HP
		Luxe.draw.circle({
			immediate: true,
			x: this.actual_position.x,
			y: this.actual_position.y,
			r: this.radius * (C.sharkus_maxHP - this.hp)/C.sharkus_maxHP,
			color: Main.c5.clone(),
			depth: -1,
		});

		// Another invisible layer that flashes when hit
		Luxe.draw.circle({
			immediate: true,
			x: this.actual_position.x,
			y: this.actual_position.y,
			r: this.radius,
			color: this.flash_col,
			depth: 0,
		});
	}

	// ============= Defensive stuff ===================

	function collide() {

		var targetList = new Array<luxe.Entity>();
		Luxe.scene.get_named_like('shot', targetList);

		for (target in targetList) {
			if (Collision.shapeWithShape(this.body, target.get('hitbox').body) != null) {

				var shot: entity.end.Shot = cast target;

				Luxe.events.fire('effect.flash', {
					pos: shot.pos,
					dir: shot.rotation_z,
				});

				shot.destroy();

				this.hit();
			}
		}
	}

	public function hit() {

		Actuate.tween(this.flash_col, 0.1, {a: 1})
			.onComplete(function() {
				Actuate.tween(this.flash_col, 0.1, {a: 0})
					.onComplete(function() {
						this.hp -= 1;
						if (hp == 0) {

							Luxe.camera.shake(80);
							Luxe.events.fire('effect.explosion', {pos: this.actual_position});
							entity.events.fire('sharkus destroyed');

							this.removeArm();

							var host: entity.end.Helius = cast entity;
							host.stopTrigger.destroy();

							Luxe.audio.play('end_sharkus_destroy');

						} else Luxe.audio.play('end_sharkus_hit');
					});
			});
	}

	// ============= Offensive stuff ===================

	public function startShard() {
		this.shard_isFiring = true;
		shard_barrel_no = 1;
	}

	public function stopShard() {
		this.shard_isFiring = false;
	}

	public function startChunk() {
		this.chunk_isFiring = true;
	}

	public function stopChunk() {
		this.chunk_isFiring = false;
	}

	public function shardUpdate(dt: Float) {
		if (shard_isFiring) {
			if (shard_cooldown > 0) {
				shard_cooldown -= dt;
			} else {
				fireShard();
				shard_cooldown = C.shard_cooldown;
			}
		}
	}

	public function chunkUpdate(dt: Float) {
		if (chunk_isFiring) {
			if (chunk_cooldown > 0) {
				chunk_cooldown -= dt;
			} else {
				fireChunk();
				chunk_cooldown = C.chunk_cooldown;
			}
		}
	}

	function fireShard() {
		var barrelPos = new Vector(this.actual_position.x , this.actual_position.y + 48);

		switch (shard_barrel_no) {
			case 1:
				var bullet = new entity.end.Bullet(barrelPos, C.bullet_end_speed, Math.PI/2 + Math.PI * 2/8);
				shard_barrel_no = 3;
			case 2:
				var bullet = new entity.end.Bullet(barrelPos, C.bullet_end_speed, Math.PI/2 + Math.PI * 1/8);
				shard_barrel_no = 4;
			case 3:
				var bullet = new entity.end.Bullet(barrelPos, C.bullet_end_speed, Math.PI/2 - Math.PI * 1/8);
				shard_barrel_no = 2;
			case 4:
				var bullet = new entity.end.Bullet(barrelPos, C.bullet_end_speed, Math.PI/2 - Math.PI * 2/8);
				shard_barrel_no = 1;
		}

		Luxe.audio.play('helius_shard');
	}

	public function fireChunk() {
		var barrelPos = new Vector(this.actual_position.x , this.actual_position.y + 48);

		var bullet = new entity.end.Bullet(barrelPos, C.bullet_end_speed, Math.PI * 1/5);
		var bullet = new entity.end.Bullet(barrelPos, C.bullet_end_speed, Math.PI * 2/5);
		var bullet = new entity.end.Bullet(barrelPos, C.bullet_end_speed, Math.PI * 3/5);
		var bullet = new entity.end.Bullet(barrelPos, C.bullet_end_speed, Math.PI * 4/5);

		Luxe.audio.play('helius_chunk');

		Luxe.events.fire('effect.flash', {
			pos: barrelPos,
			dir: -90,
		});
	}

}