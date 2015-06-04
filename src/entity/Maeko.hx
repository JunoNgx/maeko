package entity;

import luxe.Sprite;
import luxe.Vector;
import luxe.Color;
import luxe.Input;

// import component.Velocity;
// import component.AccelCtrl;

import luxe.collision.Collision;

import C;

typedef PosEvent = {
	x: Float,
	y: Float
}

class Maeko extends Sprite {

	public var velocity: component.Velocity;
	public var hitbox: component.Hitbox;

	public static var harvest_cooldown_max: Float = 2;
	public static var speed: Float = 2000;

	// public var disp_rotation: Float;
	public var ammo: Int = 40;

	public var harvest_contact: Bool = false;
	public var harvest_cooldown: Float;

	override public function new() {
		super({
			name: 'maeko',
			name_unique: true,
			pos: new Vector (Main.w/2, Main.h/2),
			// texture: Luxe.resources.texture('assets/dulce.png'),
			size: new Vector(60, 100),
			color: new Color().rgb(0x628179),

		});

		velocity = new component.Velocity({
			name: 'velocity'
		});
		this.add(velocity);

		hitbox = new component.Hitbox({
			name: 'hitbox',
			body: luxe.collision.shapes.Polygon.create(pos.x, pos.y, 4, 32)
		});
		this.add(hitbox);

		this.add(new component.MaekoCannon());

		this.add(new component.KeepBounds({
			top: 0,
			bottom: Main.h,
			left: 0,
			right: Main.w,
		}));
		// this.add(new AccelCtrl({name: 'accel control'}));

		Luxe.events.listen('ring.pos', function(e: PosEvent) {
			this.orientate(e.x, e.y);
		});

		harvest_cooldown = harvest_cooldown_max;
	}

	override public function update(dt: Float) {

		// Luxe.draw.ngon({
		// 	immediate: true,
		// 	r: C.player_radius,
		// 	sides: 3,
		// 	x: this.pos.x,
		// 	y: this.pos.y,
		// 	angle: -(this.disp_rotation * 180/ Math.PI),
		// 	solid: true,
		// 	color: new Color().rgb(0xF92672),
		// });
		
		// if (Math.abs(velocity.x) > 100 || Math.abs(velocity.y) > 100) {
		// 	// this.disp_rotation = Math.atan2( 
		// 	this.radians = Math.atan2( 
		// 		Math.floor(Main.accel_y * 100),
		// 		Math.floor(Main.accel_x * 100)
		// 	);
		// }

		// Luxe.draw.texture({
		// 	pos: this.pos,
		// 	texture: Luxe.resources.texture('assets/dulce.png'),
		// 	rotation: new luxe.Quaternion().setFromEuler( new Vector(0, 0, -this.disp_rotation)),
		// 	immediate: true,
		// });

		Luxe.draw.text({
			text: '${ammo}',
			pos: new Vector(this.pos.x, this.pos.y - 64),
			point_size: 48,
			align: right,
			immediate: true,
		});

		this.velocity.x = Main.accel_x * speed;
		this.velocity.y = Main.accel_y * speed;

		// collision processing

		// var ammoList = new Array<luxe.Entity>();
		// Luxe.scene.get_named_like('ammobox', ammoList);

		// var ammoBodyList = new Array<luxe.collision.shapes.Shape>();
		// for (ammoBox in ammoList) ammoBodyList.push(ammoBox.get('hitbox').body);

		// if (Collision.shapeWithShapes(this.hitbox.body, ammoBodyList).length != 0) {
		// 	this.harvest_contact = true;
		// } else {
		// 	this.harvest_contact = false;
		// 	// trace(Collision.shapeWithShapes(this.hitbox.body, ammoBodyList));
		// 	trace('hit');
		// }

		// harvest_contact = contactAmmoSweep();
		harvest_contact = (hitbox.contact('ammobox'));

		if (harvest_contact) harvest_cooldown -= dt;
		if (harvest_cooldown < 0) {
			harvest_cooldown = harvest_cooldown_max;
			ammo += 1;
		}

		// ammoList = [];
		// ammoBodyList = [];

	}

	public function orientate(_x: Float, _y: Float) {
		this.radians = Math.atan2(
			_y - this.pos.y,
			_x - this.pos.x
		);
		// trace('orientating' + ' ' + _x + ' ' + _y);
	}

	// override public function onmousemove(e: MouseEvent) {

	// 	var curPos = Luxe.camera.screen_point_to_world(e.pos);

	// 	this.radians = Math.atan2( 
	// 		curPos.y - this.pos.y,
	// 		curPos.x - this.pos.x
	// 	);
	// }

	// public function contactAmmoSweep() {

	// 	var contactAmmo: Bool = false;
	// 	var ammoList = new Array<luxe.Entity>();
	// 	Luxe.scene.get_named_like('ammobox', ammoList);

	// 	// var ammoBodyList = new Array<luxe.collision.shapes.Shape>();
	// 	for (ammoBox in ammoList) {
	// 		if (Collision.shapeWithShape(this.hitbox.body, ammoBox.get('hitbox').body) != null) {
	// 			contactAmmo = true;
	// 		}
	// 	}

	// 	return contactAmmo;
	// }
}