.vector source;

float plat_num;
vector lastmin;
vector lastmax;

float() PlatProject =
{
	self.origin = self.source + self.velocity * (time - self.starttime);

	addentity(self);
	return PREDRAW_NEXT;
};

nonstatic void(float isnew) ParsePlatClass =
{
	local float flags;

	flags = readlong();

	self.starttime = time;

	if (flags & SENDFLAG_ORIGIN)
	{
		self.source_x = readcoord();
		self.source_y = readcoord();
		self.source_z = readcoord();
	}
	if (flags & SENDFLAG_ANGLES)
	{
		self.angles_x = readshort()*(360/256);	//not really needed for ourselves, but useful when its showing a different player.
		self.angles_y = readshort()*(360/256);
		self.angles_z = readshort()*(360/256);
	}
	if (flags & SENDFLAG_VELOCITY)
	{
		self.velocity_x = readcoord();
		self.velocity_y = readcoord();
		self.velocity_z = readcoord();
	}
	if (flags & SENDFLAG_AVELOCITY)
	{
		self.avelocity_x = readcoord();
		self.avelocity_y = readcoord();
		self.avelocity_z = readcoord();
	}

	if (flags & SENDFLAG_MODEL)
	{
		setmodel (self, readstring());
	}
	if (flags & SENDFLAG_MODELINDEX)
	{
		setmodelindex (self, readlong());
	}

	if (flags & SENDFLAG_MINS)
	{
		lastmin_x = readcoord();
		lastmin_y = readcoord();
		lastmin_z = readcoord();
	}
	if (flags & SENDFLAG_MAXS)
	{
		lastmax_x = readcoord();
		lastmax_y = readcoord();
		lastmax_z = readcoord();
	}

	if (flags & (SENDFLAG_MINS | SENDFLAG_MAXS))
	{
		setsize (self, lastmin, lastmax);
	}

	plat_num = readentitynum();
	self.predraw = PlatProject;
};

