// base classes
class rl_Cvars : Thinker
{
	transient Cvar rl_player_shadows;
	transient Cvar rl_player_shadows_on_sprites;
	transient Cvar rl_player_shadows_on_self;
	transient Cvar rl_missile_shadows;
	transient Cvar rl_missile_max_shadows;
	transient Cvar rl_missile_lights;
	transient Cvar rl_missile_light_size;
	transient Cvar rl_missile_light_scale;
	transient Cvar rl_missile_light_limit;

	transient Cvar rl_monster_shadows;
	transient Cvar rl_monster_shadows_on_sprites;
	transient Cvar rl_monster_lights;
	transient Cvar rl_monster_light_size;
	transient Cvar rl_monster_max_shadows;
	transient Cvar rl_monster_light_scale;

	transient Cvar rl_gldefs_shadows;
	transient Cvar rl_pickup_shadows;
	transient Cvar rl_solid_shadows;
	transient Cvar rl_other_shadows;
	transient Cvar rl_other_max_shadows;
	transient Cvar rl_other_lights;
	transient Cvar rl_other_light_size;
	transient Cvar rl_other_light_scale;

	transient CVar rl_lifespan;
	transient CVar rl_interpolate;
	transient CVar rl_blocking_actors;

	transient CVar rl_sprite_min;
	transient CVar rl_sprite_max;
	transient CVar rl_pitch_shadows;
	transient CVar rl_dual_shadows;
	transient CVar rl_long_shadows;
	transient CVar rl_blur_shadows;
	transient CVar rl_wall_shadows_alert;
	transient CVar rl_ghost_lights;
	transient CVar rl_ghost_color;
	transient CVar rl_floor_reflections;
	transient CVar rl_anim_reflections;
	transient CVar rl_floor_value;
	transient CVar rl_floor_seed;
	
	transient Cvar rl_window_lights;
	transient Cvar rl_death_lights;
	transient Cvar rl_texture_lights;
	transient Cvar rl_texture_light_factor;
	transient Cvar rl_sector_lights;
	transient Cvar rl_decorative_lights;
	transient Cvar rl_sector_area_min;
	transient Cvar rl_sector_area_max;
	transient Cvar rl_sector_light_min;
	transient Cvar rl_sector_light_size;
	transient Cvar rl_sector_light_scale;

	transient Cvar rl_shadow_distance;
	transient Cvar rl_shadow_scale;
	transient Cvar rl_sidedef_add;
	transient Cvar rl_sidedef_subtract;
	transient Cvar rl_subtractive_lighting;
	transient Cvar rl_sectors;
	transient Cvar rl_smart_lighting;
	transient Cvar rl_distance3D;

	transient Cvar rl_center_algorithm;
	transient Cvar rl_sector_fog;
	transient Cvar rl_colored_sectors;
	transient Cvar rl_colored_perceived;
	transient Cvar rl_colored_howred;
	transient Cvar rl_colored_howgreen;
	transient Cvar rl_colored_howblue;
	transient Cvar rl_color_bleeding;
	transient Cvar rl_dim_sectors;
	transient Cvar rl_dim_min;
	transient Cvar rl_vol_adj_sectors;
	transient CVar rl_shadow_alpha;
	transient CVar rl_shadow_walpha;

	transient CVar rl_shader;
	transient CVar rl_gamma;
	transient CVar rl_saturation;
	transient CVar rl_bleeding;
	transient CVar rl_rg_bleeding;

	transient Cvar rl_reset;
	transient Cvar rl_dynamic_lights_preset;
	transient Cvar rl_sector_lights_preset;
	transient Cvar rl_sector_light_options_preset;
	transient Cvar rl_shadows_preset;
	transient Cvar rl_shadow_options_preset;
	transient Cvar rl_color_preset;
	transient Cvar rl_shader_preset;
	transient Cvar rl_misc_preset;

	transient bool cvarsLoaded;

	void initialize()
	{
		ChangeStatNum(Thinker.STAT_Info);
		initializeCvars();
	}
	
