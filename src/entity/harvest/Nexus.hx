package entity.harvest;

import luxe.Sprite;

import luxe.Color;
import luxe.Vector;

import luxe.tween.Actuate;

import C;

class Nexus extends Sprite {

	public var radius: Float = 192;

	public var elemented: Bool = false; // elements are awakened and fed
	public var element_level: Int = 0;

	override public function new() {
		super({
			name: 'nexus',
			name_unique: true,
			pos: new Vector(Main.w/2, Main.h * 4/5),
			visible: false,
			color: Main.c2.clone(),
			rotation_z: 180,
		});

		this.add( new component.Hitbox( {
			name: 'hitbox',
			body: luxe.collision.shapes.Polygon.create(pos.x, pos.y, 3, this.radius),
		}));

		addMatureElements();
		addCoreHitbox();
	}

	override public function update(dt: Float) {

		Luxe.draw.ngon({
			immediate: true,
			solid: false,
			sides: 3,
			r: this.radius,
			x: this.pos.x,
			y: this.pos.y,
			color: this.color,
			angle: -this.rotation_z,
			depth: -1,
		});

		if (this.has('hitbox')) {
			if (this.get('hitbox').collide('maeko') != null) {
				glow();
			}
		}

	}

	public function glow() {
		Luxe.draw.ngon({
			immediate: true,
			solid: false,
			sides: 3,
			r: this.radius + 24,
			x: this.pos.x,
			y: this.pos.y,
			color: Main.c3.clone(),
			angle: -this.rotation_z,
			depth: -4,
		});
	}

	public function addMatureElements() {

		this.add(new component.nexus.Core({
			name: 'core',
		}));
		this.add(new component.nexus.Element({
			name: 'element.triangle',
			type: 'triangle',
		}));
		this.add(new component.nexus.Element({
			name: 'element.square',
			type: 'square',
		}));
		this.add(new component.nexus.Element({
			name: 'element.circle',
			type: 'circle',
		}));

	}

	public function addCoreHitbox(){
		var core_hitbox = new entity.harvest.NexusCoreHitbox();
	}

	public function initiateElements() {
		this.get('element.triangle').start();
		this.get('element.square').start();
		this.get('element.circle').start();
	}
}