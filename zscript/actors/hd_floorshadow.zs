class hd_floorshadow : hd_Pshadow
{
	Default
	{
		+DONTSPLASH
		+FLATSPRITE
		-YFLIP
	}
	int lifespan;
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		self.Alpha *= 0.75;
		lifespan = self.args[2] * 2 + 1; ////////////////////////////////////// test ? apply to walls
		if (self.args[1] == 1) self.bYFlip = true;
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

