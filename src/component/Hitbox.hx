package component;

import luxe.Component;
import luxe.options.ComponentOptions;

import luxe.collision.Collision;

// import luxe.collision.shapes.Polygon;
// import luxe.collision.shapes.Shape;

import luxe.Vector;

typedef HitboxOptions = {
	> ComponentOptions,

	var body: luxe.collision.shapes.Polygon;
}

class Hitbox extends Component {

	public var body: luxe.collision.shapes.Polygon;

	override public function new(_options: HitboxOptions) {
		super(_options);

		body = _options.body;
	}

	override public function update(dt: Float) {
		var host: luxe.Sprite = cast entity;

		body.position = host.pos;
		body.rotation = host.rotation_z;

		#if debug
			states.Play.sDrawer.drawPolygon(body);
		#end
	}

	public function contact(_name: String) {
		var engaged: Bool = false;
		var targetList = new Array<luxe.Entity>();
		Luxe.scene.get_named_like(_name, targetList);

		for (target in targetList) {
			if (Collision.shapeWithShape(this.body, target.get('hitbox').body) != null) {
				engaged = true;
			}
		}

		return engaged;
	}
}