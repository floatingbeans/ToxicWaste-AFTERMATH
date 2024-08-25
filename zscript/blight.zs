Class Blightlord : Actor
{
	Default
	{
		//$Category Monsters
		//$Title "Wasp Satyr"
		Health 1400;
		Radius 20;
		Height 78;
		Scale 1.2;
		Mass 800;
		Speed 56;
		PainChance 64;
		MeleeRange 56;
		DamageType "Poison";
		DamageFactor "Poison", 0;
		Monster;
		+FLOORCLIP;
		+MISSILEEVENMORE;
		SeeSound "Blightlord/see";
		PainSound "Blightlord/pain";
		DeathSound "Blightlord/death";
		ActiveSound "Blightlord/act";
		HitObituary "%o got whacked by a Wasp Satyr";
		Obituary "%o got vitriolized by a Wasp Satyr";
	}

	States
	{
	Spawn:
		VBLI AB 10 A_Look;
		Loop;
	See:
		VBLI AABBCCDD 2 A_Chase;
		Loop;
	Melee:
		TNT1 A 0 A_Startsound("Blightlord/attack1");
		VBLI EF 6 A_FaceTarget;
		VBLI G 6 
		{
			A_CustomMeleeAttack(random(15,55),"imp/melee","skeleton/swing","Melee",true);
			if (target && CheckMeleeRange())
			{
				let blp = new("BlightlordPoison");
				if (blp)
				{
					blp.victim = target;
					blp.poisoner = self;
				}
			}
		}
		Goto See;
	Missile:
		TNT1 A 0
 		{
			if (target && Distance2D(target) <= 1024)
			{
				switch(random(1,3))
				{
					case 1:SetStateLabel("Slimeball");break;
					case 2:SetStateLabel("Toxiccloud");break;
					case 3:SetStateLabel("Waspswarm");break;
				}
			}
		}
	Slimeball:
		TNT1 A 0 A_Startsound("Blightlord/attack2");
		VBLI FE 4 A_FaceTarget;
		VBLI RS 6 A_FaceTarget;
		TNT1 A 0 A_Jump(256,1,2,3);
		VBLI T random(1,3) A_SpawnProjectile("BlightlordSlime",frandom(40.0,50.0),frandom(-5.0,5.0),frandom(-1.5,1.5));
		VBLI T random(1,3) A_SpawnProjectile("BlightlordSlime",frandom(40.0,50.0),frandom(-5.0,5.0),frandom(-1.5,1.5));
		VBLI T random(1,3) A_SpawnProjectile("BlightlordSlime",frandom(40.0,50.0),frandom(-5.0,5.0),frandom(-1.5,1.5));
		VBLI T random(1,3) A_SpawnProjectile("BlightlordSlime",frandom(40.0,50.0),frandom(-5.0,5.0),frandom(-1.5,1.5));
		VBLI T random(1,3) A_SpawnProjectile("BlightlordSlime",frandom(40.0,50.0),frandom(-5.0,5.0),frandom(-1.5,1.5));
		VBLI G 6 A_SpawnProjectile("BlightlordSlime",frandom(40.0,50.0),frandom(-5.0,5.0),frandom(-1.5,1.5));
		Goto See;
	Toxiccloud:
		TNT1 A 0 A_Startsound("Blightlord/attack3");
		VBLI J 2 A_SlimeParticle(45,-3);
		VBLI J 2 A_SlimeParticle(50,-3);
		VBLI J 2 A_SlimeParticle(55,-3);
		VBLI J 2 A_SlimeParticle(60,-3);
		VBLI I 2 A_SlimeParticle(65,-2);
		VBLI I 2 A_SlimeParticle(70,-2);
		VBLI I 2 A_SlimeParticle(75,-1);
		VBLI I 2 A_SlimeParticle(70,-1);
		VBLI I 2 A_SlimeParticle(65,0);
		VBLI J 2 A_SlimeParticle(60,4);
		VBLI J 2 A_SlimeParticle(55,4);
		VBLI J 2 A_SlimeParticle(50,4);
		TNT1 A 0 A_SlimeParticle(45,-3);
		VBLI K 3 A_Toxiccloud();
		VBLI K 3 A_Toxiccloud();
		VBLI K 3 A_Toxiccloud();
		Goto See;
	Waspswarm:
		TNT1 A 0 A_Startsound("Blightlord/attack4");
		VBLI J 2 A_CloudParticle(-30,4);
		VBLI J 2 A_CloudParticle(-25,4);
		VBLI I 2 A_CloudParticle(-20,4);
		VBLI I 2 A_CloudParticle(-15,4);
		VBLI I 2 A_CloudParticle(-10,4);
		VBLI J 2 A_CloudParticle(-5,4);
		VBLI J 2 A_CloudParticle(0,4);
		VBLI J 2 A_CloudParticle(5,4);
		TNT1 A 0 A_Waspswarm();
		VBLI K 2 A_CloudParticle(10,4);
		VBLI K 2 A_CloudParticle(15,4);
		VBLI K 2 A_CloudParticle(20,4);
		Goto See;
	Pain:
		VBLI H 2;
		VBLI H 2 A_Pain;
		Goto See;
	Death:
		VBLI H 8;
		VBLI L 7 A_Scream;
		VBLI M 6;
		VBLI N 6;
		VBLI O 6 A_NoBlocking;
		VBLI P 10;
		VBLI Q -1;
		Stop;
	Raise:
		VBLI QPONML 5;
		Goto See;
	}
	
	void A_Waspswarm()
	{
		for (int i = 0; i < random(3,5); i++)
		{
			A_SpawnProjectile("BlightlordWasp",frandom(40.0,50.0),frandom(-5.0,5.0),frandom(-20.0,20.0),CMF_OFFSETPITCH,frandom(-10.0,10.0));
		}
	}
	
	void A_Toxiccloud()
	{
		for (int i = 0; i < random(5,7); i++)
		{
			A_SpawnProjectile("BlightlordToxiccloud",frandom(40.0,50.0),frandom(-5.0,5.0),frandom(-5.5,5.5),CMF_OFFSETPITCH,frandom(-2.5,2.5));
		}
	}
	
	void A_SlimeParticle(int zofs, int zvel)
	{
		A_FaceTarget();
		for (int i = 0; i < 360; i += 45)
		{
			TextureID ptx;
			static const name ppsprites[] = {"VBLSA0","VBLSB0","VBLSC0","VBLSD0"};
			name tn = ppsprites[random(0, ppsprites.Size()-1)];
			ptx = TexMan.CheckForTexture(tn);
			A_SpawnParticleEx("80FF80",ptx,
			style:STYLE_Normal,
			flags:SPF_FULLBRIGHT,
			lifetime:7,
			size:8,
			xoff:cos(i)*radius+random(-8,8),
			yoff:sin(i)*radius+random(-8,8),
			zoff:zofs,
			velx:frandom(-2.5,2.5),
			vely:frandom(-2.5,2.5),
			velz:zvel+frandom(-1.0,1.0),
			startalphaf:1.0,
			fadestepf:-1);
		}
	}
	
	void A_CloudParticle(int zofs, int zvel)
	{
		A_FaceTarget();
		TextureID ptx;
		static const name ppsprites[] = {"VBLCA0","VBLCB0","VBLCC0","VBLCD0"};
		name tn = ppsprites[random(0, ppsprites.Size()-1)];
		ptx = TexMan.CheckForTexture(tn);
		A_SpawnParticleEx("808080",ptx,
		style:STYLE_Normal,
		flags:SPF_ROLL|SPF_FULLBRIGHT,
		lifetime:15,
		size:100,
		xoff:random(-radius*2,radius*2),
		yoff:random(-radius*2,radius*2),
		zoff:zofs,
		velx:frandom(-0.5,0.5),
		vely:frandom(-0.0,2.5),
		velz:zvel+frandom(-1.0,1.0),
		startalphaf:0.5,
		fadestepf:-1,
		sizestep:random(1,2),
		startroll:random(0,359));
	}
}

