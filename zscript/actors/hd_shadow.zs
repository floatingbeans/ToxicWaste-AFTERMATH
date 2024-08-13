struct rl_shadow
{
	int tscale;
	double max_3D, tangle, _scaley, scale_pitch, distance;
	Actor lightsource;
	bool bMissile, bDirectional, isFlashlight;
}

class hd_shadow : hd_Pshadow
{
	Default
	{
		+DONTSPLASH
		+FLATSPRITE
		-YFLIP
	}
	Actor caster;
	double tangle, length;
	hd_relighting_EventHandler Event;
	int shadow_distance, light_distance, tscale;
	uint distance_squared, quarter_distance_squared, half_distance_squared, threefourths_distance_squared;
	string caster_type;
	double max_3D, caster_to_player;
	int lifespan, rl_lifespan, tnt_counter;
	crosswalk cwalk;
	override void PostBeginPlay()
	{
		cwalk = new ("crosswalk").init();
		if (!caster)
		{
			Destroy();
			return;
		}
		let rl_Cvar = rl_Cvars.get();
		rl_Cvar = rl_Cvars.get();
		Super.PostBeginPlay();
		Event = hd_relighting_EventHandler(EventHandler.Find("hd_relighting_EventHandler"));
		if (caster == players[consoleplayer].mo)
		{
			if (Event.voxel.Find("playa") != Event.voxel.Size()) self.Destroy();
		}
		double d = 1.0;
		if (caster.bMissile)
		{
			caster_type = "MISSILE";
			d = 0.50;
		}
		else if (caster.bIsMonster)
		{
			caster_type = "MONSTER";
		}
		else
		{
			caster_type = "OTHER";
			d = 0.5;
		}
		shadow_distance = int(rl_Cvar.rl_shadow_distance.GetInt() * d);
		light_distance = rl_Cvar.rl_shadow_distance.GetInt();
		double f = .005;
		if (Event.num_sprites > 1000)
		{
			f = .00005;
		}
		else if (Event.num_sprites > 100)
		{
			f = .0005;
		}
		shadow_distance -= int(shadow_distance * (Event.num_sprites * f));
		light_distance -= int(light_distance * (Event.num_sprites * f));
		distance_squared = shadow_distance * shadow_distance;
		quarter_distance_squared = (shadow_distance * 0.25) * (shadow_distance * 0.25);
		half_distance_squared = (shadow_distance * 0.5) * (shadow_distance * 0.5);
		threefourths_distance_squared =  (shadow_distance * 0.75) * (shadow_distance * 0.75);
		rl_lifespan = rl_Cvar.rl_lifespan.GetInt();
		lifespan = rl_lifespan;
		Texman texture;
		tnt_counter = (texture.GetName(caster.CurState.GetSpriteTexture(0)) == "TNT1A0") ? 0 : -1;
		if (caster.bSpawnCeiling) self.bYFlip = true;
		if (rl_Cvar.rl_blur_shadows.GetBool()) A_SetRenderStyle(Alpha, STYLE_None);
	}
	// Agent_Ash function to check visibility in viewport
	bool SimpleCheckSight(PlayerPawn who)
	{
        if (!who || !caster) return false;
        Vector3 delta = Vec3To(who) + (0,0,who.player.viewz - who.pos.z - height * 0.5);
        vector2 aim = (VectorAngle(delta.x, delta.y), -VectorAngle(delta.xy.Length(), delta.z) );
		if (delta.Length() > shadow_distance) return false;
        return !LineTrace(aim.x,delta.Length(),aim.y,TRF_THRUBLOCK|TRF_THRUHITSCAN|TRF_THRUACTORS, offsetz: caster.height * 0.5);
	}
	// modified to check for blocking actors
	bool BlockedCheckSight(PlayerPawn who)
	{
        if (!who || !caster) return false;
        Vector3 delta = Vec3To(who) + (0,0,who.player.viewz - who.pos.z - height * 0.5);
        vector2 aim = (VectorAngle(delta.x, delta.y), -VectorAngle(delta.xy.Length(), delta.z) );
		if (delta.Length() > shadow_distance) return false;
		FLineTraceData beam;
		if (LineTrace(who.AngleTo(caster) - 180, delta.Length(), aim.y, TRF_THRUBLOCK|TRF_THRUHITSCAN|TRF_THRUACTORS, offsetz: caster.height * 0.5, data: beam))
		{
			if (beam.HitType == FLineTraceData.TRACE_HitWall) return false;
			if (beam.Distance < delta.Length()) return false;
		}
		Actor ptr = beam.HitActor;
		if (ptr && ptr != caster)
		{
			if (ptr is "DoomPlayer") return true;

			if ((ptr.Pos - who.Pos).length() > who.Height * 2)
			{
				return false;
			}
		}
		return true;
	}
	// modified for anything
	bool, double LightCheckSight(Actor light)
	{
        if (!light || !caster) return false, double.infinity;
		int FLOOR = 0, CEILING = 1;

		if (light.master && light.master.args[0] == 1)
		{
			double z = light.Pos.z + ((light.CeilingZ - light.Pos.z) * 0.5);
			vector3 v3 = caster.bSpawnCeiling ? (caster.Pos.x, caster.Pos.y, caster.CeilingZ) : (caster.Pos.x, caster.Pos.y, caster.Pos.z + caster.Height * 0.5);
			Vector3 delta = LevelLocals.Vec3Diff((light.Pos.x, light.Pos.y, z), v3);
			vector2 aim = (VectorAngle(delta.x, delta.y), -VectorAngle(delta.xy.Length(), delta.z) );
			return !light.LineTrace(aim.x, delta.Length(), aim.y, TRF_THRUBLOCK|TRF_THRUHITSCAN|TRF_THRUACTORS), delta.Length();
		}
		else
		{
			Vector3 delta = light.Vec3To(caster);
			vector2 aim = (VectorAngle(delta.x, delta.y), -VectorAngle(delta.xy.Length(), delta.z) );
			if (delta.Length() > shadow_distance) return false, delta.Length();
			return !light.LineTrace(aim.x,delta.Length(),aim.y,TRF_THRUBLOCK|TRF_THRUHITSCAN|TRF_THRUACTORS, offsetz: caster.Height), delta.Length();
		}
	}
	void update_counters()
	{
		if (caster_type == "MISSILE")
		{
			Event.missile_shadows--;
		}
		else if (caster_type == "MONSTER")
		{
			Event.monster_shadows--;
		}
		else
		{
			Event.other_shadows--;
		}
		return;
	}

