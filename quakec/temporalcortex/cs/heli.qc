float() HeliProject =
{
	makevectors(self.angles);

	drawline3d (2, self.origin, self.origin + v_forward * 256, '1 0 0', 1);
	drawline3d (2, self.origin, self.origin + v_right * 256, '0 1 0', 1);
	drawline3d (2, self.origin, self.origin + v_up * 256, '0 0 1', 1);

	return PREDRAW_AUTOADD;
};

nonstatic void(float isnew) ParseHeliClass =
{
	local float ent;
	local float fl;

	fl = readbyte();

	if (fl != self.frame || isnew)
	{
		self.frame2 = self.frame;
		self.lerptime = time;
		self.frame = fl;
	}

	fl = readlong();

	if (fl & SENDFLAG_ORIGIN)
	{
		self.origin_x = readcoord();
		self.origin_y = readcoord();
		self.origin_z = readcoord();
	}
	if (fl & SENDFLAG_ANGLES)
	{
		self.angles_x = (readshort()*360)/256;
		self.angles_y = (readshort()*360)/256;
		self.angles_z = (readshort()*360)/256;
	}
	if (fl & SENDFLAG_VELOCITY)
	{
		self.velocity_x = readcoord();
		self.velocity_y = readcoord();
		self.velocity_z = readcoord();
	}
	if (fl & SENDFLAG_AVELOCITY)
	{
		self.avelocity_x = readcoord();
		self.avelocity_y = readcoord();
		self.avelocity_z = readcoord();
	}

	if (fl & SENDFLAG_MODEL)
	{
		setmodel (self, readstring());
	}
	if (fl & SENDFLAG_MODELINDEX)
	{
		setmodelindex (self, readlong());
	}

	if (fl & SENDFLAG_MINS)
	{
		lastmin_x = readcoord();
		lastmin_y = readcoord();
		lastmin_z = readcoord();
	}
	if (fl & SENDFLAG_MAXS)
	{
		lastmax_x = readcoord();
		lastmax_y = readcoord();
		lastmax_z = readcoord();
	}

	if (fl & (SENDFLAG_MINS | SENDFLAG_MAXS))
	{
		setsize (self, lastmin, lastmax);
	}

	ent = readentitynum ();
	self.owner = findentity (world, entnum, ent);

	self.drawmask = MASK_NORMAL;	//general view.
	self.predraw = HeliProject;
};
