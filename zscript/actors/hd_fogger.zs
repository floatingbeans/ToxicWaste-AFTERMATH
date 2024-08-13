class hd_fogger : Actor
{
	Default
	{
		RenderStyle "None";
		+NOINTERACTION
		+NOTONAUTOMAP
		+NOBLOCKMAP
		+NOGRAVITY
	}
	int density;
	int direction;
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		density = 5;
		direction = 1;
	}
	override void Tick(void)
	{
		Super.Tick();
		density += direction;
		if (density == 30) direction = -1;
		if (density == 5) direction = 1;
		self.CurSector.SetFogDensity(density);
	}
}
