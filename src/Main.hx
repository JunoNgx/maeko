package;

import luxe.Screen.WindowEvent;
import phoenix.Texture.FilterType;

import luxe.Camera;
import luxe.Vector;
import luxe.Text;
import luxe.Color;
import luxe.Input;

import luxe.States;
import snow.types.Types;
import phoenix.Texture;
import phoenix.BitmapFont;

import C;

typedef PosEvent = {
	pos: Vector
}

typedef ShakeEvent = {
	amt: Float
}

class Main extends luxe.Game {

	var initialState:String = 'trek'; // First state to run, in string (luxe.States.State.name), refer to state's file
	var showCursor:Bool = true; // Quick setting, whether to display system cursor in-game, useful for custom cursor or certain genres of action games

	// Optional values,
	// useful when game does not fully cover the
	// entire screen, great to use when
	// Luxe.camera.size_mode == SizeMode.fit
	public static var w: Int = 1280;
	public static var h: Int = 720;

	public static var sDrawer: luxe.collision.ShapeDrawerLuxe;
	public static var arcon: BitmapFont;

	public static var c1: Color; 	// entity
	public static var c2: Color; 	// projectiles & particles
	public static var c3: Color; 	// esth & krist
	public static var c4: Color;	// background
	public static var c5: Color;	// background particles

	// Progress variable
	public static var p_cycle: Int;
	// public static var p_calibrate_en: Bool;
	// public static var p_harvest_en: Bool;
	// public static var p_trek_en: Bool;
	// public static var p_end_en: Bool;

	public static var pauseKeyIsPresent: Bool = false;
	public static var pauseKey: entity.PauseKeyGraphic;

	public static var state: States;

	override function config(config:luxe.AppConfig):luxe.AppConfig {

		#if ios
			config.window.fullscreen = true;
			config.window.borderless = true;
		#end

		// Preloading resources
		// Resources in Luxe are generally required
		// to be pre-loaded before used
		config.preload.textures = [
			{id: 'assets/AureolineTetrahedron.png'},
			{id: 'assets/MadeWithLuxe.png'},
			{id: 'assets/Headphones.png'},
			{id: 'assets/logo.png'},
			{id: 'assets/logo_completed.png'}, // I'm just being lazy
			{id: 'assets/PauseButton.png'},
		];

		config.preload.fonts.push({ id:'assets/arcon.fnt'});

		return config;
	}

	// Scale camera's viewport accordingly when game is scaled, common and suitable for most games
	override function onwindowsized( e:WindowEvent ) {
        Luxe.camera.viewport = new luxe.Rectangle( 0, 0, e.event.x, e.event.y);
    }

	override function ready() {

		camReset();
		create_audio();
		loadProgress();
		sDrawer = new luxe.collision.ShapeDrawerLuxe();

		arcon = Luxe.resources.font('assets/arcon.fnt');

		// Actual codes that hide/show the cursor
		Luxe.screen.cursor.visible = showCursor;

		// Create a state machine
		state = new States( { name: "states" } );

		// Add states to the state machine
		state.add (new states.Splash({name: 'splash'}));

		state.add (new entity.calibrate.State({name: 'calibrate'}));
		state.add (new entity.harvest.State({name: 'harvest'}));
		state.add (new entity.trek.State({name: 'trek'}));
		state.add (new entity.end.State({name: 'end'}));

		state.add (new states.Pause({name: 'pause'}));
		state.add (new entity.menu.State({name: 'menu'}));
		state.add (new states.Credits({name: 'credits'}));

		// Run the inital state upon running the game
		state.set(initialState);

	}

	public static function camReset() {
		Luxe.camera = new luxe.Camera({
			name:'default camera',
			view: Luxe.renderer.camera,
		});
		Luxe.camera.zoom = 1;
		Luxe.camera.size = new Vector(Main.w, Main.h);
		Luxe.camera.size_mode = SizeMode.fit;
	}

