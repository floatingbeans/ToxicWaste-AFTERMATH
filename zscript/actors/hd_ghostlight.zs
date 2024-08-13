class hd_ghostlight : Actor
{
	Default
	{
		RenderStyle "None";
		+NOINTERACTION
		+NOTONAUTOMAP
		+NOBLOCKMAP
		+NOGRAVITY
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		let rl_Cvar = rl_Cvars.get();
		int light_flags = DYNAMICLIGHT.LF_ATTENUATE | DYNAMICLIGHT.LF_DONTLIGHTOTHERS | DYNAMICLIGHT.LF_DONTLIGHTSELF;
		A_AttachLight("hdlight", DynamicLight.SectorLight, Color(rl_Cvar.rl_ghost_color.GetString()), Random(10,30), 0, flags: light_flags);
	}
	States
	{
	Spawn:
		TNT1 A 1 A_Warp(AAPTR_MASTER, 0,0,-2, 0, WARPF_INTERPOLATE | WARPF_NOCHECKPOSITION);
		Loop;
	}
}
