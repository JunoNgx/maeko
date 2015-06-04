package component;

import luxe.Component;
import luxe.options.ComponentOptions;

import luxe.Input;
import luxe.Color;
import luxe.Vector;

class MaekoCannon extends Component {

	override public function new() {
		super({name: 'MaekoCannon'});
	}

	override public function onmouseup(e: MouseEvent) {
		fire();	
		// shot.radians = host.radians;
		
		// shot.setVelo(shot.speed * Math.cos(host.radians), shot.speed * Math.sin(host.radians));
	}

	public function fire() {
		var host: entity.Maeko = cast entity;
		if (host.ammo > 0) {
			var shot = new entity.Shot(host.pos.x, host.pos.y, host.radians);
			host.ammo -= 1;
		}

	}
}