class hd_actorshadow : Actor
{
	Default
	{
		+NOINTERACTION
		+NOTONAUTOMAP
		+NOBLOCKMAP
	}
	int lifespan;
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		A_AttachLight("shadow",DynamicLight.SectorLight,color("#202020"),2,0,flags: DYNAMICLIGHT.LF_SUBTRACTIVE | DYNAMICLIGHT.LF_DONTLIGHTMAP);

		if (target == players[consoleplayer].mo)
		{
			lifespan = 2;
		}
		else
		{
			lifespan = 4;
		}
	}
//////////////////////////////////////// to do: switch to State
	override void Tick(void)
	{
		Super.Tick();
		lifespan--;
		if (!lifespan)
		{
			A_RemoveLight("shadow");
			Destroy();
			return;
		}
	}
}