Class BlightlordSlime : Actor
{
	int rolldir;
	Default
	{
		Radius 3;
		Height 5;
		scale 0.5;
		Speed 50;
		Projectile;
		DamageType "Poison";
		PoisonDamage 1, 3;
		Renderstyle "Translucent";
		Alpha 1.0;
		+ADDITIVEPOISONDAMAGE;
		+ROLLSPRITE;
		+RANDOMIZE;
		SeeSound "Blightlord/slime";
		DeathSound "Blightlord/slimesplat";
		Decal "BlightlordSlimeScorch";
	}
	States
	{
	Spawn:
		TNT1 A 4 Nodelay
		{
			roll = random(0,359);
			rolldir = randompick(-20,-15,-10,10,15,20);
			Poisondamage = random(3,5);
		}
	Fly:
		VBLS AAAABBBBCCCCDDDD 1 bright
		{
			roll += rolldir;
		}
		Loop;
	Death:
		TNT1 A 0
		{
			for (int i = 0; i < 10; i += 1)
			{
				TextureID ptx;
				static const name ppsprites[] = {"VBLSA0","VBLSB0","VBLSC0","VBLSD0"};
				name tn = ppsprites[random(0, ppsprites.Size()-1)];
				ptx = TexMan.CheckForTexture(tn);
				A_SpawnParticleEx("FFFFFF",ptx,
				style: STYLE_Translucent,
				flags:SPF_FULLBRIGHT,
				lifetime:7,
				size:5,
				xoff:0,
				yoff:0,
				zoff:0,
				velx:frandom(-2.5,2.5),
				vely:frandom(-2.5,2.5),
				velz:frandom(-2.5,2.5),
				startalphaf:1.0,
				fadestepf:-1,
				sizestep:frandom(0.5,1.0));
			}
		}
		Stop;
	}
	
	override int SpecialMissileHit(Actor victim)
	{
		if (victim && victim.GetSpecies() == "BlightlordWasp") return 1;
		else return -1;
	}
}