	void initializeCvars()
	{
		if (cvarsLoaded) return;

		rl_player_shadows = CVar.FindCvar("rl_player_shadows");
		rl_player_shadows_on_sprites = CVar.FindCvar("rl_player_shadows_on_sprites");
		rl_player_shadows_on_self = CVar.FindCvar("rl_player_shadows_on_self");
		rl_missile_shadows = CVar.FindCvar("rl_missile_shadows");
		rl_missile_max_shadows = CVar.FindCvar("rl_missile_max_shadows");
		rl_missile_lights = CVar.FindCvar("rl_missile_lights");
		rl_missile_light_size = CVar.FindCvar("rl_missile_light_size");
		rl_missile_light_scale = CVar.FindCvar("rl_missile_light_scale");
		rl_missile_light_limit = CVar.FindCvar("rl_missile_light_limit");

		rl_monster_shadows = CVar.FindCvar("rl_monster_shadows");
		rl_monster_shadows_on_sprites = CVar.FindCvar("rl_monster_shadows_on_sprites");
		rl_monster_lights = CVar.FindCvar("rl_monster_lights");
		rl_monster_light_size = CVar.FindCvar("rl_monster_light_size");
		rl_monster_max_shadows = CVar.FindCvar("rl_monster_max_shadows");
		rl_monster_light_scale = CVar.FindCvar("rl_monster_light_scale");

		rl_gldefs_shadows = CVar.FindCvar("rl_gldefs_shadows");
		rl_pickup_shadows = CVar.FindCvar("rl_pickup_shadows");
		rl_solid_shadows = CVar.FindCvar("rl_solid_shadows");
		rl_other_shadows = CVar.FindCvar("rl_other_shadows");
		rl_other_max_shadows = CVar.FindCvar("rl_other_max_shadows");
		rl_other_lights = CVar.FindCvar("rl_other_lights");
		rl_other_light_size = CVar.FindCvar("rl_other_light_size");
		rl_other_light_scale = CVar.FindCvar("rl_other_light_scale");

		rl_lifespan = CVar.FindCvar("rl_lifespan");
		rl_interpolate = CVar.FindCVar("rl_interpolate");
		rl_blocking_actors = CVar.FindCVar("rl_blocking_actors");

		rl_sprite_min = CVar.FindCvar("rl_sprite_min");
		rl_sprite_max = CVar.FindCvar("rl_sprite_max");
		rl_pitch_shadows = CVar.FindCvar("rl_pitch_shadows");
		rl_dual_shadows = CVar.FindCvar("rl_dual_shadows");
		rl_long_shadows = CVar.FindCvar("rl_long_shadows");
		rl_blur_shadows = CVar.FindCvar("rl_blur_shadows");
		rl_wall_shadows_alert = CVar.FindCvar("rl_wall_shadows_alert");
		rl_ghost_lights = CVar.FindCvar("rl_ghost_lights");
		rl_ghost_color = CVar.FindCvar("rl_ghost_color");
		rl_floor_reflections = CVar.FindCvar("rl_floor_reflections");
		rl_anim_reflections = CVar.FindCvar("rl_anim_reflections");
		rl_floor_value = CVar.FindCvar("rl_floor_value");
		rl_floor_seed = CVar.FindCvar("rl_floor_seed");

		rl_window_lights = CVar.FindCvar("rl_window_lights");
		rl_death_lights = CVar.FindCvar("rl_death_lights");
		rl_texture_lights = CVar.FindCvar("rl_texture_lights");
		rl_texture_light_factor = CVar.FindCvar("rl_texture_light_factor");
		rl_sector_lights = CVar.FindCvar("rl_sector_lights");
		rl_decorative_lights = CVar.FindCvar("rl_decorative_lights");
		rl_sector_area_min = CVar.FindCvar("rl_sector_area_min");
		rl_sector_area_max = CVar.FindCvar("rl_sector_area_max");
		rl_sector_light_min = CVar.FindCvar("rl_sector_light_min");
		rl_sector_light_size = CVar.FindCvar("rl_sector_light_size");
		rl_sector_light_scale = CVar.FindCvar("rl_sector_light_scale");

		rl_shadow_distance = CVar.FindCvar("rl_shadow_distance");
		rl_shadow_scale = CVar.FindCvar("rl_shadow_scale");
		rl_sidedef_add = CVar.FindCvar("rl_sidedef_add");
		rl_sidedef_subtract = CVar.FindCvar("rl_sidedef_subtract");
		rl_subtractive_lighting = CVar.FindCvar("rl_subtractive_lighting");
		rl_sectors = CVar.FindCvar("rl_sectors");
		rl_smart_lighting = CVar.FindCvar("rl_smart_lighting");
		rl_distance3D = CVar.FindCvar("rl_distance3D");

		rl_center_algorithm = CVar.FindCvar("rl_center_algorithm");
		rl_sector_fog = CVar.FindCvar("rl_sector_fog");
		rl_colored_sectors = CVar.FindCvar("rl_colored_sectors");
		rl_colored_perceived = CVar.FindCvar("rl_colored_perceived");
		rl_colored_howred = CVar.FindCvar("rl_colored_howred");
		rl_colored_howgreen = CVar.FindCvar("rl_colored_howgreen");
		rl_colored_howblue = CVar.FindCvar("rl_colored_howblue");
		rl_color_bleeding = CVar.FindCvar("rl_color_bleeding");
		rl_dim_sectors = CVar.FindCvar("rl_dim_sectors");
		rl_dim_min = CVar.FindCvar("rl_dim_min");
		rl_vol_adj_sectors = CVar.FindCvar("rl_vol_adj_sectors");
		rl_shadow_alpha = CVar.FindCvar("rl_shadow_alpha");
		rl_shadow_walpha = CVar.FindCvar("rl_shadow_walpha");

		rl_shader = CVar.FindCvar("rl_shader");
		rl_gamma = CVar.FindCvar("rl_gamma");
		rl_saturation = CVar.FindCvar("rl_saturation");
		rl_bleeding = CVar.FindCvar("rl_bleeding");
		rl_rg_bleeding = CVar.FindCvar("rl_rg_bleeding");

		rl_reset = CVar.FindCvar("rl_reset");
		rl_dynamic_lights_preset = CVar.FindCvar("rl_dynamic_lights_preset");
		rl_sector_lights_preset = CVar.FindCvar("rl_sector_lights_preset");
		rl_sector_light_options_preset = CVar.FindCvar("rl_sector_light_options_preset");
		rl_shadows_preset = CVar.FindCvar("rl_shadows_preset");
		rl_shadow_options_preset = CVar.FindCvar("rl_shadow_options_preset");
		rl_color_preset = CVar.FindCvar("rl_color_preset");
		rl_shader_preset = CVar.FindCvar("rl_shader_preset");
		rl_misc_preset = CVar.FindCvar("rl_misc_preset");
		
		cvarsLoaded = true;
	}

