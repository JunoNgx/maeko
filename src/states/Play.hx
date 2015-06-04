package states;
import luxe.Sprite;
import luxe.Input;
import luxe.States;
import luxe.Color;
import luxe.Vector;
import luxe.Camera;
import luxe.Text;

import luxe.collision.Collision;

import entity.Maeko;
import entity.Ring;
import entity.Shot;
import entity.Ayu;
import entity.Bullet;
import entity.AmmoBox;

import ui.ProxBar;

import snow.types.Types;

import C;

typedef AccelEvent = {
    timestamp:Float,
    value:Float,
    axis:Int
}

class Play extends State {

	public static var sDrawer: luxe.collision.ShapeDrawerLuxe;
	public static var proxbar: ProxBar;

	public static var p: entity.Maeko;
	public static var ring: entity.Ring;

	public static var pShot: Array<Shot>;
	public static var pAyu: Array<Ayu>;
	public static var pBullet: Array<Bullet>;
	public static var pAmmo: Array<AmmoBox>;

	public static var debug: Text;

	// This is your main gameplay state and should totally be in your control
	// All callbacks from luxe.Game are also available here

	var block: Sprite;

	override public function onenter<T> (_:T) {
		// Luxe.camera.size = new Vector(800, 450);
		// Luxe.camera.size_mode = SizeMode.fit;

		// block = new Sprite({
		// 	name: 'default testing sprite',
		// 	pos: Luxe.screen.mid,
		// 	color: new Color().rgb(0xf94b04),
		// 	size: new Vector(128, 128)
		// 	});

		sDrawer = new luxe.collision.ShapeDrawerLuxe();
		proxbar = new ProxBar({name: 'proxmity bar'});

		p = new Maeko();
		ring = new Ring();
		debug = new Text({});

		pShot = new Array<Shot>();
		pAyu = new Array<Ayu>();
		pBullet = new Array<Bullet>();
		pAmmo = new Array<AmmoBox>();

		Luxe.timer.schedule(2, function(){
			var ayu = new Ayu(Luxe.utils.random.bool(0.5));
			// var ayu = new Ayu(false);
		}, true);

		Luxe.timer.schedule(2, function(){
			var ammo = new AmmoBox();
			// var ayu = new Ayu(false);
		}, true);

	}

	override public function update(dt: Float) {
		// block.rotation_z += C.rotate_speed * dt;
		// debug.text = p.velocity.x 
		// + '\n' + p.velocity.y;

		// debug.text = new 
		debug.text = pShot.length + '\n' + pAyu.length + '\n'
		+ Luxe.scene.length
		+ '\n' + proxbar.value
		+ '\n' + proxbar.fillRate
		+ '\n' + proxbar.length
		+ '\n' + p.harvest_contact;

		for (shot in pShot) {
			for (ayu in pAyu) {
				if (Collision.shapeWithShape(shot.hitbox.body, ayu.hitbox.body) != null) {
					shot.destroy();
					ayu.destroy();

					proxbar.addlength(C.ayu_value);
				}
			}
		}

		// for (ammobox in pAmmo) {
		// 	if (Collision.shapeWithShape(ammobox.hitbox.body, p.hitbox.body) != null) {
		// 		shot.destroy();
		// 		ayu.destroy();

		// 		proxbar.addlength(C.ayu_value);
		// 	}
		// }
	}

	override public function onleave<T> (_:T) {
		// block.destroy();
	}

	override function onmousemove( event: MouseEvent) {
		// block.pos = Luxe.camera.screen_point_to_world(event.pos);
	}

	override function onkeyup( e:KeyEvent ) {
		//escape from the game at any time, mostly for debugging purpose
		if(e.keycode == Key.escape) {
			Luxe.shutdown();
		}
	}

	// var accel_x: Float = 0;
	// var accel_y: Float = 0;
	// var accel_z: Float = 0;

	// function onevent( ev:SystemEvent ) {

 //        if(ev.type == SystemEventType.input) {
 //            if(ev.input.type == InputEventType.joystick) {

 //                var event : AccelEvent = ev.input.event;
 //                switch(event.axis) {
 //                    case 0: accel_x = event.value;
 //                    case 1: accel_y = event.value;
 //                    case 2: accel_z = event.value;

 //                    Luxe.events.fire('accelAxis', {
 //                    	x: accel_x,
 //                    	y: accel_y,
 //                    	z: accel_z
 //                    });

 //                    debug.text = accel_x + '\n' + accel_y;
 //                }

 //            } //if joystick
 //        } //if input

 //    } //onevent
}
