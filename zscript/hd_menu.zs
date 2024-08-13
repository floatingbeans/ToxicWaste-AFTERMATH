class relighting_OptionMenu : OptionMenu
{
	static const string tips[] =
	{
		"",
		"",
		"",
		"",
		"",
		"Dynamic light size and scale added to spawned items (uses GLDEF lump)",
		"Where lightsources are placed in the map. These affect light baking and sprite shadows",
		"How light is baked, added to textures, other options",
		"How shadows are added to spawned items",
		"Miscellaneous shadow options that control quality, types of shadows, other options",
		"How color is interpreted when reading flats and textures",
		"How pixel color is interpreted and modified",
		"Miscellaneous options for extra lights and floor reflections",
		"Choose On and restart to reset all variables to default values or reset in submenus"
	};
	override void Init(Menu parent, OptionMenuDescriptor desc)
	{
		super.Init(parent, desc);
	}
	override void Drawer()
	{
		super.Drawer();
		if (mDesc.mSelectedItem == -1) return;

		string tip = tips[mDesc.mSelectedItem];
		let ofont = OptionFont();
		Screen.DrawText(ofont, Font.CR_WHITE, (Screen.GetWidth() / 2) - ((ofont.StringWidth(tip) / 2 * CleanXfac_1 / 2) * 2), 
			ofont.GetHeight() * CleanYfac_1 * (tips.Size() + 3), tip, DTA_ScaleX, 2.0, DTA_ScaleY, 2.0);
	}
}
class relighting_dynamic_lights_Menu : OptionMenu
{
	static const string tips[] =
	{
		"Turn Off to disable missile lights",
		"Controls the size (intensity) of the dynamic lights attached to missiles",
		"Controls how shadows react to the light emitted by the missile",
		"How many exist in a sector at any one time",
		"Turn Off to disable monster lights",
		"Controls the size (intensity) of the dynamic lights attached to monsters",
		"Controls how shadows react to the light emitted by the monster",
		"Turn Off to disable other lights",
		"Controls the size (intensity) of the dynamic lights attached to others",
		"Controls how shadows react to light emitted by others",
		""
	};
	override void Init(Menu parent, OptionMenuDescriptor desc)
	{
		super.Init(parent, desc);
	}
	bool bEnter;
	override bool MenuEvent(int mkey, bool fromcontroller)
	{
		super.MenuEvent(mkey, fromcontroller);
		self.bEnter = mkey == MKEY_Enter;
		return true;
	}
	void reset()
	{
		CVar.FindCVar("rl_missile_lights").ResetToDefault();
		CVar.FindCVar("rl_missile_light_size").ResetToDefault();
		CVar.FindCVar("rl_missile_light_scale").ResetToDefault();
		CVar.FindCVar("rl_missile_light_limit").ResetToDefault();
		CVar.FindCVar("rl_monster_lights").ResetToDefault();
		CVar.FindCVar("rl_monster_light_size").ResetToDefault();
		CVar.FindCVar("rl_monster_light_scale").ResetToDefault();
		CVar.FindCVar("rl_other_lights").ResetToDefault();
		CVar.FindCVar("rl_other_light_size").ResetToDefault();
		CVar.FindCVar("rl_other_light_scale").ResetToDefault();
	}
	override void Drawer()
	{
		super.Drawer();
		if (mDesc.mSelectedItem == -1) return;

		string tip = tips[mDesc.mSelectedItem];

		if (mDesc.mSelectedItem == tips.Size() - 1)
		{
			int select = Cvar.FindCvar("rl_dynamic_lights_preset").GetInt();
			if (self.bEnter)
			{
				select = select == 0 ? 4 : --select;
				Cvar.FindCvar("rl_dynamic_lights_preset").SetInt(select);
				mDesc.mSelectedItem = 0; 
				switch(select)
				{
					case 0:
						break;
					case 1: // default
						reset();
						break;
					case 2: // performance
						reset();
						CVar.FindCVar("rl_missile_light_size").SetInt(5);
						CVar.FindCVar("rl_missile_light_scale").SetFloat(0.5);
						CVar.FindCVar("rl_missile_light_limit").SetInt(1);
						CVar.FindCVar("rl_monster_lights").SetBool(false);
						CVar.FindCVar("rl_other_lights").SetBool(false);
						break;
					case 3: // more light
						reset();
						CVar.FindCVar("rl_missile_light_size").SetInt(15);
						CVar.FindCVar("rl_missile_light_scale").SetFloat(1.5);
						CVar.FindCVar("rl_missile_light_limit").SetInt(5);
						CVar.FindCVar("rl_other_light_size").SetInt(10);
						CVar.FindCVar("rl_other_light_scale").SetFloat(1.0);
						break;
					case 4: // less light
						reset();
						CVar.FindCVar("rl_other_light_size").SetInt(2);
						CVar.FindCVar("rl_other_light_scale").SetFloat(0.3);
						break;
				};
			}
			else
			{
				switch(select)
				{
					case 0:
						tip = "No changes to settings";
						break;
					case 1:
						tip = "ENTER to set Reset to Defaults";
						break;
					case 2:
						tip = "ENTER to set Performance";
						break;
					case 3:
						tip = "ENTER to set More light";
						break;
					case 4:
						tip = "ENTER to set Less light";
						break;
				};
			}

		}
		let ofont = OptionFont();
		Screen.DrawText(ofont, Font.CR_WHITE, (Screen.GetWidth() / 2) - ((ofont.StringWidth(tip) / 2 * CleanXfac_1 / 2) * 2), 
			ofont.GetHeight() * CleanYfac_1 * (tips.Size() + 3), tip, DTA_ScaleX, 2.0, DTA_ScaleY, 2.0);
	}
}
class relighting_sector_lights_Menu : OptionMenu
{
	static const string tips[] =
	{
		"Adds sector based light sources",
		"Adds decorative based light sources (lamps, torches, etc.)",
		"Smallest sector area for a light source (increase to limit sector light sources, adj @ runtime)",
		"Largest sector area for a light source (decrease to limit sector light sources)",
		"Minimum sector light level for a light source (decrease for more light sources)",
		"Controls the size of dynamic lights attached to the light source",
		"Controls how the light sources bake lights and how sprite shadows react",
		""
	};
	override void Init(Menu parent, OptionMenuDescriptor desc)
	{
		super.Init(parent, desc);
	}
	bool bEnter;
	override bool MenuEvent(int mkey, bool fromcontroller)
	{
		super.MenuEvent(mkey, fromcontroller);
		self.bEnter = mkey == MKEY_Enter;
		return true;
	}
	void reset()
	{
		CVar.FindCVar("rl_sector_lights").ResetToDefault();
		CVar.FindCVar("rl_decorative_lights").ResetToDefault();
		CVar.FindCVar("rl_sector_area_min").ResetToDefault();
		CVar.FindCVar("rl_sector_area_max").ResetToDefault();
		CVar.FindCVar("rl_sector_light_min").ResetToDefault();
		CVar.FindCVar("rl_sector_light_size").ResetToDefault();
		CVar.FindCVar("rl_sector_light_scale").ResetToDefault();
	}
	override void Drawer()
	{
		super.Drawer();
		if (mDesc.mSelectedItem == -1) return;

		string tip = tips[mDesc.mSelectedItem];
		if (mDesc.mSelectedItem == tips.Size() - 1)
		{
			int select = Cvar.FindCvar("rl_sector_lights_preset").GetInt();
			if (self.bEnter)
			{
				select = select == 0 ? 4 : --select;
				Cvar.FindCvar("rl_sector_lights_preset").SetInt(select);
				mDesc.mSelectedItem = 0; 
				switch(select)
				{
					case 0:
						break;
					case 1: // default
						reset();
						break;
					case 2: // performance
						reset();
						CVar.FindCVar("rl_decorative_lights").SetBool(false);
						CVar.FindCVar("rl_sector_area_min").SetInt(256);
						CVar.FindCVar("rl_sector_area_max").SetInt(5120);
						CVar.FindCVar("rl_sector_light_size").SetInt(1);
						CVar.FindCVar("rl_sector_light_scale").SetFloat(1.0);
						break;
					case 3: // more light
						reset();
						CVar.FindCVar("rl_sector_light_min").SetInt(144);
						CVar.FindCVar("rl_sector_light_size").SetInt(10);
						break;
					case 4: // less light
						reset();
						CVar.FindCVar("rl_sector_lights").SetBool(false);
						CVar.FindCVar("rl_sector_light_min").SetInt(225);
						CVar.FindCVar("rl_sector_light_size").SetInt(1);
						CVar.FindCVar("rl_sector_light_scale").SetFloat(2.0);
						break;
				};
			}
			else
			{
				switch(select)
				{
					case 0:
						tip = "No changes to settings";
						break;
					case 1:
						tip = "ENTER to set Reset to Defaults";
						break;
					case 2:
						tip = "ENTER to set Performance";
						break;
					case 3:
						tip = "ENTER to set More light";
						break;
					case 4:
						tip = "ENTER to set Less light";
						break;
				};
			}
		}
		let ofont = OptionFont();
		Screen.DrawText(ofont, Font.CR_WHITE, (Screen.GetWidth() / 2) - ((ofont.StringWidth(tip) / 2 * CleanXfac_1 / 2) * 2), 
			ofont.GetHeight() * CleanYfac_1 * (tips.Size() + 3), tip, DTA_ScaleX, 2.0, DTA_ScaleY, 2.0);
	}
}
class relighting_sector_light_options_Menu : OptionMenu
{
	static const string tips[] =
	{
		"Controls how much light is absorbed by wall textures from light sources",
		"Controls how dark textures become in the absence of light",
		"Adds subtractive dynamic lights to certain dark wall textures",
		"Adds dynamic sector light changes caused by missiles and doors opening",
		"Adds additional tweaks to lighting and light levels based on the map",
		"Adds pitched spotlights in windows extending the reach of light sources",
		"Adds pitched spotlights for missiles and solid objects with a Death state",
		"Adds dynamic lights to narrower walls of brighter/smaller sectors",
		"Controls how texture lights are added (decrease to add more)",
		"Adds more darkness to large, already darkened sectors",
		"Spreads darkness into other sectors",
		"Controls how dim sectors become (multipled by the minimum sector light)",
		""
	};
	override void Init(Menu parent, OptionMenuDescriptor desc)
	{
		super.Init(parent, desc);
	}
	bool bEnter;
	override bool MenuEvent(int mkey, bool fromcontroller)
	{
		super.MenuEvent(mkey, fromcontroller);
		self.bEnter = mkey == MKEY_Enter;
		return true;
	}
	void reset()
	{
		CVar.FindCVar("rl_sidedef_add").ResetToDefault();
		CVar.FindCVar("rl_sidedef_subtract").ResetToDefault();
		CVar.FindCVar("rl_subtractive_lighting").ResetToDefault();
		CVar.FindCVar("rl_sectors").ResetToDefault();
		CVar.FindCVar("rl_smart_lighting").ResetToDefault();
		CVar.FindCVar("rl_window_lights").ResetToDefault();
		CVar.FindCVar("rl_death_lights").ResetToDefault();
		CVar.FindCVar("rl_texture_lights").ResetToDefault();
		CVar.FindCVar("rl_texture_light_factor").ResetToDefault();
		CVar.FindCVar("rl_vol_adj_sectors").ResetToDefault();
		CVar.FindCVar("rl_dim_sectors").ResetToDefault();
		CVar.FindCVar("rl_dim_min").ResetToDefault();
	}
	override void Drawer()
	{
		super.Drawer();
		if (mDesc.mSelectedItem == -1) return;

		string tip = tips[mDesc.mSelectedItem];
		if (mDesc.mSelectedItem == tips.Size() - 1)
		{
			int select = Cvar.FindCvar("rl_sector_light_options_preset").GetInt();
			if (self.bEnter)
			{
				select = select == 0 ? 4 : --select;
				Cvar.FindCvar("rl_sector_light_options_preset").SetInt(select);
				mDesc.mSelectedItem = 0; 
				switch(select)
				{
					case 0:
						break;
					case 1: // default
						reset();
						break;
					case 2: // performance
						reset();
						CVar.FindCVar("rl_subtractive_lighting").SetBool(false);
						CVar.FindCVar("rl_smart_lighting").SetBool(false);
						CVar.FindCVar("rl_window_lights").SetBool(false);
						CVar.FindCVar("rl_death_lights").SetBool(false);
						CVar.FindCVar("rl_texture_lights").SetBool(false);
						break;
					case 3: // more light
						reset();
						CVar.FindCVar("rl_sidedef_add").SetInt(150);
						CVar.FindCVar("rl_texture_light_factor").SetFloat(0.75);
						CVar.FindCVar("rl_dim_sectors").SetBool(false);
						break;
					case 4: // less light
						reset();
						CVar.FindCVar("rl_sidedef_add").SetInt(50);
						CVar.FindCVar("rl_sidedef_subtract").SetInt(100);
						CVar.FindCVar("rl_window_lights").SetBool(false);
						CVar.FindCVar("rl_death_lights").SetBool(false);
						CVar.FindCVar("rl_texture_light_factor").SetFloat(1.25);
						CVar.FindCVar("rl_dim_sectors").SetFloat(0.75);
						break;
				};
			}
			else
			{
				switch(select)
				{
					case 0:
						tip = "No changes to settings";
						break;
					case 1:
						tip = "ENTER to set Reset to Defaults";
						break;
					case 2:
						tip = "ENTER to set Performance";
						break;
					case 3:
						tip = "ENTER to set More light";
						break;
					case 4:
						tip = "ENTER to set Less light";
						break;
				};
			}
		}
		let ofont = OptionFont();
		Screen.DrawText(ofont, Font.CR_WHITE, (Screen.GetWidth() / 2) - ((ofont.StringWidth(tip) / 2 * CleanXfac_1 / 2) * 2), 
			ofont.GetHeight() * CleanYfac_1 * (tips.Size() + 3), tip, DTA_ScaleX, 2.0, DTA_ScaleY, 2.0);
	}
}
class relighting_shadows_Menu : OptionMenu
{
	static const string tips[] =
	{
		"Adds Player sprite shadow",
		"Adds Player shadow on self in darker sectors",
		"Adds Player shadow on sprites",
		"Adds missile sprite shadows",
		"Controls number of missile shadows",
		"Adds monster sprite shadows",
		"Adds monster shadow on sprites",
		"Controls number of monster shadows",
		"Adds sprite shadows to items with a dynamic light defined in GLDEF",
		"Adds sprite shadows to inventory items",
		"Adds sprite shadows to solid items",
		"Adds sprite shadows to other items",
		"Controls number of non-missile, non-monster shadows",
		""
	};
	override void Init(Menu parent, OptionMenuDescriptor desc)
	{
		super.Init(parent, desc);
	}
	bool bEnter;
	override bool MenuEvent(int mkey, bool fromcontroller)
	{
		super.MenuEvent(mkey, fromcontroller);
		self.bEnter = mkey == MKEY_Enter;
		return true;
	}
	void reset()
	{
		CVar.FindCVar("rl_player_shadows").ResetToDefault();
		CVar.FindCVar("rl_player_shadows_on_self").ResetToDefault();
		CVar.FindCVar("rl_player_shadows_on_sprites").ResetToDefault();
		CVar.FindCVar("rl_missile_shadows").ResetToDefault();
		CVar.FindCVar("rl_missile_max_shadows").ResetToDefault();
		CVar.FindCVar("rl_monster_shadows").ResetToDefault();
		CVar.FindCVar("rl_monster_shadows_on_sprites").ResetToDefault();
		CVar.FindCVar("rl_monster_max_shadows").ResetToDefault();
		CVar.FindCVar("rl_gldefs_shadows").ResetToDefault();
		CVar.FindCVar("rl_pickup_shadows").ResetToDefault();
		CVar.FindCVar("rl_solid_shadows").ResetToDefault();
		CVar.FindCVar("rl_other_shadows").ResetToDefault();
		CVar.FindCVar("rl_other_max_shadows").ResetToDefault();
	}
	override void Drawer()
	{
		super.Drawer();
		if (mDesc.mSelectedItem == -1) return;

		string tip = tips[mDesc.mSelectedItem];
		if (mDesc.mSelectedItem == tips.Size() - 1)
		{
			int select = Cvar.FindCvar("rl_shadows_preset").GetInt();
			if (self.bEnter)
			{
				select = select == 0 ? 2 : --select;
				Cvar.FindCvar("rl_shadows_preset").SetInt(select);
				mDesc.mSelectedItem = 0; 
				switch(select)
				{
					case 0:
						break;
					case 1: // default
						reset();
						break;
					case 2: // performance
						reset();
						CVar.FindCVar("rl_player_shadows_on_self").SetBool(false);
						CVar.FindCVar("rl_player_shadows_on_sprites").SetBool(false);
						CVar.FindCVar("rl_missile_max_shadows").SetInt(3);
						CVar.FindCVar("rl_pickup_shadows").SetBool(false);
						CVar.FindCVar("rl_other_shadows").SetBool(false);
						break;
				};
			}
			else
			{
				switch(select)
				{
					case 0:
						tip = "No changes to settings";
						break;
					case 1:
						tip = "ENTER to set Reset to Defaults";
						break;
					case 2:
						tip = "ENTER to set Performance";
						break;
				};
			}
		}
		let ofont = OptionFont();
		Screen.DrawText(ofont, Font.CR_WHITE, (Screen.GetWidth() / 2) - ((ofont.StringWidth(tip) / 2 * CleanXfac_1 / 2) * 2), 
			ofont.GetHeight() * CleanYfac_1 * (tips.Size() + 3), tip, DTA_ScaleX, 2.0, DTA_ScaleY, 2.0);
	}
}
class relighting_shadow_options_Menu : OptionMenu
{
	static const string tips[] =
	{
		"Controls how far away from the player sprite shadows are shown",
		"Controls how large sprite shadows become",
		"Uses a more accurate calculation of distance from light sources when shadows are shown",
		"Controls lifespan of a shadow position (anything over 3 is increased by distance from the player)",
		"Adds sprite shadow interpolation (may reduce flickering)",
		"Actors will hide sprite shadows of those in front of them (performance)",
		"Sprite shadows adjust according to the height and pitch of the light source",
		"Adds a second sprite shadow if there is another light source",
		"Adds wall sprite shadows beyong the length of the floor shadow (usually with a flashlight)",
		"Floor and ceiling shadows are projected like wall shadows",
		"Monsters will be alerted by only your shadow",
		"",
		"Controls the minimum sprite size that allows a shadow (adj by number of actors on the map)",
		"Controls the maximum sprite size that allows a shadow",
		"Controls the darkness of floor shadows",
		"Controls the darkness of wall shadows",
		""
	};
	override void Init(Menu parent, OptionMenuDescriptor desc)
	{
		super.Init(parent, desc);
	}
	bool bEnter;
	override bool MenuEvent(int mkey, bool fromcontroller)
	{
		super.MenuEvent(mkey, fromcontroller);
		self.bEnter = mkey == MKEY_Enter;
		return true;
	}
	void reset()
	{
		CVar.FindCVar("rl_shadow_distance").ResetToDefault();
		CVar.FindCVar("rl_shadow_scale").ResetToDefault();
		CVar.FindCVar("rl_distance3D").ResetToDefault();
		CVar.FindCVar("rl_lifespan").ResetToDefault();
		CVar.FindCVar("rl_interpolate").ResetToDefault();
		CVar.FindCVar("rl_blocking_actors").ResetToDefault();
		CVar.FindCVar("rl_pitch_shadows").ResetToDefault();
		CVar.FindCVar("rl_dual_shadows").ResetToDefault();
		CVar.FindCVar("rl_long_shadows").ResetToDefault();
		CVar.FindCVar("rl_blur_shadows").ResetToDefault();
		CVar.FindCVar("rl_wall_shadows_alert").ResetToDefault();
		CVar.FindCVar("rl_sprite_min").ResetToDefault();
		CVar.FindCVar("rl_sprite_max").ResetToDefault();
		CVar.FindCVar("rl_shadow_alpha").ResetToDefault();
		CVar.FindCVar("rl_shadow_walpha").ResetToDefault();
	}
	override void Drawer()
	{
		super.Drawer();
		if (mDesc.mSelectedItem == -1) return;

		string tip = tips[mDesc.mSelectedItem];
		if (mDesc.mSelectedItem == tips.Size() - 1)
		{
			int select = Cvar.FindCvar("rl_shadow_options_preset").GetInt();
			if (self.bEnter)
			{
				select = select == 0 ? 4 : --select;
				Cvar.FindCvar("rl_shadow_options_preset").SetInt(select);
				mDesc.mSelectedItem = 0; 
				switch(select)
				{
					case 0:
						break;
					case 1: // default
						reset();
						break;
					case 2: // performance
						reset();
						CVar.FindCVar("rl_shadow_distance").SetInt(1024);
						CVar.FindCVar("rl_distance3D").SetBool(false);
						CVar.FindCVar("rl_lifespan").SetInt(6);
						CVar.FindCVar("rl_interpolate").SetBool(false);
						CVar.FindCVar("rl_dual_shadows").SetBool(false);
						CVar.FindCVar("rl_blur_shadows").SetBool(false);
						CVar.FindCVar("rl_sprite_min").SetInt(16);
						CVar.FindCVar("rl_sprite_max").SetInt(64);
						break;
					case 3: // more shadow
						reset();
						CVar.FindCVar("rl_shadow_distance").SetInt(2560);
						CVar.FindCVar("rl_shadow_scale").SetFloat(5.0);
						CVar.FindCVar("rl_shadow_alpha").SetFloat(0.4);
						CVar.FindCVar("rl_shadow_walpha").SetFloat(0.5);
						break;
					case 4: // less shadow
						reset();
						CVar.FindCVar("rl_shadow_scale").SetFloat(2.0);
						CVar.FindCVar("rl_dual_shadows").SetBool(false);
						CVar.FindCVar("rl_shadow_alpha").SetFloat(0.1);
						CVar.FindCVar("rl_shadow_walpha").SetFloat(0.2);
						break;
				};
			}
			else
			{
				switch(select)
				{
					case 0:
						tip = "No changes to settings";
						break;
					case 1:
						tip = "ENTER to set Reset to Defaults";
						break;
					case 2:
						tip = "ENTER to set Performance";
						break;
					case 3:
						tip = "ENTER to set More shadow";
						break;
					case 4:
						tip = "ENTER to set Less shadow";
						break;
				};
			}
		}
		let ofont = OptionFont();
		Screen.DrawText(ofont, Font.CR_WHITE, (Screen.GetWidth() / 2) - ((ofont.StringWidth(tip) / 2 * CleanXfac_1 / 2) * 2), 
			ofont.GetHeight() * CleanYfac_1 * (tips.Size() + 3), tip, DTA_ScaleX, 2.0, DTA_ScaleY, 2.0);
	}
}
class relighting_color_Menu : OptionMenu
{
	static const string tips[] =
	{
		"Adds colors to sectors based on flats and (limited support) sky textures",
		"Controls if a color is ignored based on perceived brightness by the human eye",
		"Controls if the red portion of color is ignored based on perceived brightness by the human eye",
		"Controls if the green portion of color is ignored based on perceived brightness by the human eye",
		"Controls if the blue portion of color is ignored based on perceived brightness by the human eye",
		"Spreads color into other sectors",
		""
	};
	override void Init(Menu parent, OptionMenuDescriptor desc)
	{
		super.Init(parent, desc);
	}
	bool bEnter;
	override bool MenuEvent(int mkey, bool fromcontroller)
	{
		super.MenuEvent(mkey, fromcontroller);
		self.bEnter = mkey == MKEY_Enter;
		return true;
	}
	void reset()
	{
		CVar.FindCVar("rl_colored_sectors").ResetToDefault();
		CVar.FindCVar("rl_colored_perceived").ResetToDefault();
		CVar.FindCVar("rl_colored_howred").ResetToDefault();
		CVar.FindCVar("rl_colored_howgreen").ResetToDefault();
		CVar.FindCVar("rl_colored_howblue").ResetToDefault();
		CVar.FindCVar("rl_color_bleeding").ResetToDefault();
	}
	override void Drawer()
	{
		super.Drawer();
		if (mDesc.mSelectedItem == -1) return;

		string tip = tips[mDesc.mSelectedItem];
		if (mDesc.mSelectedItem == tips.Size() - 1)
		{
			int select = Cvar.FindCvar("rl_color_preset").GetInt();
			if (self.bEnter)
			{
				select = select == 0 ? 3 : --select;
				Cvar.FindCvar("rl_color_preset").SetInt(select);
				mDesc.mSelectedItem = 0; 
				switch(select)
				{
					case 0:
						break;
					case 1: // default
						reset();
						break;
					case 2: // more color
						reset();
						CVar.FindCVar("rl_colored_perceived").SetInt(96);
						CVar.FindCVar("rl_colored_howred").SetInt(128);
						CVar.FindCVar("rl_colored_howgreen").SetInt(96);
						CVar.FindCVar("rl_colored_howblue").SetInt(128);
						break;
					case 3: // less color
						reset();
						CVar.FindCVar("rl_colored_perceived").SetInt(160);
						CVar.FindCVar("rl_colored_howred").SetInt(208);
						CVar.FindCVar("rl_colored_howgreen").SetInt(160);
						CVar.FindCVar("rl_colored_howblue").SetInt(228);
						break;
				};
			}
			else
			{
				switch(select)
				{
					case 0:
						tip = "No changes to settings";
						break;
					case 1:
						tip = "ENTER to set Reset to Defaults";
						break;
					case 2:
						tip = "ENTER to set More color";
						break;
					case 3:
						tip = "ENTER to set Less color";
						break;
				};
			}
		}
		let ofont = OptionFont();
		Screen.DrawText(ofont, Font.CR_WHITE, (Screen.GetWidth() / 2) - ((ofont.StringWidth(tip) / 2 * CleanXfac_1 / 2) * 2), 
			ofont.GetHeight() * CleanYfac_1 * (tips.Size() + 3), tip, DTA_ScaleX, 2.0, DTA_ScaleY, 2.0);
	}
}
class relighting_shader_Menu : OptionMenu
{
	static const string tips[] =
	{
		"Adds a GL pixel shader",
		"Controls gamma (0 disables)",
		"Controls how saturated colors are (this is based on the RGB components)",
		"Controls how colors blend or bleed into each other (photographic technique)",
		"Bleed only RG components of a color",
		""
	};
	override void Init(Menu parent, OptionMenuDescriptor desc)
	{
		super.Init(parent, desc);
	}
	bool bEnter;
	override bool MenuEvent(int mkey, bool fromcontroller)
	{
		super.MenuEvent(mkey, fromcontroller);
		self.bEnter = mkey == MKEY_Enter;
		return true;
	}
	void reset()
	{
		CVar.FindCVar("rl_shader").ResetToDefault();
		CVar.FindCVar("rl_gamma").ResetToDefault();
		CVar.FindCVar("rl_saturation").ResetToDefault();
		CVar.FindCVar("rl_bleeding").ResetToDefault();
		CVar.FindCVar("rl_rg_bleeding").ResetToDefault();
	}
	override void Drawer()
	{
		super.Drawer();
		if (mDesc.mSelectedItem == -1) return;

		string tip = tips[mDesc.mSelectedItem];
		if (mDesc.mSelectedItem == tips.Size() - 1)
		{
			int select = Cvar.FindCvar("rl_shader_preset").GetInt();
			if (self.bEnter)
			{
				select = select == 0 ? 5 : --select;
				Cvar.FindCvar("rl_shader_preset").SetInt(select);
				mDesc.mSelectedItem = 0; 
				switch(select)
				{
					case 0:
						break;
					case 1: // default
						reset();
						break;
					case 2: // colorful
						reset();
						CVar.FindCVar("rl_gamma").SetFloat(1.0);
						CVar.FindCVar("rl_saturation").SetFloat(1.55);
						CVar.FindCVar("rl_bleeding").SetFloat(0.35);
						break;
					case 3: // bleak
						reset();
						CVar.FindCVar("rl_gamma").SetFloat(1.25);
						CVar.FindCVar("rl_saturation").SetFloat(0.85);
						CVar.FindCVar("rl_bleeding").SetFloat(0.25);
						break;
					case 4: // stark
						reset();
						CVar.FindCVar("rl_gamma").SetFloat(0.75);
						CVar.FindCVar("rl_saturation").SetFloat(0.95);
						CVar.FindCVar("rl_bleeding").SetFloat(0.35);
						break;
					case 5: // noir
						reset();
						CVar.FindCVar("rl_gamma").SetFloat(0.65);
						CVar.FindCVar("rl_saturation").SetFloat(0.25);
						CVar.FindCVar("rl_bleeding").SetFloat(0.55);
						break;
				};
			}
			else
			{
				switch(select)
				{
					case 0:
						tip = "No changes to settings";
						break;
					case 1:
						tip = "ENTER to set Reset to Defaults";
						break;
					case 2:
						tip = "ENTER to set Colorful";
						break;
					case 3:
						tip = "ENTER to set Bleak";
						break;
					case 4:
						tip = "ENTER to set Stark";
						break;
					case 5:
						tip = "ENTER to set Noir";
						break;
				};
			}
		}
		let ofont = OptionFont();
		Screen.DrawText(ofont, Font.CR_WHITE, (Screen.GetWidth() / 2) - ((ofont.StringWidth(tip) / 2 * CleanXfac_1 / 2) * 2), 
			ofont.GetHeight() * CleanYfac_1 * (tips.Size() + 3), tip, DTA_ScaleX, 2.0, DTA_ScaleY, 2.0);
	}
}
class relighting_misc_Menu : OptionMenu
{
	static const string tips[] =
	{
		"Algorithm for where light sources are placed. Polylabel is based on a map-labeling algorithm",
		"Adds fog for flats that snap to grid in certain settings",
		"Adds randomized light missiles to enhance shadow mapping in certain settings",
		"",
		"Adds reflections to animated flats",
		"Adds reflections to floor flats based on the Reflection Value",
		"Controls how bright a texture is to generate a reflection",
		""
	};
	override void Init(Menu parent, OptionMenuDescriptor desc)
	{
		super.Init(parent, desc);
	}
	bool bEnter;
	override bool MenuEvent(int mkey, bool fromcontroller)
	{
		super.MenuEvent(mkey, fromcontroller);
		self.bEnter = mkey == MKEY_Enter;
		return true;
	}
	void reset()
	{
		CVar.FindCVar("rl_center_algorithm").ResetToDefault();
		CVar.FindCVar("rl_sector_fog").ResetToDefault();
		CVar.FindCVar("rl_ghost_lights").ResetToDefault();
		CVar.FindCVar("rl_ghost_color").ResetToDefault();
		CVar.FindCVar("rl_anim_reflections").ResetToDefault();
		CVar.FindCVar("rl_floor_reflections").ResetToDefault();
		CVar.FindCVar("rl_floor_value").ResetToDefault();
	}
	override void Drawer()
	{
		super.Drawer();
		if (mDesc.mSelectedItem == -1) return;

		string tip = tips[mDesc.mSelectedItem];
		if (mDesc.mSelectedItem == tips.Size() - 1)
		{
			int select = Cvar.FindCvar("rl_misc_preset").GetInt();
			if (self.bEnter)
			{
				select = select == 0 ? 4 : --select;
				Cvar.FindCvar("rl_misc_preset").SetInt(select);
				mDesc.mSelectedItem = 0; 
				switch(select)
				{
					case 0:
						break;
					case 1: // default
						reset();
						break;
					case 2: // performance
						reset();
						CVar.FindCVar("rl_center_algorithm").SetInt(0);
						CVar.FindCVar("rl_sector_fog").SetBool(false);
						CVar.FindCVar("rl_ghost_lights").SetBool(false);
						CVar.FindCVar("rl_anim_reflections").SetBool(false);
						CVar.FindCVar("rl_floor_reflections").SetBool(false);
						break;
					case 3: // more reflections
						reset();
						CVar.FindCVar("rl_floor_value").SetInt(50);
						break;
					case 4: // less reflections
						reset();
						CVar.FindCVar("rl_floor_reflections").SetBool(false);
						CVar.FindCVar("rl_floor_value").SetInt(5);
						break;
				};
			}
			else
			{
				switch(select)
				{
					case 0:
						tip = "No changes to settings";
						break;
					case 1:
						tip = "ENTER to set Reset to Defaults";
						break;
					case 2:
						tip = "ENTER to set Performance";
						break;
					case 3:
						tip = "ENTER to set More Reflections";
						break;
					case 4:
						tip = "ENTER to set Less Reflections";
						break;
				};
			}
		}
		let ofont = OptionFont();
		Screen.DrawText(ofont, Font.CR_WHITE, (Screen.GetWidth() / 2) - ((ofont.StringWidth(tip) / 2 * CleanXfac_1 / 2) * 2), 
			ofont.GetHeight() * CleanYfac_1 * (tips.Size() + 3), tip, DTA_ScaleX, 2.0, DTA_ScaleY, 2.0);
	}
}
