class hdlightsource : Actor
{
	Default
	{
		RenderStyle "None";
//		RenderStyle "Normal";
		+NOINTERACTION
		+NOTONAUTOMAP
		+NOBLOCKMAP
		+NOGRAVITY
		Radius 64;
	}

	bool, double LightCheckSight(Actor light, Actor other)
	{
        if (!light) return false, double.infinity;
		int FLOOR = 0, CEILING = 1;

		// sector light that is tall as the sector
		double incr = (light.CurSector.CeilingPlane.ZAtPoint(light.Pos.xy) - light.Pos.z) * 0.1;
		incr = incr < 1.0 ? 1.0 : incr;

		for (double z = light.CurSector.CeilingPlane.ZAtPoint(light.Pos.xy); z > light.Pos.z; z-=incr)
		{
			Vector3 delta = LevelLocals.Vec3Diff((light.Pos.x, light.Pos.y, z), other.Pos);
			vector2 aim = (VectorAngle(delta.x, delta.y), -VectorAngle(delta.xy.Length(), delta.z) );

			if (!light.LineTrace(aim.x, delta.Length(), aim.y, TRF_THRUBLOCK|TRF_THRUHITSCAN|TRF_THRUACTORS))
			{
				return true, (delta.Length() == 0 ? 1 : delta.Length());
			}
		}
		return false, double.infinity;
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		let rl_Cvar = rl_Cvars.get();
		if (rl_CVar.rl_ghost_lights.GetBool())
		{
			int fail = self.CurSector.LightLevel + 1;
			A_SpawnItemEx("hd_ghostmissile", xvel: FRandom(-1.0,1.0), yvel: FRandom(-1.0,1.0), zvel: FRandom(-1.0,1.0), angle: FRandom(0.0,359.0), 
				flags: SXF_MULTIPLYSPEED, failchance: fail);
		}

		double d3D = 512 * 512;
		int n = 1;
		Actor light;
		ThinkerIterator it = ThinkerIterator.Create("hdlightsource", Thinker.STAT_DEFAULT);
		while (light = hdlightsource(it.Next()))
		{
			if (light == self) continue;
			if (Distance3DSquared(light) < d3D)
			{
				bool visible;
				double d;
				[visible, d] = LightCheckSight(self, light);
				n += visible ? 1 : 0;
			}
		}
		Scale.X = Scale.Y / n;
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
