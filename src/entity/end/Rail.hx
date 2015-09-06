package entity.end;

import luxe.Vector;
import luxe.Color;

import luxe.collision.Collision;
import luxe.tween.Actuate;

import C;

class Rail extends luxe.Sprite {

	public var body: luxe.collision.shapes.Polygon;
	public var shooter: luxe.Sprite;

	override public function new(_shooter: luxe.Sprite, _degree: Float) {
		super({
			name: 'rail',
			name_unique: true,
			pos: _shooter.pos,
			visible: false,
			rotation_z: _degree,
		});
		shooter = _shooter;

		this.body = luxe.collision.shapes.Polygon.rectangle(
			0,
			0,
			Main.w,
			C.rail_width,
			true
		);

		Actuate.tween(this.scale, C.rail_lifetime, {x: 0}).onComplete(destroy);
	}

	override public function update(dt: Float) {
		this.pos = shooter.pos;

		this.body.rotation = this.rotation_z;
		this.body.x = this.pos.x + Main.w/2 * Math.cos(this.radians);
		this.body.y = this.pos.y + Main.w/2 * Math.sin(this.radians);

		collide();

		if (this.rotation_z == 90) { // totally dirty hack, I'm too tired to do this properly
			// there is no center: Bool in Luxe.draw.texture()
			Luxe.draw.texture({
				immediate: true,
				depth: -1,
				color: Main.c3.clone(),
				x: this.pos.x + C.rail_width/2 * this.scale.x,
				y: this.pos.y,
				size: new Vector(Main.w, C.rail_width * this.scale.x),
				rotation: new phoenix.Quaternion().setFromEuler(new Vector(0,0, this.radians))
			});

			Luxe.draw.texture({
				immediate: true,
				depth: -2,
				color: new Color(1,1,1,0.5),
				x: this.pos.x + C.rail_width2/2 * this.scale.x,
				y: this.pos.y,
				size: new Vector(Main.w, C.rail_width2 * this.scale.x),
				rotation: new phoenix.Quaternion().setFromEuler(new Vector(0,0, this.radians))
			});
		} else {
			Luxe.draw.texture({
				immediate: true,
				depth: -1,
				color: Main.c3.clone(),
				x: this.pos.x - C.rail_width/2 * this.scale.x,
				y: this.pos.y,
				size: new Vector(Main.w, C.rail_width * this.scale.x),
				rotation: new phoenix.Quaternion().setFromEuler(new Vector(0,0, this.radians))
			});

			Luxe.draw.texture({
				immediate: true,
				depth: -2,
				color: new Color(1,1,1,0.5),
				x: this.pos.x - C.rail_width2/2 * this.scale.x,
				y: this.pos.y,
				size: new Vector(Main.w, C.rail_width2 * this.scale.x),
				rotation: new phoenix.Quaternion().setFromEuler(new Vector(0,0, this.radians))
			});
		}
	}

	function collide() {

		var targetList = new Array<luxe.Entity>();
		Luxe.scene.get_named_like('maeko', targetList);

		for (target in targetList) {
			if (Collision.shapeWithShape(this.body, target.get('hitbox').body) != null) {

				var maeko: entity.Maeko = cast target;

				maeko.hit();

			}
		}
	}

}