	static rl_Cvars get()
	{
		let it = ThinkerIterator.create("rl_Cvars", Thinker.STAT_Info);
		let ret = rl_Cvars(it.next());

		if (!ret)
		{
			ret = new("rl_Cvars");
			ret.initialize();
		}
		else
		{
			ret.initialize();
		}

		return ret;
	}

	static void setPreset(string rl_cvar, int preset)
	{
		if (preset == 0) return;

	}

	static void setDefaults()
	{
		Cvar.FindCvar("rl_player_shadows").ResetToDefault();
		Cvar.FindCvar("rl_player_shadows_on_sprites").ResetToDefault();
		Cvar.FindCvar("rl_player_shadows_on_self").ResetToDefault();
		Cvar.FindCvar("rl_missile_shadows").ResetToDefault();
		Cvar.FindCvar("rl_missile_max_shadows").ResetToDefault();
		Cvar.FindCvar("rl_missile_lights").ResetToDefault();
		Cvar.FindCvar("rl_missile_light_size").ResetToDefault();
		Cvar.FindCvar("rl_missile_light_scale").ResetToDefault();
		Cvar.FindCvar("rl_missile_light_limit").ResetToDefault();
		Cvar.FindCvar("rl_monster_shadows").ResetToDefault();
		Cvar.FindCvar("rl_monster_shadows_on_sprites").ResetToDefault();
		Cvar.FindCvar("rl_monster_max_shadows").ResetToDefault();
		Cvar.FindCvar("rl_monster_lights").ResetToDefault();
		Cvar.FindCvar("rl_monster_light_size").ResetToDefault();
		Cvar.FindCvar("rl_monster_light_scale").ResetToDefault();
		Cvar.FindCvar("rl_gldefs_shadows").ResetToDefault();
		Cvar.FindCvar("rl_pickup_shadows").ResetToDefault();
		Cvar.FindCvar("rl_solid_shadows").ResetToDefault();
		Cvar.FindCvar("rl_other_shadows").ResetToDefault();
		Cvar.FindCvar("rl_other_max_shadows").ResetToDefault();
		Cvar.FindCvar("rl_other_lights").ResetToDefault();
		Cvar.FindCvar("rl_other_light_size").ResetToDefault();
		Cvar.FindCvar("rl_other_light_scale").ResetToDefault();
		Cvar.FindCvar("rl_lifespan").ResetToDefault();
		Cvar.FindCvar("rl_interpolate").ResetToDefault();
		Cvar.FindCvar("rl_blocking_actors").ResetToDefault();
		Cvar.FindCvar("rl_sprite_min").ResetToDefault();
		Cvar.FindCvar("rl_sprite_max").ResetToDefault();
		Cvar.FindCvar("rl_pitch_shadows").ResetToDefault();
		Cvar.FindCvar("rl_dual_shadows").ResetToDefault();
		Cvar.FindCvar("rl_long_shadows").ResetToDefault();
		Cvar.FindCvar("rl_blur_shadows").ResetToDefault();
		Cvar.FindCvar("rl_wall_shadows_alert").ResetToDefault();
		Cvar.FindCvar("rl_ghost_lights").ResetToDefault();
		Cvar.FindCvar("rl_ghost_color").ResetToDefault();
		Cvar.FindCvar("rl_floor_reflections").ResetToDefault();
		Cvar.FindCvar("rl_anim_reflections").ResetToDefault();
		Cvar.FindCvar("rl_floor_value").ResetToDefault();
		Cvar.FindCvar("rl_window_lights").ResetToDefault();
		Cvar.FindCvar("rl_death_lights").ResetToDefault();
		Cvar.FindCvar("rl_texture_lights").ResetToDefault();
		Cvar.FindCvar("rl_texture_light_factor").ResetToDefault();
		Cvar.FindCvar("rl_sector_lights").ResetToDefault();
		Cvar.FindCvar("rl_decorative_lights").ResetToDefault();
		Cvar.FindCvar("rl_sector_area_min").ResetToDefault();
		Cvar.FindCvar("rl_sector_area_max").ResetToDefault();
		Cvar.FindCvar("rl_sector_light_min").ResetToDefault();
		Cvar.FindCvar("rl_sector_light_size").ResetToDefault();
		Cvar.FindCvar("rl_sector_light_scale").ResetToDefault();
		Cvar.FindCvar("rl_shadow_distance").ResetToDefault();
		Cvar.FindCvar("rl_shadow_scale").ResetToDefault();
		Cvar.FindCvar("rl_sidedef_add").ResetToDefault();
		Cvar.FindCvar("rl_sidedef_subtract").ResetToDefault();
		Cvar.FindCvar("rl_subtractive_lighting").ResetToDefault();
		Cvar.FindCvar("rl_sectors").ResetToDefault();
		Cvar.FindCvar("rl_smart_lighting").ResetToDefault();
		Cvar.FindCvar("rl_distance3D").ResetToDefault();
		Cvar.FindCvar("rl_center_algorithm").ResetToDefault();
		Cvar.FindCvar("rl_sector_fog").ResetToDefault();
		Cvar.FindCvar("rl_colored_sectors").ResetToDefault();
		Cvar.FindCvar("rl_colored_perceived").ResetToDefault();
		Cvar.FindCvar("rl_colored_howred").ResetToDefault();
		Cvar.FindCvar("rl_colored_howgreen").ResetToDefault();
		Cvar.FindCvar("rl_colored_howblue").ResetToDefault();
		Cvar.FindCvar("rl_color_bleeding").ResetToDefault();
		Cvar.FindCvar("rl_dim_sectors").ResetToDefault();
		Cvar.FindCvar("rl_dim_min").ResetToDefault();
		Cvar.FindCvar("rl_vol_adj_sectors").ResetToDefault();
		Cvar.FindCvar("rl_shadow_alpha").ResetToDefault();
		Cvar.FindCvar("rl_shadow_walpha").ResetToDefault();
		Cvar.FindCvar("rl_shader").ResetToDefault();
		Cvar.FindCvar("rl_gamma").ResetToDefault();
		Cvar.FindCvar("rl_saturation").ResetToDefault();
		Cvar.FindCvar("rl_bleeding").ResetToDefault();
		Cvar.FindCvar("rl_rg_bleeding").ResetToDefault();
		Cvar.FindCvar("rl_reset").ResetToDefault();
		Cvar.FindCvar("rl_dynamic_lights_preset").ResetToDefault();
		Cvar.FindCvar("rl_sector_lights_preset").ResetToDefault();
		Cvar.FindCvar("rl_sector_light_options_preset").ResetToDefault();
		Cvar.FindCvar("rl_shadows_preset").ResetToDefault();
		Cvar.FindCvar("rl_shadow_options_preset").ResetToDefault();
		Cvar.FindCvar("rl_color_preset").ResetToDefault();
		Cvar.FindCvar("rl_shader_preset").ResetToDefault();
		Cvar.FindCvar("rl_misc_preset").ResetToDefault();
	}
}

