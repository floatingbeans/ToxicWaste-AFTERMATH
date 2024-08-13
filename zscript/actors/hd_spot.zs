class hd_spot : Actor
{
	Default
	{
		RenderStyle "Normal";
//		RenderStyle "None";
		+NOINTERACTION
		+NOTONAUTOMAP
		+NOBLOCKMAP
	}
	bool, double LightCheckSight(Actor light)
	{
		int FLOOR = 0, CEILING = 1;

///////////// test
//		double z = light.CurSector.FloorPlane.ZAtPoint(light.Pos.xy) + (light.CurSector.CeilingPlane.ZAtPoint(light.Pos.xy) - light.CurSector.FloorPlane.ZAtPoint(light.Pos.xy)) * 0.5;
		double z = light.FloorZ; //light.FloorZ + ((light.CeilingZ - light.FloorZ) * 0.5);
		double selfz = self.FloorZ + ((self.CeilingZ - self.FloorZ) * 0.5);
		Vector3 delta = LevelLocals.Vec3Diff((light.Pos.x, light.Pos.y, z), (self.Pos.x, self.Pos.y, selfz));
		vector2 aim = (VectorAngle(delta.x, delta.y), -VectorAngle(delta.xy.Length(), delta.z) );

		return !light.LineTrace(aim.x, delta.Length(), aim.y, TRF_THRUBLOCK|TRF_THRUHITSCAN|TRF_THRUACTORS), delta.Length();
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		let rl_Cvar = rl_Cvars.get();
		int FLOOR = 0, CEILING = 1;
		int shadow_distance = rl_Cvar.rl_shadow_distance.GetInt();
		double min_distance = double.infinity;
		double min_scale =  double.infinity;
		double min_pitch =  double.infinity;
		double spot_angle = double.infinity;
		color spot_color = color("white");

		Actor light;
		ThinkerIterator it = ThinkerIterator.Create("hd_light", STAT_HDLIGHT);
		while (light = hd_light(it.Next()))
		{
			if (light.Pos.z == light.CurSector.FloorPlane.ZAtPoint(light.Pos.xy))
			{
				double x = abs(Pos.X - light.Pos.X);
				double y = abs(Pos.Y - light.Pos.Y);

				if (x < shadow_distance * light.Scale.Y && y < shadow_distance * light.Scale.Y)
				{
					bool visible;
					double d;
					[visible, d] = LightCheckSight(light);
					if (visible && d < min_distance)
					{

//console.printf("Found %f", d);

						min_distance = d;
						min_scale = light.Scale.Y;

						vector3 source = (light.Pos.x, light.Pos.Y, light.CurSector.CeilingPlane.ZAtPoint(light.Pos.xy));
						vector3 diff = self.Pos - source;
						min_pitch = -atan2(diff.z, diff.xy.length());

						spot_color = light.CurSector.ColorMap.LightColor;
						spot_angle = self.AngleTo(light) + 180;
					}
				}
			}
		}
		if (spot_angle != double.infinity)
		{
			double outer = clamp(1 / (min_distance + 0.1) * 30000 * (self.args[0] * 1.0 / 128.0) * (min_scale + 0.1), 10.0, 500.0);
			
			if (self.args[1] == 0) outer *= 0.2;

			self.Angle = spot_angle;
			self.A_AttachLight("spot", DynamicLight.SectorLight, spot_color, 0, 0, DYNAMICLIGHT.LF_ATTENUATE | DYNAMICLIGHT.LF_SPOT, spoti: outer * 0.20, spoto: outer, spotp: min_pitch);
			Actor ptr = Actor.Spawn("hdlightsource", (self.Pos.X, self.Pos.Y, self.CurSector.FloorPlane.ZAtPoint(self.Pos.xy) + self.Height));
			if (ptr)
			{
				ptr.Scale.Y = min_scale;
			}

// console.printf("%i %i", outer, self.args[1]);
		}
		else
		{
			self.Destroy();
		}
	}
/*
	States
	{
	Spawn:
		BAL1 A 10;
		TELE C 10;
		Loop;
	Death:
		Stop;
	}
*/
}
