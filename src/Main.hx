package;

import luxe.Screen.WindowEvent;

import luxe.Camera;
import luxe.Vector;
import luxe.Text;

import luxe.States;
import states.Play;
import states.Splash;
import snow.types.Types;

class Main extends luxe.Game {

	// Optional values,
	// useful when game does not fully cover the
	// entire screen, great to use when
	// Luxe.camera.size_mode == SizeMode.fit
	public static var w: Int = 1280;
	public static var h: Int = 720;

	public static var debug: Text;

	var initialState:String = 'play'; // First state to run, in string (luxe.States.State.name), refer to state's file
	var showCursor:Bool = true; // Quick setting, whether to display system cursor in-game, useful for custom cursor or certain genres of action games

	public static var state: States;

	override function config(config:luxe.AppConfig):luxe.AppConfig {

		// Preloading resources
		// Resources in Luxe are generally required
		// to be pre-loaded before used
		config.preload.textures = [
			{id: 'assets/logo_box.png'},
			// {id: 'assets/dulce.png'},
			{id: 'assets/Ring.png'},
		];

		return config;
	}

	// Scale camera's viewport accordingly when game is scaled, common and suitable for most games
	override function onwindowsized( e:WindowEvent ) {
        Luxe.camera.viewport = new luxe.Rectangle( 0, 0, e.event.x, e.event.y);
    }

	override function ready() {

		// Optional, set a consistent scale camera mode for the entire game
		// this is a luxe's wip feature
		Luxe.camera.size = new Vector(Main.w, Main.h);
		Luxe.camera.size_mode = SizeMode.fit;

		// Optional, set customized background color
		// Luxe.renderer.clear_color = new Color().rgb(0xD7D7D7);

		// Actual codes that hide/show the cursor
		Luxe.screen.cursor.visible = showCursor;

		debug = new Text({});

		// Create a state machine
		state = new States( { name: "states" } );

		// Add states to the state machine
		state.add (new Play({name: 'play'}));
		state.add (new Splash({name: 'splash'}));

		// Run the inital state upon running the game
		state.set(initialState);

	}

	public static var accel_x: Float = 0;
	public static var accel_y: Float = 0;
	public static var accel_z: Float = 0;

	override function onevent( ev:SystemEvent ) {

		// if (state.current_state.name == 'play') { 
	        if(ev.type == SystemEventType.input) {
	            if(ev.input.type == InputEventType.joystick) {

	                var event : AccelEvent = ev.input.event;
	                switch(event.axis) {
	                    case 0: accel_x = event.value;
	                    case 1: accel_y = event.value;
	                    case 2: accel_z = event.value;

	                    // Luxe.events.fire('accelAxis', {
	                    // 	x: accel_x,
	                    // 	y: accel_y,
	                    // 	z: accel_z
	                    // });

	                    // debug.text = accel_x + '\n' + accel_y;
	                }

	            } //if joystick
	        } //if input
		// }
    }

}
