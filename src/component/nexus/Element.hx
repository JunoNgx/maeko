package component.nexus;

import luxe.Component;
import luxe.options.ComponentOptions;

import luxe.Vector;
import luxe.Color;

import luxe.tween.Actuate;

import C;

typedef ElementOptions = {
	> ComponentOptions,

	var type: String;
}

class Element extends Component {

	public var type: String;
	public var otu: Float = 0.5; // one-time-unit

	public var radius: Float = 1; // distance from host to element

	public var rotation_pos: Float = 0; // rotation_z
	public var rotation_spd: Float; // speed of spinning around itself
	public var orbit_pos: Float = -Math.PI/2; // current position relative to core in terms of radians
	public var orbit_spd: Float; // movement speed

	public var inMotion: Bool = false;

	override public function new(_options: ElementOptions) {
		super(_options);

		type = _options.type;

		this.rotation_spd = Luxe.utils.random.float(-C.elemo_rotat_spd_variance, C.elemo_rotat_spd_variance);
		this.orbit_spd = Luxe.utils.random.float(-C.elemo_orbit_spd_variance, C.elemo_orbit_spd_variance);

		// one time unit

		inOrbit();
	}

	override public function update(dt: Float) {
		var host: luxe.Sprite = cast entity;

		switch(type){
			case 'triangle':
				Luxe.draw.ngon({
					immediate: true,
					solid: false,
					sides: 3,
					r: 6,
					x: this.pos.x + this.radius * Math.cos(this.orbit_pos),
					y: this.pos.y + this.radius * Math.sin(this.orbit_pos),
					color: Main.c2.clone( ),
					angle: -this.rotation_pos,
					depth: -1,
				});
			case 'square':
				Luxe.draw.ngon({
					immediate: true,
					solid: false,
					sides: 4,
					r: 7,
					x: this.pos.x + this.radius * Math.cos(this.orbit_pos),
					y: this.pos.y + this.radius * Math.sin(this.orbit_pos),
					color: Main.c2.clone( ),
					angle: -this.rotation_pos,
					depth: -1,
				});
			case 'circle':
				Luxe.draw.ring({
					immediate: true,
					r: 5,
					x: this.pos.x + this.radius * Math.cos(this.orbit_pos),
					y: this.pos.y + this.radius * Math.sin(this.orbit_pos),
					color: Main.c2.clone( ),
					depth: -1,
				});
		}

		if (inMotion) {
			orbit_pos += orbit_spd * dt;
			rotation_pos += rotation_spd * dt;
		}

	}

	public function inOrbit() {
		switch(type){
			case 'triangle':
				Actuate.tween(this, otu * 1, {radius : 25});
			case 'square':
				Actuate.tween(this, otu * 2, {radius : 50});
			case 'circle':
				Actuate.tween(this, otu * 3, {radius : 75});
		}
	}

	public function outOrbit() {
		switch(type){
			case 'triangle':
				Actuate.tween(this, otu * 1, {radius : 1}).onComplete(removeSelf);
			case 'square':
				Actuate.tween(this, otu * 2, {radius : 1}).onComplete(removeSelf);
			case 'circle':
				Actuate.tween(this, otu * 3, {radius : 1}).onComplete(removeSelf);
		}
	}

	public function removeSelf(){
		entity.remove(this.name);
	}

	public function start() {
		this.inMotion = true;
	}

}