Class BlightlordToxiccloud : Actor
{	
	int rolldir;
	Default
	{
		Radius 10;
		Height 20;
		Speed 10;
		Projectile;
		DamageType "Poison";
		PoisonDamage 2, 3;
		Renderstyle "Translucent";
		Alpha 0.2;
		Scale 0.5;
		+ADDITIVEPOISONDAMAGE;
		+RANDOMIZE;
		+ROLLSPRITE;
	}
	States
	{
	Spawn:
		TNT1 A 0 Nodelay
		{
			roll = random(0,359);
			rolldir = randompick(-20,-15,-10,10,15,20);
			Poisondamage = random(3,5);
		}
		TNT1 A 0 A_Jump(256,1,2,3,4,5,6);
	Fly:
		VBLC ABCDABCDABCDABCD 5 bright
		{
			scale.x += 0.05;
			scale.y += 0.05;
			roll += rolldir;
			A_SetSize(radius+0.5,height+1,false);
		}
	Fade:
		VBLC ABCD 5 bright
		{
			Poisondamage = 1;
			roll += rolldir;
			A_Fadeout(0.05);
		}
		Loop;
	Death:
		VBLC ABCD 5 bright 
		{
			bTHRUACTORS = true;
			A_Fadeout(0.05);
		}
		Stop;
	}
	
	override int SpecialMissileHit(Actor victim)
	{
		if (victim && victim.GetSpecies() == "BlightlordWasp") return 1;
		else return -1;
	}
}

Class BlightlordWasp : Actor
{
	Default
	{
		Health 5;
		Radius 8;
		Height 8;
		Scale 0.4;
		Speed 12;
		Projectile;
		DamageType "Poison";
		DamageFactor "Poison", 0;
		+SEEKERMISSILE;
		-NOBLOCKMAP;
		+SHOOTABLE;
		Reactiontime 10;
		BounceType "Hexen";
		DeathSound "BlightlordWasp/death";
		Obituary "%o was stung to death by a wasp.";
	}
	States
	{
	Spawn:
		TNT1 A 0 Nodelay A_Jump(256,1,2,3,4,5,6);
		VWSP AAABBB 1
		{	
			if (!tracer && target && target.target) tracer = target.target;
			if (tracer && Distance2D(tracer) < 128)	vel *= 0.5;
			if ((!tracer || !target || (target && target.health < 1)) && !random(0,50)) SetStateLabel("Death");
			WeaveIndexXY = random(0,63);
			WeaveIndexZ = random(0,63);
			A_Weave(1,1,7.5,7.5);
			if (!random(0,5)) A_SeekerMissile(15,30,SMF_PRECISE);
			A_Startsound("BlightlordWasp/buzz",23111,CHANF_NOSTOP,0.2,1.0,frandom(0.666,0.777),frandom(0.0,0.1));
		}
		Loop;
	Death:
		TNT1 A 0
		{	
			if (!random(0,1)) bXFLIP = true;
			bSHOOTABLE = false;
			bTHRUACTORS = true;
			bMISSILE = false;
			bNOGRAVITY = false;
		}
	Checkfloor:
		VWSP C 1
		{	
			if (pos.z == floorz)
			{
				A_Stop();
				bNOINTERACTION = true;
				SetStateLabel("Hitfloor");
			}
		}
		Loop;
	Hitfloor:
		VWSP D 35 A_CheckSight("Fadeout");
		VWSP D 35 A_CheckRange(1024,"Fadeout",true);
		Loop;
	Fadeout:
		VWSP D 5 A_Fadeout(0.1);
		Loop;
	}
	
	override int SpecialMissileHit(Actor victim)
	{
		if (victim && victim != target && victim.bSHOOTABLE && victim.GetSpecies() != self.GetSpecies() && !random(0,9))
		{
			victim.damagemobj(self,target,random(1,3),"Poison",DMG_THRUSTLESS);
			A_Countdown();
			let blp = new("BlightlordPoison");
			if (blp)
			{
				blp.victim = tracer;
				blp.poisoner = self;
			}
		}
		return 1;
	}
	
	override void Tick()
	{
		Super.Tick();
		if (!isFrozen() && InStateSequence(curstate, spawnstate) && GetAge() % 105 == 0) A_Countdown();
	}
}

