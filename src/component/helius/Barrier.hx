package component.helius;

import luxe.Component;
import luxe.options.ComponentOptions;

import luxe.collision.Collision;

import luxe.Color;
import luxe.Vector;
import luxe.tween.Actuate;

import C;

class Barrier extends Component {

	public var body: luxe.collision.shapes.Polygon;

	public var radius: Float = 1;
	public var radius_ex_rate: Float = C.barrier_radius_exrate;

	public var isActivated: Bool = false;

	override public function new() {
		super({name: 'barrier'});
		this.body = luxe.collision.shapes.Polygon.create(
			0, // workaround
			0,
			12,
			C.barrier_radius
		);
	}

	override public function update(dt: Float) {

		body.position = entity.pos;
		if (this.isActivated) collide();

		Luxe.draw.circle({
			immediate: true,
			x: entity.pos.x,
			y: entity.pos.y,
			r: this.radius,
			color: Main.c1.clone(),
			depth: -4,
		});

		Luxe.draw.ring({
			immediate: true,
			x: entity.pos.x,
			y: entity.pos.y,
			r: this.radius * radius_ex_rate,
			color: Main.c1.clone(),
			depth: -4,
		});

		// debug
		// Luxe.draw.text({
		// 	text: '${isActivated} + ${radius}',
		// 	pos: new Vector(this.pos.x, this.pos.y + 64),
		// 	point_size: 32,
		// 	align: right,
		// 	immediate: true,
		// });

		// Main.sDrawer.drawPolygon(this.body);
	}

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
			}
		}

		var targetList = new Array<luxe.Entity>();
		Luxe.scene.get_named_like('maeko', targetList);

		for (target in targetList) {
			var collision = Collision.shapeWithShape(this.body, target.get('hitbox').body);
			if (collision != null) {
				var p: entity.Maeko = cast target;
				p.hit();
			}
		}
	}

	public function activate() {
		Actuate.tween(this, 1, {radius: C.barrier_radius}).onComplete(function(){
			this.isActivated = true;
		});
	}

	public function deactivate() {
		Actuate.tween(this, 1, {radius: 1}).onComplete(function(){
			// this.isActivated = false;
		});
		this.isActivated = false; // currently a known bug, not sure why Actuate can't complete the tween
	}

}
