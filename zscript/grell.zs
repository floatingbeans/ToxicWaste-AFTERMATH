// Grell -- by NMN (w/DECORATE by Xaser, ZScript by Ghastly)

Class Grell : Actor
{
   Default
  {
	Tag "Grell";
	health 300;
	radius 24;
	height 56;
	mass 400;
	speed 10;
	Obituary "%o was plagued by a grell.";
	painchance 128;
	seesound "grell/sight";
	painsound "grell/pain";
	deathsound "grell/death";
	activesound "grell/active";
	Monster;
	+DROPOFF
	+NOGRAVITY
	+DONTHARMCLASS
  }

  States
  {
	Spawn:
		GREL A 10 A_Look();
		Loop;
	See:
		GREL A 0 A_SentinelBob();
		GREL AAB 3 A_Chase();
		GREL B 0 A_SentinelBob();
		GREL BCC 3 A_Chase();
		Loop;
	Missile:
		GREL D 0 A_PlaySound("grell/attack");
		GREL D 4 A_FaceTarget();
		GREL E 4 Bright A_FaceTarget();
		GREL F 4 Bright A_SpawnProjectile("GrellBall", 32, 0, 0);
		Goto See;
	Pain:
		GREL G 3;
		GREL G 3 A_Pain();
		Goto See;
	Death:
		GREL H 5;
		GREL I 0 A_NoBlocking();
		GREL I -1 A_Scream();
	Crash:
		GREL J 4 A_StartSound("grell/thud", CHAN_AUTO);
		GREL K 4;
		GREL LM 4 A_SetFloorClip();
		GREL N -1;
		Stop;
	Raise:
		GREL M 5 A_UnSetFloorClip();
		GREL LKJIH 5;
		Goto See;
  }
}

Class GrellBall : Actor
{
  Default
  {
	Radius 8;
	Height 16;
	Speed 15;
	Damage 4;
	PoisonDamage 32;
	Renderstyle "Add";
	DeathSound "grell/projhit";
	Alpha 0.67;
	Projectile;
     +HitTracer
   }

  States
  {
    Spawn:
        FVUL AAABBB 1 Bright A_SpawnItemEx("BarbTrail",0,0,0,0,0,0,0,SXF_CLIENTSIDE,0);
        loop;
    //XDeath: //The A_RadiusGive version, if you want this over the HitTracer version
        //A_RadiusGive("GrellSlowdown", 48, RGF_PLAYERS | RGF_CUBE, 1);
    Death:
        FVUL C 0 Bright A_GiveInventory("GrellSlowdown", 1, AAPTR_TRACER);
        FVUL CDEF 4 Bright;
        stop;
  }
}

Class PowerSlow : PowerSpeed
{
  Default
  {
	Powerup.Duration -3;
	Speed 0.66;
  }
}

Class GrellSlowdown : PowerupGiver
{
  Default
  {
	+Inventory.AUTOACTIVATE;
	-Inventory.INVBAR;
	Powerup.Type "PowerSlow";
  }
}

Class Barbtrail : Actor
{
  Default
  {
    Radius 0;
    Height 1;
    RENDERSTYLE "ADD";
    ALPHA 0.75;
    PROJECTILE;
  }

  States
  {
  Spawn:
    TNT1 A 1 Bright;
    SSFX ABCDEFG 2 Bright;
    Stop;
  }
}
