class hd_postprocessor : LevelPostProcessor
{
	protected void Apply(Name checksum, String mapname)
	{
		let rl_Cvar = rl_Cvars.get();

		int FLOOR = 0;
		int CEILING = 1;
		Array<int> tags;

		if (rl_CVar.rl_floor_reflections.GetBool())
		{
			bool sky_special = false;

			for(int ii=0; ii < Level.Lines.Size(); ii++)
			{
				Line lin = Level.Lines[ii];
				if (lin.Special)
				{
					if ((lin.Special == 190 && lin.args[1] == 255) || (lin.Special == 271 || lin.Special == 272))
					{
						sky_special = true;
						break;
					}
				}
			}

			for(int i = 0; i < Level.Sectors.Size(); i++)
			{
				Sector sec = Level.Sectors[i];
				int tag = int(sec.GetTexture(FLOOR));
				if (tags.Find(tag) == tags.Size()) tags.Push(tag);
			}

			int tag_seed = 0;
			bool tag_used = true;
			while (tag_used)
			{
				tag_used = false;
				for(int i = 0; i < tags.Size(); i++)
				{
					let it = LevelLocals.CreateSectorTagIterator(tags[i] + tag_seed);
					if (it.Next() != -1)
					{
						tag_seed++;
						tag_used = true;
						break;
					}
				}
			}
			CVar.FindCvar("rl_floor_seed").SetInt(tag_seed);

			for(int i = 0; i < Level.Sectors.Size(); i++)
			{
				Sector sec = Level.Sectors[i];
				bool sky = (sec.GetTexture(CEILING) == SkyFlatNum);

				if ((sky_special && !sky) || (!sky_special))
				{
					AddSectorTag(i, tag_seed + int(sec.GetTexture(FLOOR)));
				}
			}
		}
	}
}
