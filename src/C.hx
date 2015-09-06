package;

import luxe.Color;

class C {

	#if ios
		public static var player_speed: Int = 7000;
	#else
		public static var player_speed: Int = 2000;
	#end

	// Menu ========================

	public static var button_w: Float = 320;
	public static var button_h: Float = 90;

	public static var reset_hold_time: Float = 3;

	// Calibrate ========================

	public static var nexus_pressor_time: Float = 1;
	public static var nexus_grow_time: Float = 2;
	public static var nexus_delay_time: Float = 1;

	public static var element_pressor_time: Float = 1;
	public static var element_grow_time: Float = 0.5;
	public static var element_delay_time: Float = 0.5;

	public static var core_grow_time: Float = 4.7;

	public static var nexus_grown_rotation: Float = 180;
	public static var nexus_grown_radius: Float = 192;

	public static var element_radius_indicator_extra: Float = 24;

	// elemo: element component
	public static var elemo_orbit_spd_variance: Float = Math.PI;
	public static var elemo_rotat_spd_variance: Float = 45;

	// Harvest ========================

	public static var counter_delay_time: Float = 0.75;

	public static var karl_radius: Float = 16;

	public static var counter_size: Float = 64;
	public static var countercore_size: Float = 54;
	public static var harvester_time: Float = 0.5;

	public static var shot_harvest_radius: Float = 12;
	public static var harvester_harvest_radius: Float = 20;

	public static var sonic_wave_radius_max: Float = 720;

	public static var harvest_total_time: Float = 60;
	public static var harvest_timemark_1: Float = 15;
	public static var harvest_timemark_2: Float = 25;
	public static var harvest_timemark_3: Float = 50;

	// Trek ========================

	public static var trek_total_time: Float = 140;
	public static var trek_timemark1: Float = 40;
	public static var trek_timemark2: Float = 100;

	public static var harvest_cooldown: Float = 1;

	public static var shot_speed: Float = 1500;
	public static var shot_trek_radius: Float = 24;

	public static var bullet_trek_speed: Float = 400;
	public static var bullet_trek_radius: Float = 16;

	public static var ayu_rof: Float = 1.7;
	public static var ayu_speed: Float = 180;

	public static var krist_speed: Float = 170;
	public static var krist_speed_variance: Float = 50;

	// usual aka large
	public static var krist_radius: Float = 64;
	public static var krist_radius_variance: Float = 24;
	public static var esth_radius_min: Float = 64;
	public static var esth_radius_max: Float = 96;

	// isSmall == true
	public static var krist_small_radius: Float = 32;
	public static var krist_small_radius_variance: Float = 12;
	public static var esth_small_radius_min: Float = 24;
	public static var esth_small_radius_max: Float = 48;

	//Hessel
	public static var hessel_radius: Float = 16;
	public static var hessel_flash_cooldown: Float = 2;

	public static var killbounds_vertical: Int = 100;
	public static var killbounds_horizontal: Int = 200;

	// Spawner
	public static var trek_spawn_ayu_min: Float = 1.0;
	public static var trek_spawn_ayu_max: Float = 4.5;
	public static var trek_spawn_krist_min: Float = 0.74;
	public static var trek_spawn_krist_max: Float = 2.7;
	public static var trek_spawn_hessel_min: Float = 2.0;
	public static var trek_spawn_hessel_max: Float = 6.0;

	// public static var ayu_value: Int = 10; // value when hit

	// End ========================

	public static var reload_cooldown_first = 1.2;
	public static var reload_cooldown_sub = 0.55;

	public static var barrier_radius: Float = 92;
	public static var barrier_radius_exrate: Float = 1.05;

	public static var shot_end_radius: Float = 16;

	public static var bullet_end_radius: Float = 16;
	public static var bullet_end_speed: Float = 400;

	public static var shard_cooldown: Float = 0.25;
	public static var chunk_cooldown: Float = 0.74;

	public static var sharkus_radius: Float = 32;
	public static var sharkus_maxHP: Int = 3;

	public static var rail_lifetime: Float = 0.2;
	public static var rail_width: Float = 12;
	public static var rail_width2: Float = 24;

	public static var barrage_time: Float = 20;
	public static var barrage_time_railtop: Float = 10;
	public static var barrageFire_delay: Float = 3;

	public static var engine_cooldown_min: Float = 4;
	public static var engine_cooldown_max: Float = 7;

	// Shared ==========================

	// normal explosions, isSmall == true
	public static var explosion_amt_min: Float = 3;
	public static var explosion_amt_max: Float = 6;
	public static var explosion_pos_variance: Float = 32;

	// large explosion
	public static var explosion_large_amt_min: Float = 5;
	public static var explosion_large_amt_max: Float = 10;
	public static var explosion_large_pos_variance: Float = 64;

	public static var explosion_scale_min: Float = 0.8;
	public static var explosion_scale_max: Float = 1.2;
	public static var explosion_time_min: Float = 0.25;
	public static var explosion_time_max: Float = 0.35;
	public static var explosion_delay_min: Float = 0.02;
	public static var explosion_delay_max: Float = 0.06;
}