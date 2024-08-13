class hd_lightswitch : Actor
{
	Default
	{
		RenderStyle "None";
		+NOINTERACTION
		+NOTONAUTOMAP
		+NOBLOCKMAP
		+NOGRAVITY
	}
	Array<Sector> sec;
	double floorz, ceilingz;
	float doorheight, lastdoorheight;
	vector2 here;
	hd_relighting_EventHandler Event;
	int brightest, darkest, secdarkest, farea, lifespan;
	bool moving;

	void findBrightest()
	{
		int light = -1;
		for (int i = 0; i < sec.Size(); i++)
		{
			if (sec[i].LightLevel > light)
			{
				light = sec[i].LightLevel;
				brightest = i;
			}
		}
	}
	void findDarkest()
	{
		int light = 256;
		for (int i = 0; i < sec.Size(); i++)
		{
			if (sec[i].LightLevel < light && !Event.isSpecial(sec[i]))
			{
				light = sec[i].LightLevel;
				darkest = i;
			}
		}
	}

	override void PostBeginPlay()
	{
		Super.PostBeginPlay();
		Event = hd_relighting_EventHandler(EventHandler.Find("hd_relighting_EventHandler"));
		here = (Pos.X, Pos.Y);
		
		// find front and back of the door
		for (int i = 0; i < CurSector.Lines.Size(); i++)
		{
			Line lin = CurSector.Lines[i];
			if (lin.Flags & Line.ML_TWOSIDED)
			{
				if (lin.BackSector != CurSector) sec.Push(lin.BackSector);
				if (lin.FrontSector != CurSector) sec.Push(lin.FrontSector);
			}
		}
		if (sec.Size() < 2)
		{
			Destroy();
			return;
		}
		findBrightest();
		findDarkest();

		if (darkest == brightest || sec[darkest].LightLevel == sec[brightest].LightLevel) // don't need a light switch
		{
			Destroy();
			return;
		}

		double barea, darea;
		for (int i=0; i < Event.secs.Size(); i++)
		{
			if (Event.secs[i].sec == sec[darkest].SectorNum) darea = Event.secs[i].area;
			if (Event.secs[i].sec == sec[brightest].SectorNum) barea = Event.secs[i].area;
		}

		if (darea == 0) // should not happen but avoids DIV/0
		{
			farea = int(sec[brightest].LightLevel * 0.1);
		}
		else
		{
			farea = clamp(sec[darkest].LightLevel + int(sec[brightest].LightLevel * clamp(barea / darea, 0.1, 0.9)), 0, sec[brightest].LightLevel);
		}

		CurSector.LightLevel = sec[brightest].LightLevel;
		Event.seclights[CurSector.SectorNum] = CurSector.LightLevel;

		moving = false;
		lastdoorheight = ceilingz - floorz;
		secdarkest = Event.seclights[sec[darkest].SectorNum];
		lifespan = 6;
	}
	override void Tick(void)
	{
		Super.Tick();
/*
		if (--lifespan == 0)
		{
			lifespan = 6;
		}
		else
		{
			return;
		}
*/

		floorz = CurSector.FloorPlane.ZAtPoint(here);
		ceilingz = CurSector.CeilingPlane.ZAtPoint(here);

		doorheight = ceilingz - floorz;
		moving = (doorheight != lastdoorheight || doorheight != 0); // check this for direction

		if (moving && farea > sec[darkest].LightLevel)
		{
			lastdoorheight = doorheight;
			int before = sec[darkest].LightLevel;
			sec[darkest].LightLevel = farea;
		}
		else if (floorz == ceilingz)
		{
			sec[darkest].LightLevel = Event.seclights[sec[darkest].SectorNum]; // darkest should NOT include lighting specials
		}
		else if (self.Args[0] == 11) // door open line special
		{
			Event.seclights[sec[darkest].SectorNum] = sec[darkest].LightLevel;  // note this screws up 87 in E1M2?
			self.Destroy();
		}
	}
}
