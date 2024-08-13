class hd_ghostmissile : Actor
{
	Default
	{
		RenderStyle "None";
		+NOGRAVITY
		+FLOAT
		+MISSILE	
		+NOTONAUTOMAP
		+BOUNCEONWALLS
		+BOUNCEONFLOORS
		+BOUNCEONCEILINGS
		+ALLOWBOUNCEONACTORS
		+BOUNCEONACTORS
		+NOTELESTOMP
		Speed 0;
	}
	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		bool b;
		Actor ptr;
		[b, ptr] = A_SpawnItemEx("hd_ghostlight", flags: SXF_SETMASTER);
		if (ptr)
		{
			ptr.master = self;
		}
	}
	States
	{
	Spawn:
		TNT1 A 1
		{
			self.A_SetSpeed(FRandom(-0.1, 0.1));
		}
		Loop;
	Death:
		Stop;
	}
}
