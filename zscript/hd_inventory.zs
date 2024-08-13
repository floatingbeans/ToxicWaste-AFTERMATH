// part of this bit is from Nash's mod

class hd_shade : CustomInventory
{
	Default
	{
		+Inventory.Autoactivate
		Inventory.MaxAmount 1;
	}
	hd_relighting_EventHandler Event;
	bool bShadows;

	override void BeginPlay()
	{
		bShadows = false;
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		if (!Owner)
		{
			Destroy();
			return;
		}
		if (!bShadows)
		{
			let rl_Cvar = rl_Cvars.get();
			if (rl_Cvar.rl_dual_shadows.GetBool())
			{
				spawnShadow(1);
				spawnShadow(2);
			}
			else
			{
				spawnShadow(0);
			}
			bShadows = true;
		}
	}

	void spawnShadow(int dir)
	{
		let rl_Cvar = rl_Cvars.get();
		let mo = hd_shadow(Spawn("hd_shadow", Owner.POS, NO_REPLACE));
		mo.caster = Owner;
		mo.speed = dir;
		if (Owner == players[consoleplayer].mo) return;

		Event = hd_relighting_EventHandler(EventHandler.Find("hd_relighting_EventHandler"));
		string cname = Owner.GetClassName();
		bool b;
		Actor ptr;
		[b, ptr] = Owner.A_SpawnItemEx("hd_light", flags: SXF_SETMASTER);

		if (ptr)
		{
			ptr.master = Owner;
			if (Owner.bMissile)
			{
				if (Owner.Damage > 0)
				{
					ptr.Scale.Y = rl_Cvar.rl_missile_light_scale.GetFloat() * Owner.Damage;
				}
				else
				{
					ptr.Scale.Y = rl_Cvar.rl_missile_light_scale.GetFloat();
				}
			}
			else if (Owner.bIsMonster)
			{
				ptr.Scale.Y = rl_Cvar.rl_monster_light_scale.GetFloat();
			}
			else
			{
				ptr.Scale.Y = rl_Cvar.rl_other_light_scale.GetFloat();
			}
		}
	}
	States
	{
	Use:
		TNT1 A 0;
		Stop;
	}
}
