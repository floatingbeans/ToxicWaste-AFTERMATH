class hd_Pshadow : Actor
{
	Default
	{
		DistanceCheck "rl_shadow_distance";
		RenderStyle "Stencil";
		StencilColor "Black";
		+SPRITEANGLE
		+NOINTERACTION
		+NOTONAUTOMAP
		+NOBLOCKMAP
		+MOVEWITHSECTOR
		+SYNCHRONIZED
		+DONTBLAST
		+SPRITEFLIP
		FloatBobPhase 0;
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		let rl_Cvar = rl_Cvars.get();
		self.bInterpolateAngles = rl_Cvar.rl_Interpolate.GetBool();
		self.bDontInterpolate = !rl_Cvar.rl_Interpolate.GetBool();
	}
}

