class hd_sectors
{
	int sec;
	double area, centerZ, floorZ, height, volume;
	vector2 cspot;
	bool anim;

	hd_sectors init(int sec, double area)
	{
		int FLOOR=0, CEILING=1;
		self.sec = sec;
		self.area = area;
		self.centerZ = (Level.Sectors[sec].CeilingPlane.ZAtPoint(Level.Sectors[sec].CenterSpot) - Level.Sectors[sec].FloorPlane.ZAtPoint(Level.Sectors[sec].CenterSpot)) * 0.5;
		self.floorZ = Level.Sectors[sec].FloorPlane.ZAtPoint(Level.Sectors[sec].CenterSpot);
		self.Height = self.centerZ * 2;
		self.cspot = Level.Sectors[sec].CenterSpot;
		self.volume = area * (Level.Sectors[sec].CeilingPlane.ZAtPoint(self.cspot) - Level.Sectors[sec].FloorPlane.ZAtPoint(self.cspot)) / 12.0;
		self.anim = false;
		return self;
	}
	void setvolume()
	{
		self.volume = self.area * (Level.Sectors[sec].CeilingPlane.ZAtPoint(self.cspot) - Level.Sectors[sec].FloorPlane.ZAtPoint(self.cspot)) / 12.0;
	}
}

// https://github.com/mapbox/polylabel/blob/master/polylabel.js
class hd_polycell
{
	double X,Y,H,D,Max;
	Array<double> vx, vy;
	Sector sec;

	hd_polycell init(double x, double y, double h, Array<double> vx, Array<double> vy, Sector sec)
	{
		self.X = x;
		self.Y = y;
		self.H = h;
		self.vx.Copy(vx);
		self.vy.Copy(vy);
		self.sec = sec;
		self.D = self.pointToPolygonDist((self.X,self.Y), self.sec);
		self.Max = self.D + h * 1.41421356237;
		return self;
	}
	bool isInsideSector(Sector sec, vector2 v2) // note does NOT always work
	{
		let result = Level.PointInSector(v2);
		if (result == sec)
		{
			double z = sec.FloorPlane.ZatPoint(v2);
			return Level.IsPointInLevel((v2.x, v2.y, z));
		}
		return false;
	}
	vector2 pointOnLine(vector2 startPoint, vector2 endPoint, double segment, double totalSegments)
	{
		double x = (startPoint.x + ((endPoint.x - startPoint.x) / totalSegments) * segment);
		double y = (startPoint.y + ((endPoint.y - startPoint.y) / totalSegments) * segment);
		return (x,y);
	}

	double pointToPolygonDist(vector2 p, Sector sec)
	{
		if (!isInsideSector(sec, p)) return -double.infinity;

		bool inside = false;
		double minDistSq = double.infinity;
		int j = self.vx.Size() - 1;
		for (int i = 0; i < self.vx.Size(); i++)
		{
			vector2 a = (self.vx[i], self.vy[i]);
			vector2 b = (self.vx[j], self.vy[j]);

			bool hit = false;
			for (int ii = 1; ii < 20; ii++)
			{
				vector2 amid = pointOnLine(p, a, ii, 20);
				vector2 bmid = pointOnLine(p, b, ii, 20);

				if (!isInsideSector(sec, amid) || !isInsideSector(sec, bmid))
				{
					hit = true;
					break;
				}
			}
			if (hit)
			{
				j = i + 1;
				continue;
			}

			double m = getSegDistSq(p, a, b);
			minDistSq = m < minDistSq ? m : minDistSq;
			j = i + 1;
		}
		return minDistSq == 0 ? 0 : sqrt(minDistSq);
	}
	double getSegDistSq(vector2 p, vector2 a, vector2 b)
	{
		double x = a.x;
		double y = a.y;
		double dx = b.x - x;
		double dy = b.y - y;

		if (dx != 0 || dy != 0)
		{
			double t = ((p.x - x) * dx + (p.y - y) * dy) / (dx * dx + dy * dy);
			if (t > 1)
			{
				x = b.x;
				y = b.y;
			}
			else if (t > 0)
			{
				x += dx * t;
				y += dy * t;
			}
		}
		dx = p.x - x;
		dy = p.y - y;

		return dx * dx + dy * dy;
	}
}