	function create_audio() {
		// Harvest
		Luxe.audio.create('assets/evolved.ogg', 'evolved');
		Luxe.audio.create('assets/credits_music.ogg', 'credits');
		Luxe.audio.create('assets/maeko_hit.ogg', 'maeko_hit');
		Luxe.audio.create('assets/maeko_destroy.ogg', 'maeko_destroy');

		Luxe.audio.create('assets/harvest_counter.ogg', 'harvest_counter');
		Luxe.audio.create('assets/harvest_shoot.ogg', 'harvest_shoot');
		Luxe.audio.create('assets/harvest_pickup.ogg', 'harvest_pickup');
		Luxe.audio.create('assets/harvest_counter_holder_thump.ogg', 'harvest_counter_holder_thump');
		Luxe.audio.create('assets/harvest_karl_destroy.ogg', 'harvest_karl_destroy');
		Luxe.audio.create('assets/sonicwave.ogg', 'sonicwave');
		Luxe.audio.create('assets/core_compromised.ogg', 'core_compromised');

		Luxe.audio.create('assets/trek_bgm.ogg', 'trek_bgm');
		Luxe.audio.create('assets/ayucannon1.ogg', 'ayucannon1');
		Luxe.audio.create('assets/ayucannon2.ogg', 'ayucannon2');
		Luxe.audio.create('assets/ayucannon3.ogg', 'ayucannon3');
		Luxe.audio.create('assets/ayucannon4.ogg', 'ayucannon4');
		Luxe.audio.create('assets/trek_exp1.ogg', 'trek_exp1');
		Luxe.audio.create('assets/trek_exp2.ogg', 'trek_exp2');
		Luxe.audio.create('assets/trek_exp3.ogg', 'trek_exp3');
		Luxe.audio.create('assets/trek_shoot.ogg', 'trek_shoot');
		Luxe.audio.create('assets/trek_pickup.ogg', 'trek_pickup');
		Luxe.audio.create('assets/trek_ayu_hit1.ogg', 'trek_ayu_hit1');
		Luxe.audio.create('assets/trek_ayu_hit2.ogg', 'trek_ayu_hit2');
		Luxe.audio.create('assets/trek_ayu_hit3.ogg', 'trek_ayu_hit3');
		Luxe.audio.create('assets/trek_ayu_destroy.ogg', 'trek_ayu_destroy');
		Luxe.audio.create('assets/trek_progress.ogg', 'trek_progress');

		Luxe.audio.create('assets/helius_shard.ogg', 'helius_shard');
		Luxe.audio.create('assets/helius_chunk.ogg', 'helius_chunk');
		Luxe.audio.create('assets/helius_railgun.ogg', 'helius_railgun');
		Luxe.audio.create('assets/helius_hit.ogg', 'helius_hit');
		Luxe.audio.create('assets/helius_destroy.ogg', 'helius_destroy');
		Luxe.audio.create('assets/end_shot.ogg', 'end_shot');
		// Luxe.audio.create('assets/end_pickup.ogg', 'end_pickup'); // decided not to use
		Luxe.audio.create('assets/end_sharkus_summon.ogg', 'end_sharkus_summon');
		Luxe.audio.create('assets/end_sharkus_hit.ogg', 'end_sharkus_hit');
		Luxe.audio.create('assets/end_sharkus_destroy.ogg', 'end_sharkus_destroy');
		Luxe.audio.create('assets/end_praetorian_chief.ogg', 'end_praetorian_chief');
		Luxe.audio.create('assets/end_dramatic.ogg', 'end_dramatic');

		Luxe.audio.create('assets/helius_engine1.ogg', 'helius_engine1');
		Luxe.audio.create('assets/helius_engine2.ogg', 'helius_engine2');
		Luxe.audio.create('assets/helius_engine3.ogg', 'helius_engine3');
		Luxe.audio.create('assets/helius_engine4.ogg', 'helius_engine4');
		Luxe.audio.create('assets/helius_engine5.ogg', 'helius_engine5');
		Luxe.audio.create('assets/helius_engine6.ogg', 'helius_engine6');
		Luxe.audio.create('assets/helius_engine7.ogg', 'helius_engine7');

		Luxe.audio.create('assets/calibrate_seed.ogg', 'calibrate_seed');
		Luxe.audio.create('assets/calibrate_grow.ogg', 'calibrate_grow');
		Luxe.audio.create('assets/calibrate_element_spawn.ogg', 'calibrate_element_spawn');
		Luxe.audio.create('assets/calibrate_element_pickup1.ogg', 'calibrate_element_pickup1');
		Luxe.audio.create('assets/calibrate_element_pickup2.ogg', 'calibrate_element_pickup2');
		Luxe.audio.create('assets/calibrate_element_pickup3.ogg', 'calibrate_element_pickup3');
		Luxe.audio.create('assets/calibrate_completed.ogg', 'calibrate_completed');
	}

	public static function loadProgress() {
		// I originally planned to parse from Luxe.io string into game's Bool variables

		// p_cycle = Std.parseInt(Luxe.io.string_load('cycle'));
		// p_calibrate = Luxe.io.string.load('calibrate_enabled');
		// p_harvest = Luxe.io.string.load('harvest_enabled');
		// p_trek = Luxe.io.string.load('trek_enabled');
		// p_end = Luxe.io.string.load('end_enabled');

		// if (p_cycle == null) p_cycle = 0;
		// if (p_calibrate == null) p_calibrate = 0;
		// if (p_harvest == null) p_harvest = 0;
		// if (p_trek == null) p_trek = 0;
		// if (p_end == null) p_end = 0;

		if (Luxe.io.string_load('cycle') == null) {
			p_cycle = 1;
		} else {
			p_cycle = Std.parseInt(Luxe.io.string_load('cycle'));
		};
	}

