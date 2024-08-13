class hd_light : Actor
{
	Default
	{
		RenderStyle "None";
		+NOINTERACTION
		+NOTONAUTOMAP
		+NOBLOCKMAP
		+NOGRAVITY
	}
	int PrevSector, CurrentSector;
	hd_relighting_EventHandler Event;
	bool lights, _missile, lit, justsuper;
	int light_size, light_type, light_flags, shadow_distance, rl_lifespan, lifespan;
	uint distance_squared, half_distance_squared;
	color glcolor;
	vector3 offset;
	int perceived(color c)
	{
		return clamp(((c.r << 1) + c.r + (c.g << 2) + c.b) >> 3, 0, 255);
	}
	color chooseColor(int i)
	{
		if (glcolor != color(0,0,0)) return glcolor;
		if (self.args[1] + self.args[2] + self.args[3] != 0) return color(self.args[1], self.args[2], self.args[3]);

		// default to sector color
		int FLOOR = 0, CEILING = 1;
		Texman texture;
		color smap = Level.Sectors[i].ColorMap.LightColor;
		color white = color("#ffffff");
		color black = color("#000000");
		if (smap == white)
		{
			int findex = Event.flats.Find(texture.GetName(CurSector.GetTexture(FLOOR)));
			if (findex != Event.flats.Size())
			{
				color fmap = color(Event.flat_color[findex]);
				if (fmap != white && fmap != black)
				{
					return fmap;
				}
			}
			int cindex = Event.flats.Find(texture.GetName(CurSector.GetTexture(CEILING)));
			if (cindex != Event.flats.Size())
			{
				color cmap = color(Event.flat_color[cindex]);
				if (cmap != white && cmap != black)
				{
					return cmap;
				}
			}
		}
		return smap;
	}
	void addlight(color c)
	{
		if (!players[consoleplayer].mo) return;
		if (!master) return;
		if (light_size == 0) return;
		int intensity = int(light_size * Scale.Y + 0.5);
		if (intensity == 0) return;

		intensity += self.args[0]; ////////////////////////// test

		if (Distance3DSquared(players[consoleplayer].mo) < distance_squared)
		{
			let rl_Cvar = rl_Cvars.get();
			// remove lights behind the player
			let p = players[consoleplayer].mo;

//			if (think && AbsAngle(p.Angle, p.AngleTo(self)) > players[consoleplayer].fov && caster_to_player > half_distance_squared) // shadows behind the player

// testing this

			if (AbsAngle(p.Angle, p.AngleTo(self)) > players[consoleplayer].fov && Distance3DSquared(players[consoleplayer].mo) > half_distance_squared) // * 0.75) //  || p.Pitch < -45 || p.Pitch > 45) /////////// drop fps?
			{
				A_RemoveLight("hdlight");
				lit = false;
				return;
			}
			intensity *= light_type == DynamicLight.PulseLight ? 5 : 1;
			if (!lit)
			{
				if (master.bIsMonster)
				{
					if (master.InStateSequence(CurState, FindState("Missile", false))) // this might need compatibility checking
					{
						A_AttachLight("hdlight", light_type, c, intensity, intensity * 2, flags: light_flags, ofs: offset, param: Random(1,4));
						lit = true;
					}
				}
				else
				{
					A_AttachLight("hdlight", light_type, c, intensity, intensity * 2, flags: light_flags, ofs: offset, param: Random(1,4));
					lit = true;

					if (rl_Cvar.rl_death_lights.GetBool() && master.FindState("Death") && master.Height > 6)
					{
						double h = master.Height;
						double r = master.Radius;
						double z = master.Pos.Z + r;
						double p = -90;
						if (master.bMissile)
						{
							z = 0.0;
							if (master.target && master.target.target)
							{
								p = master.target.PitchTo(master.target.target, master.target.Height * 0.5, master.target.target.Height * 0.5);
							}
							else
							{
								p = master.pitch;
							}
						}
						double i = master.bMissile ? rl_Cvar.rl_missile_light_size.GetInt() : rl_Cvar.rl_other_light_size.GetInt();
						A_AttachLight("hdspot", DynamicLight.SectorLight, c, h * i, 0, flags: light_flags | DYNAMICLIGHT.LF_SPOT, ofs: (0,0,z), spoti: h * 1.5, spoto: h * 2, spotp: p);
					}
				}
			}
		}
		else
		{
			A_RemoveLight("hdlight");
			A_RemoveLight("hdspot");
			lit = false;
		}
		return;
	}
	override void BeginPlay()
	{
		Super.BeginPlay();
		ChangeStatNum(STAT_HDLIGHT);
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		let rl_Cvar = rl_Cvars.get();
		Event = hd_relighting_EventHandler(EventHandler.Find("hd_relighting_EventHandler"));
		lit = false;
		lights = false;
		_missile = false;
		light_flags = DYNAMICLIGHT.LF_ATTENUATE | DYNAMICLIGHT.LF_DONTLIGHTOTHERS | DYNAMICLIGHT.LF_DONTLIGHTSELF;
		justsuper = false;
		if (!master)
		{
			Destroy();
			return;
		}
		string cname = master.GetClassName();
		cname = cname.MakeLower();
		shadow_distance = rl_Cvar.rl_shadow_distance.GetInt();
		distance_squared = shadow_distance * shadow_distance;
		half_distance_squared = (shadow_distance * 0.5) * (shadow_distance * 0.5);
		if (master.Height)
		{
			offset = (0,0,master.Height);
		}
		else
		{
			offset = (0,0,0);
		}
		glcolor = color(0,0,0);

		light_type = DynamicLight.SectorLight;
		// for shadow mapping
		if (cname == "hdlightsource")
		{
			justsuper = true;
			lights = true;
			light_size = int(rl_Cvar.rl_sector_light_size.GetInt() * master.Scale.X); // + (self.args[0] * 0.25));
			light_flags = DYNAMICLIGHT.LF_ATTENUATE | DYNAMICLIGHT.LF_DONTLIGHTSELF;
		}
		else if (Event.lobj.Find(cname) != Event.lobj.Size())
		{
			glcolor = Event.cobj[Event.lobj.Find(cname)];
			if (master.bMissile)
			{
				_missile = true;
				lights = rl_Cvar.rl_missile_lights.GetBool();
				light_size = rl_Cvar.rl_missile_light_size.GetInt();
			}
			else if (master.bIsMonster)
			{
				lights = rl_Cvar.rl_monster_lights.GetBool();
				light_size = rl_Cvar.rl_monster_light_size.GetInt();
				if (!master.bFloat)
				{
					distance_squared = shadow_distance;
				}
			}
			else
			{
				lights = rl_Cvar.rl_other_lights.GetBool();
				light_type = perceived(glcolor) > 128 ? DynamicLight.SectorLight : DynamicLight.PulseLight;
				light_flags = light_type == DynamicLight.PulseLight ? DYNAMICLIGHT.LF_DONTLIGHTSELF : light_flags;
				light_size = (master.FindState("Death") ? 2 : 1) * rl_Cvar.rl_other_light_size.GetInt();
				if (!master.bSolid)
				{
					distance_squared = int(shadow_distance * 0.5 * shadow_distance * 0.5);
				}
			}
			// increase for pure colors 
			if (light_size)
			{
				double f = rl_Cvar.rl_colored_perceived.GetInt() * .10 / 255;
				if (glcolor.g > glcolor.r && glcolor.g > glcolor.b) light_size += int((255 - rl_Cvar.rl_colored_howgreen.GetInt()) * f);
				if (glcolor.r > glcolor.g && glcolor.r > glcolor.b) light_size += int((255 - rl_Cvar.rl_colored_howred.GetInt()) * f);
				if (glcolor.b > glcolor.r && glcolor.b > glcolor.g) light_size += int((255 - rl_Cvar.rl_colored_howblue.GetInt()) * f);
				if (glcolor.r > 192 && glcolor.g > 192 && glcolor.b > 192) light_size += int((255 - rl_Cvar.rl_colored_perceived.GetInt()) * f);
			}
		}
		else if (self.args[0] != 1)
		{
			self.Destroy();
		}
		PrevSector = CurSector.SectorNum;
		CurrentSector = CurSector.SectorNum;
		int hd_added = Event.hd_added;
		light_size = clamp(int(light_size - (hd_added * 0.01) + 0.5), 0, light_size);
		if (lights) addlight(chooseColor(CurrentSector));
		rl_lifespan = rl_Cvar.rl_lifespan.GetInt();
		lifespan = rl_lifespan;
	}
	override void Tick(void) ///////////////////// fix for Brutal Doom plasma gun?
	{
		Super.Tick();
		if (justsuper) return;
		if (--lifespan == 0)
		{
			lifespan = rl_lifespan;
		}
		else
		{
			return;
		}
		if (AAPTR_MASTER) A_Warp(AAPTR_MASTER, 0,0,-2, 0, WARPF_INTERPOLATE | WARPF_NOCHECKPOSITION);
		let rl_Cvar = rl_Cvars.get();
		if (!master || master.InStateSequence(master.CurState, master.ResolveState("Death")))
		{
			if (lights) A_RemoveLight("hdlight");
			Level.Sectors[CurrentSector].LightLevel = Event.seclights[CurrentSector];
			Level.Sectors[PrevSector].LightLevel = Event.seclights[PrevSector];
			Event.secmissiles[CurrentSector] = clamp(Event.secmissiles[CurrentSector] - 1, 0, rl_Cvar.rl_missile_light_limit.GetInt());
			Event.secmissiles[PrevSector] = clamp(Event.secmissiles[PrevSector] - 1, 0, rl_Cvar.rl_missile_light_limit.GetInt());
			Destroy();
			return;
		}
		Super.Tick();
		if (!master) return;
		CurrentSector = CurSector.SectorNum;
		if (PrevSector != CurrentSector)
		{
			if (lights)
			{
				A_RemoveLight("hdlight");
				Color cmap = chooseColor(CurrentSector);
				if (_missile)
				{
					Event.secmissiles[PrevSector] = clamp(Event.secmissiles[PrevSector] - 1, 0, rl_Cvar.rl_missile_light_limit.GetInt());
					if (Event.secmissiles[CurrentSector] < rl_Cvar.rl_missile_light_limit.GetInt())
					{
						addlight(cmap);
						Event.secmissiles[CurrentSector]++;
					}
				}
				else
				{
					addlight(cmap);
				}
			}
		}
		else
		{
			if (lights)
			{
				Color cmap = chooseColor(CurrentSector);
				if (_missile)
				{
					if (Event.secmissiles[CurrentSector] < rl_Cvar.rl_missile_light_limit.GetInt())
					{
						addlight(cmap);
						Event.secmissiles[CurrentSector]++;
					}
				}
				else
				{
					addlight(cmap);
				}
			}
		}
		if (_missile && PrevSector != CurrentSector && rl_Cvar.rl_sectors.GetBool()) ///////////// BD breaks this
		{
			if (PrevSector != CurrentSector) Level.Sectors[PrevSector].LightLevel = Event.seclights[PrevSector];
			PrevSector = CurrentSector;
			if (Event.seclights[CurrentSector] > 0 && Scale.Y > 0) Level.Sectors[CurrentSector].LightLevel =  clamp(int(Event.seclights[CurrentSector] + Event.seclights[CurrentSector] * (Scale.Y * 0.5)),0,255);
		}
	}
/*******************************
	States
	{
	Spawn:
		TNT1 A 1
		{
			if (AAPTR_MASTER) A_Warp(AAPTR_MASTER, 0,0,-2, 0, WARPF_INTERPOLATE | WARPF_NOCHECKPOSITION);
		}
		Loop;
	}
******************************/
}