	override void Tick(void)
	{
		Super.Tick();
		if (!caster)
		{
			update_counters();
			self.Destroy();
			return;
		}
		let rl_Cvar = rl_Cvars.get();
		if (tnt_counter >= 0)
		{
			Texman texture;
			if (texture.GetName(caster.CurState.GetSpriteTexture(0)) == "TNT1A0") /////////////// check current state sprite
			{
				tnt_counter++;
				if (tnt_counter == 5)
				{
					update_counters();
					self.Destroy();
					return;
				}
			}
			else
			{
				int sprite_height = texture.CheckRealHeight(caster.CurState.GetSpriteTexture(0));
				if (sprite_height < Event.rl_sprite_min || sprite_height > Event.rl_sprite_max)
				{
					update_counters();
					self.Destroy();
					return;
				}
				tnt_counter = -1;
			}
		}
		if (caster.GetRenderStyle() != STYLE_Normal)
		{
			Scale.X = 0;
			Scale.Y = 0;
			return;
		}
		// noticeable in MAP15
		if (caster_type != "MISSILE" && abs(caster.Pos.Z - players[consoleplayer].mo.Pos.Z) > shadow_distance) return;
		caster_to_player = caster.Distance3DSquared(players[consoleplayer].mo);
		if (caster_to_player > distance_squared) return;
		if (caster_to_player > quarter_distance_squared && self.Speed == 2) return;

//		if (rl_lifespan > 1) if (caster != players[consoleplayer].mo && --lifespan != 0) return;

		if (rl_lifespan > 1) if (--lifespan != 0) return;
		
		// lengthen lifespan by distance from the player
		if (rl_lifespan > 3)
		{
			if (caster_to_player > threefourths_distance_squared) /////////////////// test... ? link to quality shadows
			{
				lifespan = rl_lifespan + 16;
			}
			else if (caster_to_player > half_distance_squared)
			{
				lifespan = rl_lifespan + 8;
			}
			else if (caster_to_player > quarter_distance_squared)
			{
				lifespan = rl_lifespan + 4;
			}
			else
			{
				lifespan = rl_lifespan;
			}
		}
		else
		{
			lifespan = rl_lifespan;
		}

		double _scaleY = caster.Scale.Y * 0.2;
		double casterZ = caster_type == "MISSILE" ? caster.FloorZ : caster.Pos.Z;
		vector3 v3 = (caster.Pos.X, caster.Pos.Y, casterZ);
		double scale_pitch = 0;


		Texman texture;
		let csprite = texture.GetName(caster.CurState.GetSpriteTexture(0));
		string swapsprite = cwalk.getswap(csprite.Left(4));
		if (swapsprite == "NOTFOUND")
		{
			Sprite = caster.Sprite;
		}
		else
		{
			Sprite = GetSpriteIndex(swapsprite);
		}

		//Sprite = caster.Sprite;
		Frame = caster.Frame;
		Scale.X = caster.Scale.X;
		tangle = caster.Angle - 180;
		tscale = 0;
		max_3D = double.infinity;
		Actor light, olight;
		Actor lightsource;
		let p = players[consoleplayer].mo;
		bool think = true;
//		if (caster == players[consoleplayer].mo)
//		{
//			think = true;
//		}
		if (!caster.bSpawnCeiling)
		{

///////////// changed to half distance

			if (think && AbsAngle(p.Angle, p.AngleTo(self)) > players[consoleplayer].fov && caster_to_player > half_distance_squared) // shadows behind the player
			{
				think = false;
			}
			if (think)
			{
				think = SimpleCheckSight(players[consoleplayer].mo);
			}
			if (think && caster_type == "MONSTER" && rl_Cvar.rl_blocking_actors.GetBool())
			{
				think = BlockedCheckSight(players[consoleplayer].mo);
			}
		}

		// initialize structure array for 2 most powerful lightsources
		rl_shadow shadows[2];
		shadows[0].tscale = 0;
		shadows[0].max_3D = double.infinity;
		shadows[1].tscale = 0;
		shadows[1].max_3D = double.infinity;
		int num_visible = 0;
		if (caster && think)
		{
int num_it = 0;
			int x, y, ld;
			ThinkerIterator it = ThinkerIterator.Create("hd_light", STAT_HDLIGHT);
			while (light = hd_light(it.Next()))
			{
				if (!caster) break;
				if (!light.master)
				{
					light.Destroy();
					continue;
				}
				if (light.master == caster || light == players[consoleplayer].mo) continue;
				if (light.master.args[0] == 2) continue;
				x = int(abs(Pos.X - light.Pos.X));
				y = int(abs(Pos.Y - light.Pos.Y));
				ld = int(light_distance * light.Scale.Y);
				// no z-check because lights are seen at different heights
num_it++;
				if (x < ld && y < ld)
				{
					bool isFlashlight = light.args[0] == 1;
					if (caster == players[consoleplayer].mo && light.master && isFlashlight)
					{
						continue;
					}
					if ((int(light.Scale.Y * 100) > shadows[0].tscale) || isFlashlight)
					{
						bxFLIP = true; // check to see if I need this
						if (rl_Cvar.rl_distance3D.GetBool())
						{
							double d3D = Distance3DSquared(light);
							if (d3D > distance_squared)
							{
								continue;
							}
							if (d3D > shadows[0].max_3D && !shadows[0].isFlashlight)
							{
								continue;
							}
							max_3D = d3D;
						}
						bool visible;
						double d;
						if (isFlashlight && light.master.target)
						{
							[visible, d] = LightCheckSight(light.master.target); // projectile flashlight hack
						}
						else
						{
							[visible, d] = LightCheckSight(light);
						}
						if (visible)
						{
							num_visible++;
							// self.Speed == 2
							shadows[1].tscale = shadows[0].tscale;
							shadows[1].max_3D = shadows[0].max_3D;
							shadows[1].tangle = shadows[0].tangle;
							shadows[1]._scaley = shadows[0]._scaley;
							shadows[1].scale_pitch = shadows[0].scale_pitch;
							shadows[1].distance = shadows[0].distance;
							shadows[1].lightsource = shadows[0].lightsource;
							shadows[1].bMissile = shadows[0].bMissile;
							shadows[1].bDirectional = shadows[0].bDirectional;
							shadows[1].isFlashlight = shadows[0].isFlashlight;
							shadows[0].bMissile = light.master.bMissile;
							shadows[0].max_3D = max_3D;
							shadows[0].bDirectional = light.Pos.z != light.FloorZ;
							shadows[0].isFlashlight = isFlashlight;
							shadows[0]._scaleY = clamp(caster.Scale.Y + Event.fscale[int(clamp(d * light.Scale.Y, 0, Event.fscale.Size() - 1))], 0.0, rl_Cvar.rl_shadow_scale.GetFloat());
							shadows[0].tscale = int(light.Scale.Y * 100);
/////////////////// hacky support for beamflashlight mod
							if (isFlashlight && light.master.target)
							{
								shadows[0].lightsource = light.master.target;
							}
							else
							{
								shadows[0].lightsource = light;
							}
							Actor llight = shadows[0].lightsource;
							shadows[0].tangle = caster.AngleTo(llight) + 180; ///////////////////// here's the hack

							if (rl_Cvar.rl_pitch_shadows.GetBool())
							{
								double vheight = shadows[0].lightsource.Pos.Z;
////////////////////////// this is another hack to adjust crouching for beamflashlightmod
								if (isFlashlight && light.master.target) ////////////// another hack
								{
									vheight += shadows[0].lightsource.Height * 0.5;
								}
								else if (llight.Pos.z == llight.FloorZ)
								{
									vheight = llight.FloorZ + ((llight.CeilingZ - llight.FloorZ) * 0.5);
								}
								else
								{
									vheight = llight.Pos.Z + (llight.master.Height * 0.5);
								}
								shadows[0].scale_pitch = atan2(caster.Pos.z - vheight, caster.Vec2To(shadows[0].lightsource).length());
								// note that this breaks pitched shadows
								//shadows[0].scale_pitch = caster.PitchTo(shadows[0].lightsource, vheight * -1);
								if (isFlashlight) shadows[0].scale_pitch += (players[consoleplayer].mo.Pitch * 0.25);
							}
							shadows[0].distance = d;
						}
					}
				}
			}
// console.printf("%i",num_visible);
		}
		if (!caster) return;
////////////////////////////////////////////// prioritize missiles and flashlights
		int _index = self.Speed < 2 ? 0 : 1;
		if (shadows[0].lightsource && shadows[1].lightsource && Speed > 0)
		{
			if (shadows[0].bMissile && !shadows[1].bMissile && !shadows[1].isFlashlight)
			{
				shadows[1].lightsource = null;
				shadows[1]._scaleY = 0;
			}
			if (shadows[1].bMissile && !shadows[0].bMissile && !shadows[0].isFlashlight)
			{
				shadows[0].lightsource = null;
				shadows[0]._scaleY = 0;
			}
		}
		if (!shadows[0].bMissile && !shadows[0].isFlashlight && !shadows[1].bMissile && !shadows[1].isFlashlight)
		{
			Scale.Y = shadows[_index]._scaleY - num_visible * 0.1;
		}
		else
		{
			Scale.Y = shadows[_index]._scaleY;
		}
		Scale.X = caster.Scale.X + (Scale.Y * 0.1);
		// wall shadow code... depends on light source
		if (caster && shadows[_index].lightsource)
		{
			SpriteAngle = DeltaAngle(caster.AngleTo(shadows[_index].lightsource), caster.Angle);
			double shadow_length = rl_Cvar.rl_long_shadows.GetBool() && num_visible > 1 ? light_distance : caster.Height * Scale.Y;
			FLineTraceData beam;
			if (caster.LineTrace(abs(shadows[_index].tangle), shadow_length, shadows[_index].scale_pitch, flags: TRF_THRUBLOCK | TRF_THRUHITSCAN | TRF_THRUACTORS, 
				offsetz: caster.Height, offsetforward: 4, data: beam))
			{
				if (beam.HitType == FLineTraceData.TRACE_HitWall && beam.HitTexture && beam.HitLine.delta.length() > caster.Radius)
				{
					bool b = false;
					Sector bsec;
					if (beam.LineSide == Line.front)
					{
						bsec = beam.HitLine.BackSector;
					}
					else
					{
						bsec = beam.HitLine.FrontSector;
					}
					// check for door
					if (beam.LinePart == Side.Top && bsec)
					{
						b = (bsec.FloorPlane.zAtPoint((beam.HitLocation.X, beam.HitLocation.Y)) == bsec.CeilingPlane.zAtPoint((beam.HitLocation.X, beam.HitLocation.Y)));
						if (!b)
						{
							Sector sec = beam.HitSector;
							b = (sec.CeilingPlane.zAtPoint((beam.HitLocation.X, beam.HitLocation.Y)) - bsec.CeilingPlane.zAtPoint((beam.HitLocation.X, beam.HitLocation.Y)))
								> caster.Height * Scale.Y - beam.Distance;
						}
					}
					// check for lower texture
					if (beam.LinePart == Side.Bottom && bsec)
					{
						b = (bsec.FloorPlane.zAtPoint((beam.HitLocation.X, beam.HitLocation.Y)) - casterZ) > caster.Height * Scale.Y - beam.Distance;
					}
					// check for sky texture
					if (beam.LinePart == Side.Mid)
					{
						if (beam.HitSector.GetTexture(Sector.Ceiling) == SkyFlatNum)
						{
							Sector sec = beam.HitSector;
							b = (sec.CeilingPlane.zAtPoint((beam.HitLocation.X, beam.HitLocation.Y)) - sec.FloorPlane.zAtPoint((beam.HitLocation.X, beam.HitLocation.Y)))
								> caster.Height * Scale.Y - beam.Distance;
						}
						else
						{
							b = true;
						}
					}
					if (b)
					{
						double belowZ = beam.HitLocation.Z - caster.Height * Scale.Y * 0.2;
						if (beam.Distance < caster.Height * Scale.Y)
						{
							belowZ -= beam.Distance * 0.5 - caster.Height * Scale.Y;
						}
						Actor wall = Spawn("hd_wallshadow", (beam.HitLocation.X, beam.HitLocation.Y, clamp(casterZ - belowZ, casterZ, casterZ - caster.Height * Scale.Y * 0.2)));
						if (wall)
						{
							if (caster != players[consoleplayer].mo && AbsAngle(p.Angle, p.AngleTo(wall)) > 90)
							{
								wall.Destroy();
							}
							else
							{
								wall.args[0] = caster.bFloat;
								wall.args[1] = caster == players[consoleplayer].mo && beam.Distance > caster.Height * Scale.Y;
								wall.args[2] = lifespan;
								wall.Alpha = clamp(shadows[_index].tscale * .01 - shadows[_index].distance * .000025, 0.0, rl_Cvar.rl_shadow_walpha.GetFloat());
								if (caster == players[consoleplayer].mo)
								{
									wall.Alpha *= 0.5;
								}
								if (shadows[_index].bDirectional && shadows[_index].distance < shadow_length * 0.25)
								{
									if (shadows[_index].bMissile)
									{
										wall.Alpha *= 1.25;
									}
									else
									{
										wall.Alpha *= 1.15;
									}
								}
								wall.Sprite = Sprite;
								wall.Frame = Frame;
								wall.SpriteAngle = SpriteAngle + 180;
								double line_angle = VectorAngle(beam.HitLine.delta.x, beam.HitLine.delta.y);
								double wall_angle = line_angle + DeltaAngle(line_angle, line_angle + 90);
								wall.Angle = wall_angle;
								wall.Scale.X = clamp(Scale.X + abs(beam.HitLine.delta dot (beam.HitDir.x,beam.HitDir.y) * .0025), Scale.X, rl_Cvar.rl_shadow_scale.GetFloat());
								wall.Scale.X += shadows[_index].distance * .001;
								if (rl_Cvar.rl_pitch_shadows.GetBool())
								{
									wall.Scale.Y = clamp((Scale.Y * 0.8) + (shadows[_index].scale_pitch * 0.08), 0.0, rl_Cvar.rl_shadow_scale.GetFloat());
								}
								else
								{
									wall.Scale.Y = Scale.Y * 0.8;
								}
								// this puts the sprite just in front of the texture and avoids flickering
								wall.Thrust(-0.1, wall.Angle);
							}
						}
					}
				}
			}
			// actor is casting shadow on another actor... probably can be done better
			Actor ptr = beam.HitActor;
			if (ptr && caster.Height > 32)
			{
				if ((rl_Cvar.rl_player_shadows_on_sprites.GetBool() || rl_Cvar.rl_monster_shadows_on_sprites.GetBool()) && ptr.GetClassName() != "hd_wallshadow")
				{
					if ((rl_Cvar.rl_player_shadows_on_sprites.GetBool() && caster == players[consoleplayer].mo) || (rl_Cvar.rl_monster_shadows_on_sprites.GetBool() && caster.bIsMonster))
					{
						if (caster.Distance2DSquared(ptr) < (caster.Height * caster.Height))
						{
							Actor sptr = Spawn("hd_actorshadow", ptr.Pos);
							if (sptr)
							{
								sptr.target = caster;
							}
						}
					}
				}
			}
			// caster is in shadow if shadow is behind him and in front of player
			if (caster != players[consoleplayer].mo)
			{
				double diff = AbsAngle(p.Angle, shadows[_index].tangle);
				if (diff > 135 && diff < 315 && self.Scale.Y > 0.5)
				{
					caster.LightLevel = int(caster.CurSector.LightLevel * rl_CVar.rl_dim_min.GetFloat());
				}
				else
				{
					caster.LightLevel = caster.CurSector.LightLevel + int(32 / self.Scale.Y); /////////////////////// test
				}
			}
		}
		Angle = shadows[_index].tangle;
		if (CurSector.FloorPlane.IsSlope())
		{
			// close but still not correct. Doesn't work for 3d floors
			// have not yet corrected wall shadows
		}
		else
		{
			Pitch = 0;
			Roll = 0;
		}
		if (caster)
		{
			double h = caster.CeilingZ - caster.FloorZ;
			v3 = (caster.Pos.X + cos(Angle) * (Scale.Y * 3), caster.Pos.Y + sin(Angle) * (Scale.Y * 3), caster.FloorZ + 2 + (caster.bSpawnCeiling ? h - rl_Cvar.rl_shadow_scale.GetFloat() : 0.0));
			SetOrigin(v3, true);
			if (caster.Pos.Z - players[consoleplayer].mo.Pos.Z > players[consoleplayer].mo.Height * 0.5 && !caster.bSpawnCeiling)
			{
				Alpha = 0.0;
			}
			else
			{
				Alpha = clamp(shadows[_index].tscale, 0.05, rl_Cvar.rl_shadow_alpha.GetFloat());
			}

			if (rl_Cvar.rl_blur_shadows.GetBool() && Alpha != 0.0)
			{
				Actor ptr = Spawn("hd_floorshadow", v3);
				if (ptr)
				{
					ptr.Sprite = Sprite;
					ptr.Frame = Frame;
					ptr.Scale.X = Scale.X;
					ptr.Scale.Y = Scale.Y;
					ptr.Angle = Angle;
					ptr.Alpha = Alpha;
					ptr.args[2] = lifespan;
					if (caster.bSpawnCeiling) ptr.args[1] = 1;
				}
			}
		}
	}
}
