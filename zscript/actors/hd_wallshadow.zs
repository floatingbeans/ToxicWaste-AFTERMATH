class hd_wallshadow : hd_Pshadow
{
	Default
	{
		+WALLSPRITE
	}
	int lifespan;
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();

		Sector sec = self.CurSector;
		if (self.args[0] != true && sec.FloorPlane.ZAtPoint(self.Pos.xy) < self.Pos.Z) Destroy();
		self.Alpha *= 0.75;
		lifespan = self.args[2] * 2 + 1;

		let rl_Cvar = rl_Cvars.get();
		if (rl_Cvar.rl_wall_shadows_alert.GetBool() && self.args[1] && self.Alpha > 0.0) players[consoleplayer].mo.A_AlertMonsters(256, AMF_TARGETEMITTER);
	}
	override void Tick(void)
	{
		Super.Tick();
		lifespan--;
		if (!lifespan)
		{
			Destroy();
			return;
		}
	}
}