	public static function updateCycleCount() {
		p_cycle += 1;
		Luxe.io.string_save('cycle', Std.string(p_cycle));
	}

	public static function listenToExplosion() {
		Luxe.events.listen('effect.explosion', function(_e: PosEvent) {
			explodeAt(_e.pos);
		});

		Luxe.events.listen('effect.explosion.large', function(_e: PosEvent) {
			explodeLargeAt(_e.pos);
		});
	}

	public static function explodeAt(_pos: Vector) {
		var amt = Luxe.utils.random.int(C.explosion_amt_min, C.explosion_amt_max);

		for (i in 0...amt) {
			Luxe.timer.schedule(Luxe.utils.random.float(C.explosion_delay_min, C.explosion_delay_max) * i, function(){
				var explosion = new entity.Explosion(new Vector(
					_pos.x + Luxe.utils.random.float(-C.explosion_pos_variance, C.explosion_pos_variance),
					_pos.y + Luxe.utils.random.float(-C.explosion_pos_variance, C.explosion_pos_variance)
				), true);
			});
		}
	}

	public static function explodeLargeAt(_pos: Vector) {
		var amt = Luxe.utils.random.int(C.explosion_large_amt_min, C.explosion_large_amt_max);

		for (i in 0...amt) {
			Luxe.timer.schedule(Luxe.utils.random.float(C.explosion_delay_min, C.explosion_delay_max) * i, function(){
				var explosion = new entity.Explosion(new Vector(
					_pos.x + Luxe.utils.random.float(-C.explosion_large_pos_variance, C.explosion_large_pos_variance),
					_pos.y + Luxe.utils.random.float(-C.explosion_large_pos_variance, C.explosion_large_pos_variance)
				), false);
			});
		}
	}

	public static function clearEntitiesNamed(_name:String) {

		var entities: Array<luxe.Entity> = [];
		Luxe.scene.get_named_like(_name, entities);
		for (ent in entities) {
			var ent: luxe.Entity = cast ent;
			ent.destroy();
		}

	}

	// This is where accelerometer works

	public static var accel_x: Float = 0;
	public static var accel_y: Float = 0;
	public static var accel_z: Float = 0;

	public static var center = new Vector(0, 0);

	override function onevent( ev:SystemEvent ) {

        if(ev.type == SystemEventType.input) {
            if(ev.input.type == InputEventType.joystick) {

                var event : AccelEvent = ev.input.event;
                if(event.axis != null) {
	                switch(event.axis) {   

	                	#if ios
	                		case 1: accel_x = Math.ceil(event.value * 100)/100;
	                    	case 0: accel_y = -Math.ceil(event.value * 100)/100;
	                	#else
	                		case 0: accel_x = Math.ceil(event.value * 100)/100;
	                    	case 1: accel_y = Math.ceil(event.value * 100)/100;
	                	#end
	                    
	                    case 2: accel_z = Math.ceil(event.value * 100)/100;

	                }
	            }
            } //if joystick
        } //if input
    }

    // State-specific functions, hacky stuff again

    public static function trekExpSfx() {
    	var roll: Int = Luxe.utils.random.int(1, 4);

		switch(roll) {
			case 1:
				Luxe.audio.play('trek_exp1');
			case 2:
				Luxe.audio.play('trek_exp2');
			case 3:
				Luxe.audio.play('trek_exp3');
		}
    }


    // post-launch addition, pause menu
    public static function pause() {
        var is_paused = state.enabled('pause');
        if(!is_paused) state.enable('pause');
    }

    public static function addPauseKey() {
    	pauseKey = new entity.PauseKeyGraphic();
    }

    public static function removePauseKey() {
    	pauseKey.destroy();
    }

    override public function onmouseup(e: MouseEvent) {
    	if (pauseKeyIsPresent && hitPause(Luxe.camera.screen_point_to_world(e.pos))) pause();
    }

    public static function hitPause(_pos: Vector): Bool {
    	if (_pos.x > Main.w - 64
    	&& _pos.x < Main.w
    	&& _pos.y > 0
    	&& _pos.y < 64) {
    		return true;
    	} else return false;
    }

}

typedef AccelEvent = {
	timestamp:Float,
	value:Float,
	axis:Null<Int>
}