Class BlightlordWasphive : Actor
{
	Default
	{
		//$Category Monsters
		//$Title "Blight Lord's wasp hive"
		Radius 16;
		Height 32;
		Health 100;
		Painchance 200;
		DamageFactor "Poison", 0;
		Monster;
		+SPAWNCEILING;
		+NOGRAVITY;
		+DONTTHRUST;
		+DONTFALL;
		+NOBLOODDECALS;
		+LOOKALLAROUND;
		BloodColor "80 58 30";
		DeathSound "Blightlord/slime";
	}
	States
	{
	Spawn:
		VHIV A 10 A_Look;
		Loop;
	See:
		VHIV A random(15,25)
		{	
			if (target && Distance3D(target) < 368) A_Wasphiveswarm();
			A_Startsound("BlightlordWasp/buzz",23111,CHANF_OVERLAP,0.1,1.0,frandom(0.777,0.888),frandom(0.0,0.1));
		}
		Loop;
	Pain:
		TNT1 A 0 A_Jump(256,1,2,3);
		VHIV A random(1,3) A_Wasphiveswarm();
		VHIV A random(1,3) A_Wasphiveswarm();
		VHIV A random(1,3) A_Wasphiveswarm();
		VHIV A random(1,3) A_Wasphiveswarm();
		goto See;
	Death:
		VHIV B 1 A_ScreamAndUnblock();
		VHIV B 1 A_SpawnDebris("BlightlordWasphiveDebris",false,2.0);
		VHIV B -1;
		Stop;
	}
	
	void A_Wasphiveswarm()
	{
		A_SpawnProjectile("BlightlordWasp",0,frandom(-5.0,5.0),frandom(-20.0,20.0),CMF_OFFSETPITCH,frandom(-10.0,10.0));
	}
}

Class BlightlordWasphiveDebris : Actor
{
	int rolldir;
	Default
	{
		Health 6;
		Radius 5;
		Height 5;
		+THRUACTORS;
		+NOTONAUTOMAP;
		+NOBLOCKMAP;
		+NOTELEPORT;
		+ROLLSPRITE;
		+ROLLCENTER;
		scale 0.7;
	}
	States
	{
	Spawn:
		TNT1 A 0 Nodelay A_Jump(128,2);
		VHIV CD 1
		{
			if (!random(0,1)) bXFLIP = true;
			rolldir = randompick(-40,-20,20,40);
		}
	Fall:
		#### # 1
		{
			roll += rolldir;
			if (pos.z == floorz) 
			{
				A_Stop();
				A_Startsound("Blightlord/slimesplat");
				bNOINTERACTION = true;
				for (int i = 0; i < 10; i += 1)
				{
					A_SpawnParticle("805830",
					lifetime:7,
					size:8,
					xoff:0,
					yoff:0,
					zoff:0,
					velx:frandom(-2.5,2.5),
					vely:frandom(-2.5,2.5),
					velz:frandom(0,3.5),
					startalphaf:1.0,
					fadestepf:-1);
				}
				destroy();
			}
		}
		Loop;
	}
}

Class BlightlordPoison : Thinker
{
	actor victim;
	actor poisoner;
	override void Tick()
	{
		super.Tick();
		if (!victim || victim.GetAge() % 140 == 0)
		{
			Destroy();
			return;
		}
		if (victim.health > 0 && victim.GetAge() % 35 == 0 && poisoner)
		{
			int maxdmg;
			if (poisoner.GetSpecies() == "BlightlordWasp") maxdmg = 1;
			else maxdmg = 10;
			victim.DamageMobj(poisoner,poisoner,random(1,maxdmg),"Poison",DMG_THRUSTLESS);
			return;
		}
	}
}