/*
*/
void (entity targ, entity inflictor, entity attacker, float damage) T_Damage;
void () player_run;
void(entity bomb, entity attacker, float rad, entity ignore) T_RadiusDamage;
void(vector org, vector vel, float damage) SpawnBlood;
void() SuperDamageSound;

void(float speed, vector dir) W_FireGrappleHook;

#ifdef TEMPORALCORTEX
void() s_explode1;
void(entity receiver, vector vel) monster_death_flyback;
void(float damage, float ammotype, float speed, vector org, vector dir) shoot_bullet;
#endif

// called by worldspawn
void() W_Precache =
{
	precache_sound ("weapons/r_exp3.wav");	// new rocket explosion
	precache_sound ("weapons/rocket1i.wav");	// spike gun
	precache_sound ("weapons/sgun1.wav");
	precache_sound ("weapons/guncock.wav");	// player shotgun
	precache_sound ("weapons/ric1.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric2.wav");	// ricochet (used in c code)
	precache_sound ("weapons/ric3.wav");	// ricochet (used in c code)
	precache_sound ("weapons/spike2.wav");	// super spikes
	precache_sound ("weapons/tink1.wav");	// spikes tink (used in c code)
	precache_sound ("weapons/grenade.wav");	// grenade launcher
	precache_sound ("weapons/bounce.wav");		// grenade bounce
	precache_sound ("weapons/shotgn2.wav");	// super shotgun
};

float() crandom =
{
	return 2*(random() - 0.5);
};

#ifdef TEMPORALCORTEX
void() explo_think =
{
	s_explode1 ();
};

void(vector pos) SpawnExplosion =
{
	local entity e;
	e = spawn();
	e.classname = "explosion";
	e.movetype = MOVETYPE_NONE;
	e.solid = SOLID_NOT;
	e.velocity = '0 0 0';
	e.touch = SUB_Null;
	setorigin (e, pos);
	setmodel (e, "progs/s_explod.spr");

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, pos_x);
	WriteCoord (MSG_BROADCAST, pos_y);
	WriteCoord (MSG_BROADCAST, pos_z);

	e.think = explo_think;
	e.nextthink = time;
};
#endif

/*
================
W_FireAxe
================
*/
void() W_FireAxe =
{
	local	vector	source;
	local	vector	org;

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*64, FALSE, self);
	if (trace_fraction == 1.0)
		return;

	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		trace_ent.axhitme = 1;
		SpawnBlood (org, '0 0 0', 20);
		T_Damage (trace_ent, self, self, 20);
	}
	else
	{	// hit wall
		sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);

#ifdef TEMPORALCORTEX
		if (autocvar(test_buggyaxehit, 0) || isdp)
		{	//for compat with dp. :(
			WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte (MSG_BROADCAST, TE_GUNSHOT);
			WriteCoord (MSG_BROADCAST, org_x);
			WriteCoord (MSG_BROADCAST, org_y);
			WriteCoord (MSG_BROADCAST, org_z);
		}
		else
		{
			WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
			WriteByte (MSG_MULTICAST, TE_GUNSHOT);
			WriteCoord (MSG_MULTICAST, org_x);
			WriteCoord (MSG_MULTICAST, org_y);
			WriteCoord (MSG_MULTICAST, org_z);

			multicast(org, MULTICAST_PVS);
		}

		//WriteByte (MSG_MULTICAST, SVC_CGAMEPACKET);
		//WriteShort (MSG_MULTICAST, 9);
		//WriteString (MSG_MULTICAST, "testevent");

		//multicast(org, MULTICAST_PVS);
#else
		if (autocvar(test_buggyaxehit, 0) || isdp)
		{	//for compat with dp. :(
			WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte (MSG_BROADCAST, 0x80|TE_GUNSHOT);
			WriteCoord (MSG_BROADCAST, org_x);
			WriteCoord (MSG_BROADCAST, org_y);
			WriteCoord (MSG_BROADCAST, org_z);

			WriteByte (MSG_BROADCAST, 8);
			WriteString (MSG_BROADCAST, "overlong\n");
		}
		else
		{
			WriteByte (MSG_MULTICAST, SVC_TEMPENTITY);
			WriteByte (MSG_MULTICAST, 0x80|TE_GUNSHOT);
			WriteCoord (MSG_MULTICAST, org_x);
			WriteCoord (MSG_MULTICAST, org_y);
			WriteCoord (MSG_MULTICAST, org_z);

			WriteByte (MSG_MULTICAST, 8);
			WriteString (MSG_MULTICAST, "overlong\n");
			multicast(org, MULTICAST_PVS);
		}
#endif
	}
};


//============================================================================


vector() wall_velocity =
{
	local vector	vel;

	vel = normalize (self.velocity);
	vel = normalize(vel + v_up*(random()- 0.5) + v_right*(random()- 0.5));
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;

	return vel;
};


/*
================
SpawnMeatSpray
================
*/
void(vector org, vector vel) SpawnMeatSpray =
{
	local	entity missile;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_NOT;

	makevectors (self.angles);

	missile.velocity = vel;
	missile.velocity_z = missile.velocity_z + 250 + 50*random();

	missile.avelocity = '3000 1000 2000';

// set missile duration
	missile.nextthink = time + 1;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/zom_gib.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, org);
};

/*
================
SpawnBlood
================
*/
void(vector org, vector vel, float damage) SpawnBlood =
{
	particle (org, vel*0.1, 73, damage*2);
};

/*
================
spawn_touchblood
================
*/
void(float damage) spawn_touchblood =
{
	local vector	vel;

	vel = wall_velocity () * 0.2;
	SpawnBlood (self.origin + vel*0.01, vel, damage);
};


/*
================
SpawnChunk
================
*/
/*void(vector org, vector vel) SpawnChunk =
{
	particle (org, vel*0.02, 0, 10);
};*/

/*
==============================================================================

MULTI-DAMAGE

Collects multiple small damages into a single damage

==============================================================================
*/

entity	multi_ent;
float	multi_damage;

void() ClearMultiDamage =
{
	multi_ent = world;
	multi_damage = 0;
};

void() ApplyMultiDamage =
{
	if (!multi_ent)
		return;
	T_Damage (multi_ent, self, self, multi_damage);
};

void(entity hit, float damage) AddMultiDamage =
{
	if (!hit)
		return;

	if (hit != multi_ent)
	{
		ApplyMultiDamage ();
		multi_damage = damage;
		multi_ent = hit;
	}
	else
		multi_damage = multi_damage + damage;
};

/*
==============================================================================

BULLETS

==============================================================================
*/

/*
================
TraceAttack
================
*/
void(float damage, vector dir) TraceAttack =
{
	local	vector	vel, org;

	vel = normalize(dir + v_up*crandom() + v_right*crandom());
	vel = vel + 2*trace_plane_normal;
	vel = vel * 200;

	org = trace_endpos - dir*4;

	if (trace_ent.takedamage)
	{
		SpawnBlood (org, vel*0.2, damage);
		AddMultiDamage (trace_ent, damage);
	}
	else
	{
		if (checkbuiltin(te_gunshot))
			te_gunshot(org);
		else
		{
			WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte (MSG_BROADCAST, TE_GUNSHOT);
#ifdef QWSSQC
			WriteByte (MSG_BROADCAST, 1);	//count
#endif
			WriteCoord (MSG_BROADCAST, org_x);
			WriteCoord (MSG_BROADCAST, org_y);
			WriteCoord (MSG_BROADCAST, org_z);
		}
	}
};

/*
================
FireBullets

Used by shotgun, super shotgun, and enemy soldier firing
Go to the trouble of combining multiple pellets into a single damage call.
================
*/
void(float shotcount, vector dir, vector spread) FireBullets =
{
	local	vector direction;
	local	vector	src;

	makevectors(self.v_angle);

	src = self.origin + v_forward*10;
	src_z = self.absmin_z + self.size_z * 0.7;

	ClearMultiDamage ();
	while (shotcount > 0)
	{
		direction = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;

		traceline (src, src + direction*2048, FALSE, self);
		if (trace_fraction != 1.0)
			TraceAttack (4, direction);

		shotcount = shotcount - 1;
	}
	ApplyMultiDamage ();
};

#ifdef TEMPORALCORTEX
/*
==============================================================================

TEMPORAL CORTEX BULLETS

==============================================================================
*/

void() bullet_think =
{
	local vector newvel;

	newvel = self.velocity;

	makevectors( self.angles );

	newvel -= v_forward * self.bullet_drag;
	newvel_z -= self.bullet_weight;

	self.velocity = newvel;

	//dprint("Old bullet damage: ");
	//dprint(ftos(self.bullet_damage));
	//dprint("\n");

	self.bullet_damage -= self.bullet_drag * frametime;

	//dprint("New bullet damage: ");
	//dprint(ftos(self.bullet_damage));
	//dprint("\n");

	if (self.oldorigin != self.origin)
		self.SendFlags |= SENDFLAG_ORIGIN;
	if (self.oldangles != self.angles)
		self.SendFlags |= SENDFLAG_ANGLES;
	if (self.oldavel != self.avelocity)
		self.SendFlags |= SENDFLAG_AVELOCITY;
	if (self.oldvel != self.velocity)
		self.SendFlags |= SENDFLAG_VELOCITY;

	if (self.origin != self.oldorigin)
		self.oldorigin = self.origin;
	if (self.angles != self.oldangles)
		self.oldangles = self.angles;
	if (self.avelocity != self.oldavel)
		self.oldavel = self.avelocity;
	if (self.velocity != self.oldvel)
		self.oldvel = self.velocity;

	if (self.owner)
		if (self.owner.items2 & IT2_INCENDIARY_AMMO)
			trailparticles(particleeffectnum("tr_rocket"), self, self.origin, self.origin + v_forward * (100 * frametime));

	//dprint("trace_fraction: ");
	//dprint(ftos(trace_fraction));
	//dprint("\n");

	self.oldangles = self.angles;

	self.nextthink = time;
};

void() bullet_touch =
{
	local float hit;
	local entity own;

	own = self.owner;

	hit = TRUE;

	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	makevectors (self.angles);

	if ( cvar("tc_sv_friendlyfire_monster") == 0 )
	{
		if ( other.relationship_group & self.owner.relationship_group_like )
		{
			setorigin (self, self.origin + v_forward * (other.size_x + 1));
			self.velocity += v_forward * 1000;
			hit = FALSE;
		}
	}

	if ( cvar("tc_sv_friendlyfire_pvp") == 0 && !deathmatch )
	{
		if ( other.relationship_group & self.owner.relationship_group_like )
		{
			setorigin (self, self.origin + v_forward * (other.size_x + 1));
			self.velocity += v_forward * 1000;
			hit = FALSE;
		}
	}

	if ( hit )
	{
		// hit something that bleeds
		if (other.takedamage)
		{
			if (!(own.items2 & IT2_INCENDIARY_AMMO))
			{
				if ( own.items & IT_QUAD )
				{
					spawn_touchblood (self.bullet_damage * 4);
					T_Damage (other, self, own, self.bullet_damage * 4);
				}
				else
				{
					spawn_touchblood (self.bullet_damage);
					T_Damage (other, self, own, self.bullet_damage);
				}

				if (other.health <= 0 && other.flags & (FL_MONSTER | FL_CLIENT))
				{
					makevectors(self.angles);
					monster_death_flyback(other, self.velocity);
				}
			}
			else
			{
				if ( own.items & IT_QUAD )
				{
					T_RadiusDamage (self, own, 40 * 4, self);	// Missi: Insane. Let's see how this plays out (2026.9.14)
					SpawnExplosion (self.origin);
				}
				else
				{
					T_RadiusDamage (self, own, 40, self);
					SpawnExplosion (self.origin);
				}
			}
		}
		else
		{
			WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
			if (self.classname == "bullet")
				WriteByte (MSG_BROADCAST, TE_SPIKE);
			WriteCoord (MSG_BROADCAST, self.origin_x);
			WriteCoord (MSG_BROADCAST, self.origin_y);
			WriteCoord (MSG_BROADCAST, self.origin_z);
		}
	}

	makevectors(self.angles);

	// Missi: Check if we penetrated a surface
	// NOTE: We start the trace in the wall or monster/player, so that trace_startsolid is set but not trace_allsolid, unless we really did not breach,
	// in which case both trace_startsolid and trace_allsolid are set to true. The below "else if" statement deals with that logic. (2026.9.19)
	traceline(self.origin + v_forward * 4, self.origin + v_forward * (4 * self.bullet_penetration_mult), FALSE, self);

	// Missi: World case, we hit a wall that the above line trace caught, but managed to break through the wall (2026.9.19)
	if (trace_inopen && trace_startsolid && !trace_allsolid)
	{
		shoot_bullet (self.bullet_damage, self.bullet_type, vlen(self.velocity), self.origin + v_forward * (4 * self.bullet_penetration_mult), normalize(self.velocity));
	}
	// Missi: Monster/player case, we hit a monster or player that the above line trace caught, which requires special handling (2026.9.19)
	else if (trace_allsolid)
	{
		if (trace_ent)
		{
			// Missi: Bullets don't cut through this many units on organic entities. Note that with
			// monsters or clients, the bullet penetration multiplier on ammo is doubled (2026.9.19)
			if ((trace_ent.maxs_x + trace_ent.maxs_y) <= (32 + (self.bullet_penetration_mult * 2)))
			{
				//dprint ("bullet penetrated an enemy\n");
				shoot_bullet (self.bullet_damage, self.bullet_type, vlen(self.velocity), trace_endpos + v_forward * (trace_ent.maxs_x + trace_ent.maxs_y + 1), normalize(self.velocity));
			}
		}
	}

	// Missi: Can't do "remove(self)" in a touch function, at least in legacy QC (2026.9.13)
	self.touch = SUB_Null;
	self.nextthink = time;
	self.think = SUB_Remove;
};

void(entity bullet, float ammotype) determine_bullet_type =
{
	switch( ammotype )
	{
		case AMMO_9x18MM:
			bullet.bullet_drag = 1.03125;
			bullet.bullet_weight = 1.3;
			bullet.bullet_penetration_mult = 0.9;
			break;

		case AMMO_9x19MM:
			bullet.bullet_drag = 1.15;
			bullet.bullet_weight = 1.2;
			bullet.bullet_penetration_mult = 1.1;
			break;

		case AMMO_357_MAGNUM:
			bullet.bullet_drag = 1.03125;
			bullet.bullet_weight = 1.1;
			bullet.bullet_penetration_mult = 1.3;
			break;

		case AMMO_44_MAGNUM:
			bullet.bullet_drag = 1.44;
			bullet.bullet_weight = 1.15;
			bullet.bullet_penetration_mult = 1.38;
			break;

		case AMMO_45_ACP:
			bullet.bullet_drag = 1.5;
			bullet.bullet_weight = 1.05;
			bullet.bullet_penetration_mult = 1.4;
			break;

		case AMMO_45_70_GOVT:
			bullet.bullet_drag = 1.4;
			bullet.bullet_weight = 0.9;
			bullet.bullet_penetration_mult = 1.6;
			break;

		case AMMO_50_90_SHARPS:
			bullet.bullet_drag = 1.28;
			bullet.bullet_weight = 0.95;
			bullet.bullet_penetration_mult = 1.65;
			break;

		case AMMO_9x39MM:
			bullet.bullet_drag = 1.8;
			bullet.bullet_weight = 0.7;
			bullet.bullet_penetration_mult = 1.3;
			break;

		case AMMO_5_45x39MM:
			bullet.bullet_drag = 1.0;
			bullet.bullet_weight = 1.0;
			bullet.bullet_penetration_mult = 1.6;
			break;

		case AMMO_5_56x45MM:
			bullet.bullet_drag = 1.0;
			bullet.bullet_weight = 1.0;
			bullet.bullet_penetration_mult = 1.4;
			break;

		case AMMO_7_62x39MM:
			bullet.bullet_drag = 1.0;
			bullet.bullet_weight = 1.0;
			bullet.bullet_penetration_mult = 1.5;
			break;

		case AMMO_7_62x51MM:
			bullet.bullet_drag = 1.0;
			bullet.bullet_weight = 1.0;
			bullet.bullet_penetration_mult = 1.5;
			break;

		case AMMO_12_7x99MM:
			bullet.bullet_drag = 0.2;
			bullet.bullet_weight = 1.0;
			bullet.bullet_penetration_mult = 2.5; // beeg
			break;

		case AMMO_12_7x108MM:
			bullet.bullet_drag = 0.2;
			bullet.bullet_weight = 1.0;
			bullet.bullet_penetration_mult = 2.5; // beeg
			break;

		case AMMO_12_GAUGE:
			bullet.bullet_drag = 1.1;
			bullet.bullet_weight = 1.2;
			bullet.bullet_penetration_mult = 1.9;
			break;

		case AMMO_10_GAUGE:
			bullet.bullet_drag = 1.2;
			bullet.bullet_weight = 1.2;
			bullet.bullet_penetration_mult = 2.2;
			break;

		case AMMO_6_GAUGE:
			bullet.bullet_drag = 1.1;
			bullet.bullet_weight = 1.2;
			bullet.bullet_penetration_mult = 2.4;
			break;

		case AMMO_12_GAUGE_SLUG:
			bullet.bullet_drag = 1.0;
			bullet.bullet_weight = 1.0;
			bullet.bullet_penetration_mult = 1.8;
			break;

		case AMMO_10_GAUGE_SLUG:
			bullet.bullet_drag = 1.0;
			bullet.bullet_weight = 1.0;
			bullet.bullet_penetration_mult = 2.1;
			break;

		case AMMO_6_GAUGE_SLUG:
			bullet.bullet_drag = 1.0;
			bullet.bullet_weight = 1.0;
			bullet.bullet_penetration_mult = 2.3;
			break;

		case AMMO_12_GAUGE_FIRE:
			bullet.bullet_drag = 1.2;
			bullet.bullet_weight = 1.1;
			bullet.bullet_penetration_mult = 0.0;
			break;

		case AMMO_10_GAUGE_FIRE:
			bullet.bullet_drag = 1.0;
			bullet.bullet_weight = 1.0;
			bullet.bullet_penetration_mult = 0.0;
			break;

		case AMMO_6_GAUGE_FIRE:
			bullet.bullet_drag = 1.0;
			bullet.bullet_weight = 1.0;
			bullet.bullet_penetration_mult = 0.0;
			break;

		default:
			bullet.bullet_drag = 1.0;
			bullet.bullet_weight = 1.0;
			bullet.bullet_penetration_mult = 1.0;
			dprint("TEMPORAL CORTEX: Attempted to set bullet drag and weight on a non-existent ammo type!\n");
			break;
	}
};

/*
================
FireBullets_NoHitScan

Temporal Cortex: Used by any entity that is capable of firing a weapon.
================
*/

void(float damage, float ammotype, float speed, float shotcount, vector dir, vector spread) FireBullets_NoHitScan =
{
	local vector direction;
	local vector src;

	makevectors(self.v_angle);

	src = self.origin + v_forward*10;

	src_z = self.absmin_z + self.size_z * 0.7;

	ClearMultiDamage ();

	while (shotcount > 0)
	{
		direction = dir + crandom()*spread_x*v_right + crandom()*spread_y*v_up;

		//traceline (src, src + direction*2048, FALSE, self);
		//if (trace_fraction != 1.0)
			//TraceAttack (4, direction);

		shoot_bullet( damage, ammotype, speed, src, direction );

		shotcount = shotcount - 1;
	}
};

#endif

/*
================
W_FireShotgun
================
*/
void() W_FireShotgun =
{
	local vector dir;

	sound (self, CHAN_WEAPON, "weapons/guncock.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	self.currentammo = self.ammo_shells = self.ammo_shells - 1;
	dir = aim (self, 100000);

#ifdef TEMPORALCORTEX
	if (self.items2 & IT2_INCENDIARY_AMMO)
	{
		self.incendiary_ammo_count = self.incendiary_ammo_count - 1;

		if (self.incendiary_ammo_count <= 0)
		{
			self.items2 &= ~IT2_INCENDIARY_AMMO;
		}
		else if (self.incendiary_ammo_count < 10)
		{
			stuffcmd (self, "bf\n");
			sound (self, CHAN_AUTO, "items/incendiary2.wav", 1, ATTN_NORM);
			sprint (self, "Incendiary ammo is running out\n");
			sprint (self, "Incendiary ammo left: ");
			sprint (self, ftos(self.incendiary_ammo_count));
			sprint (self, "\n");
		}
	}

	if ( cvar( "tc_sv_hitscan" ) == 0 )
		FireBullets_NoHitScan (cvar("tc_sv_shotgun_damage"), AMMO_12_GAUGE, cvar("tc_sv_ammo_12gauge_speed"), 6, dir, '0.04 0.04 0');
	else
		FireBullets (cvar("tc_sv_shotgun_damage"), dir, '0.04 0.04 0');
#else
	FireBullets (6, dir, '0.04 0.04 0');
#endif
};


/*
================
W_FireSuperShotgun
================
*/
void() W_FireSuperShotgun =
{
	local vector dir;

	if (self.currentammo == 1)
	{
		W_FireShotgun ();
		return;
	}

	sound (self ,CHAN_WEAPON, "weapons/shotgn2.wav", 1, ATTN_NORM);

	self.punchangle_x = -4;

	self.currentammo = self.ammo_shells = self.ammo_shells - 2;
	dir = aim (self, 100000);

#ifdef TEMPORALCORTEX
	if (self.items2 & IT2_INCENDIARY_AMMO)
	{
		self.incendiary_ammo_count = self.incendiary_ammo_count - 2;

		if (self.incendiary_ammo_count <= 0)
		{
			self.items2 &= ~IT2_INCENDIARY_AMMO;
		}
		else if (self.incendiary_ammo_count < 10)
		{
			stuffcmd (self, "bf\n");
			sound (self, CHAN_AUTO, "items/incendiary2.wav", 1, ATTN_NORM);
			sprint (self, "Incendiary ammo is running out\n");
			sprint (self, "Incendiary ammo left: ");
			sprint (self, ftos(self.incendiary_ammo_count));
			sprint (self, "\n");
		}
	}

	if ( cvar( "tc_sv_hitscan" ) == 0 )
		FireBullets_NoHitScan (cvar("tc_sv_super_shotgun_damage"), AMMO_6_GAUGE, cvar("tc_sv_ammo_6gauge_speed"), 14, dir, '0.14 0.08 0');
	else
		FireBullets (cvar("tc_sv_super_shotgun_damage"), dir, '0.14 0.08 0');
#else
	FireBullets (14, dir, '0.14 0.08 0');
#endif
};


/*
==============================================================================

ROCKETS

==============================================================================
*/

.vector source;
.float starttime;

float(entity toplayer, float fl) SendNail =
{
	vector v;
	v = self.source + self.velocity*(time-self.starttime);
	WriteByte(MSG_ENTITY, CLASS_NAIL);
	WriteCoord(MSG_ENTITY, v_x);
	WriteCoord(MSG_ENTITY, v_y);
	WriteCoord(MSG_ENTITY, v_z);
#ifdef TEMPORALCORTEX
	WriteLong(MSG_ENTITY, self.modelindex);	//note: some engines support >256 modelindexes. so long as it's precached in worldspawn, it'll not be an issue.
#else
	WriteByte(MSG_ENTITY, self.modelindex);	//note: some engines support >256 modelindexes. so long as it's precached in worldspawn, it'll not be an issue.
#endif
	WriteShort(MSG_ENTITY, vlen(self.velocity));
	WriteShort(MSG_ENTITY, self.angles_x*256/360);	//we might get better precision if we were to writecoord some point ahead that it should pass through, but this is smaller and accurate enough.
	WriteShort(MSG_ENTITY, self.angles_y*256/360);

	return TRUE;
};

float(entity toplayer, float fl) SendRocket =
{
	vector v;
	v = self.source + self.velocity*(time-self.starttime);
	WriteByte(MSG_ENTITY, CLASS_ROCKET);
	WriteCoord(MSG_ENTITY, v_x);
	WriteCoord(MSG_ENTITY, v_y);
	WriteCoord(MSG_ENTITY, v_z);
	WriteShort(MSG_ENTITY, self.angles_x*256/360);	//we might get better precision if we were to writecoord some point ahead that it should pass through, but this is smaller and accurate enough.
	WriteShort(MSG_ENTITY, self.angles_y*256/360);

	return TRUE;
};

#ifdef TEMPORALCORTEX
float(entity toplayer, float fl) SendBullet =
{
	vector v;
	entity o;

	v = self.source + self.velocity*(time-self.starttime);
	o = self.owner;
	WriteByte(MSG_ENTITY, CLASS_BULLET);
	WriteLong(MSG_ENTITY, fl);

	WriteCoord (MSG_ENTITY, v_x);
	WriteCoord (MSG_ENTITY, v_y);
	WriteCoord (MSG_ENTITY, v_z);

	WriteShort (MSG_ENTITY, self.angles_x*(256/360));
	WriteShort (MSG_ENTITY, self.angles_y*(256/360));

	WriteCoord (MSG_ENTITY, self.velocity_x);
	WriteCoord (MSG_ENTITY, self.velocity_y);
	WriteCoord (MSG_ENTITY, self.velocity_z);

	WriteCoord (MSG_ENTITY, self.avelocity_x);
	WriteCoord (MSG_ENTITY, self.avelocity_y);
	WriteCoord (MSG_ENTITY, self.avelocity_z);

	WriteLong (MSG_ENTITY, self.modelindex);

	WriteCoord (MSG_ENTITY, self.mins_x);
	WriteCoord (MSG_ENTITY, self.mins_y);
	WriteCoord (MSG_ENTITY, self.mins_z);

	WriteCoord (MSG_ENTITY, self.maxs_x);
	WriteCoord (MSG_ENTITY, self.maxs_y);
	WriteCoord (MSG_ENTITY, self.maxs_z);

	WriteEntity(MSG_ENTITY, o);

	// WriteString(MSG_ENTITY, "tr_rocket");

	return TRUE;
};
#endif

float(entity toplayer, float fl) SendGrenade =
{
	vector v;
	entity o;

	v = self.source + self.velocity*(time-self.starttime);
	o = self.owner;
	WriteByte(MSG_ENTITY, CLASS_GRENADE);
	WriteLong(MSG_ENTITY, fl);

	if (fl & SENDFLAG_ORIGIN)
	{
		WriteCoord (MSG_ENTITY, self.origin_x);
		WriteCoord (MSG_ENTITY, self.origin_y);
		WriteCoord (MSG_ENTITY, self.origin_z);
	}
	if (fl & SENDFLAG_ANGLES)
	{
		WriteCoord (MSG_ENTITY, self.angles_x);	//we might get better precision if we were to writecoord some point ahead that it should pass through, but this is smaller and accurate enough.
		WriteCoord (MSG_ENTITY, self.angles_y);
		WriteCoord (MSG_ENTITY, self.angles_z);
	}
	if (fl & SENDFLAG_VELOCITY)
	{
		WriteCoord (MSG_ENTITY, self.velocity_x);
		WriteCoord (MSG_ENTITY, self.velocity_y);
		WriteCoord (MSG_ENTITY, self.velocity_z);
	}
	if (fl & SENDFLAG_AVELOCITY)
	{
		WriteCoord (MSG_ENTITY, self.avelocity_x);
		WriteCoord (MSG_ENTITY, self.avelocity_y);
		WriteCoord (MSG_ENTITY, self.avelocity_z);
	}

	if (fl & SENDFLAG_MODEL)
		WriteString (MSG_ENTITY, self.model);
	if (fl & SENDFLAG_MODELINDEX)
		WriteLong (MSG_ENTITY, self.modelindex);

	if (fl & SENDFLAG_MINS)
	{
		WriteCoord (MSG_ENTITY, self.mins_x);
		WriteCoord (MSG_ENTITY, self.mins_y);
		WriteCoord (MSG_ENTITY, self.mins_z);
	}
	if (fl & SENDFLAG_MAXS)
	{
		WriteCoord (MSG_ENTITY, self.maxs_x);
		WriteCoord (MSG_ENTITY, self.maxs_y);
		WriteCoord (MSG_ENTITY, self.maxs_z);
	}

	WriteEntity(MSG_ENTITY, o);

	return TRUE;
};

#ifdef TEMPORALCORTEX
float(entity toplayer, float fl) SendGrapplingHook =
{
	WriteByte(MSG_ENTITY, CLASS_GRAPPLING_HOOK);
	WriteLong(MSG_ENTITY, fl);

	WriteCoord(MSG_ENTITY, self.origin_x);
	WriteCoord(MSG_ENTITY, self.origin_y);
	WriteCoord(MSG_ENTITY, self.origin_z);

	WriteShort(MSG_ENTITY, self.angles_x*(256/360));
	WriteShort(MSG_ENTITY, self.angles_y*(256/360));
	WriteShort(MSG_ENTITY, self.angles_z*(256/360));
	//WriteShort(MSG_ENTITY, self.angles_x*65535/360);	//we might get better precision if we were to writecoord some point ahead that it should pass through, but this is smaller and accurate enough.
	//WriteShort(MSG_ENTITY, self.angles_y*65535/360);

	WriteCoord(MSG_ENTITY, self.velocity_x);
	WriteCoord(MSG_ENTITY, self.velocity_y);
	WriteCoord(MSG_ENTITY, self.velocity_z);

	WriteEntity(MSG_ENTITY, self.owner);

	return TRUE;
};
#endif

float(entity toplayer, float fl) SendExplosion =
{
	vector v;
	v = self.origin;
	WriteByte(MSG_ENTITY, CLASS_EXPLOSION);
	WriteCoord(MSG_ENTITY, v_x);
	WriteCoord(MSG_ENTITY, v_y);
	WriteCoord(MSG_ENTITY, v_z);

	return TRUE;
};

#ifdef TEMPORALCORTEX
void(float damage, float ammotype, float speed, vector org, vector dir) shoot_bullet =
{
	local entity newbullet;

	newbullet = spawn ();
	newbullet.owner = self;
	newbullet.movetype = MOVETYPE_TOSS;
	newbullet.solid = SOLID_BBOX;
	//newbullet.effects = EF_TC_BULLET;

	newbullet.angles = vectoangles(dir);
	newbullet.bullet_type = ammotype;

	determine_bullet_type( newbullet, ammotype );
	newbullet.bullet_damage = damage;

	newbullet.touch = bullet_touch;
	newbullet.classname = "bullet";
	newbullet.think = bullet_think;
	newbullet.nextthink = time;

	//newbullet.noise = "ambience/windfly.wav";

	setmodel (newbullet, "progs/laser.mdl");
	setsize (newbullet, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (newbullet, org);

	newbullet.velocity = dir * speed;

	//sound (newbullet, CHAN_VOICE, newbullet.noise, 0.35, ATTN_NORM, 800, SOUNDFLAG_FOLLOW);

	newbullet.source = newbullet.origin;
	newbullet.starttime = time;
	//newbullet.SendEntity = SendBullet;
	//newbullet.SendFlags = FULLSEND;

	makevectors(self.angles);
};
#endif

/*this is for shits and giggles*/
void() makevolcano =
{
	if (checkbuiltin(terrain_edit) && autocvar(test_volcano, 0, "Rocket explosions create a volcano shape on terrain models."))
	{
		terrain_edit(4, self.origin, 512, 64/3);
		terrain_edit(5, self.origin, 256, 32/3);
	}
};
void()	s_explode1	= {self.think = s_explode1; makevolcano(); self.frame += 0.5; self.nextthink = time + 0.05; if (self.frame >= 6) {remove(self); return;}};

void() BecomeExplosion =
{
	__using dimension_seen, dimension_send;	//okay for this purpose...

	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	self.solid = SOLID_NOT;

	self.dimension_seen = DIMENSION_NOCSQC;
	dimension_send = DIMENSION_NOCSQC;

	if (checkbuiltin(te_explosion))
		te_explosion(self.origin);
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_EXPLOSION);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.dimension_seen = DIMENSION_DEFAULT;
	dimension_send = DIMENSION_DEFAULT;

	setmodel (self, "progs/s_explod.spr");
	s_explode1 ();

//set up the fields required for transmitting the event.
	self.source = self.origin;
	self.SendEntity = SendExplosion;
	self.starttime = time;
	self.SendFlags = FULLSEND;
};

void() T_MissileTouch =
{
	local float	damg;

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	damg = 100 + random()*20;

	if (other.health)
	{
		if (other.classname == "monster_shambler")
			damg = damg * 0.5;	// mostly immune
		T_Damage (other, self, self.owner, damg );
	}

	// don't do radius damage to the other, because all the damage
	// was done in the impact
	T_RadiusDamage (self, self.owner, 120, other);

//	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);

	SpawnExplosion (self.origin);
	remove(self);
};

#ifdef TEMPORALCORTEX
void() T_MissileTouch_FFCheck =
{
	local float	damg;

	if (other == self.owner)
		return;		// don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	makevectors(self.angles);

	if ( cvar("tc_sv_friendlyfire_monster") == 0 )
	{
		if ( other.relationship_group & self.owner.relationship_group_like )
		{
			setorigin (self, self.origin + v_forward * (other.size_x + 1));
			self.velocity += v_forward * 1000;
			return;
		}
	}

	if ( cvar("tc_sv_friendlyfire_pvp") == 0 && !deathmatch )
	{
		if ( other.relationship_group & self.owner.relationship_group_like )
		{
			setorigin (self, self.origin + v_forward * (other.size_x + 1));
			self.velocity += v_forward * 1000;
			return;
		}
	}

	damg = 100 + random()*20;

	if (other.health)
	{
		if (other.classname == "monster_shambler")
			damg = damg * 0.5;	// mostly immune
		T_Damage (other, self, self.owner, damg );
	}

	// don't do radius damage to the other, because all the damage
	// was done in the impact
	T_RadiusDamage (self, self.owner, 120, other);

//	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	SpawnExplosion (self.origin);

	self.velocity = self.velocity * 1000;
	remove(self);
};
#endif

/*
================
W_FireRocket
================
*/
void() W_FireRocket =
{
	local	entity missile;

	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;

	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "missile";

// set missile speed

	makevectors (self.v_angle);
	missile.velocity = aim(self, 1000);
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);

	missile.touch = T_MissileTouch;

// set missile duration
	missile.nextthink = time + 5;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/missile.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, self.origin + v_forward*8 + '0 0 16');

	missile.source = missile.origin;
	missile.SendEntity = SendRocket;
	missile.starttime = time;
	missile.SendFlags = FULLSEND;
};

/*
===============================================================================

LIGHTNING

===============================================================================
*/

/*
=================
LightningDamage
=================
*/
void(vector p1, vector p2, entity from, float damage) LightningDamage =
{
	local entity		e1, e2;
	local vector		f;

	f = p2 - p1;
	normalize (f);
	f_x = 0 - f_y;
	f_y = f_x;
	f_z = 0;
	f = f*16;

	e1 = e2 = world;

	traceline (p1, p2, FALSE, self);
	if (trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
		if (self.classname == "player")
		{
			if (other.classname == "player")
				trace_ent.velocity_z = trace_ent.velocity_z + 400;
		}
	}
	e1 = trace_ent;

	traceline (p1 + f, p2 + f, FALSE, self);
	if (trace_ent != e1 && trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
	}
	e2 = trace_ent;

	traceline (p1 - f, p2 - f, FALSE, self);
	if (trace_ent != e1 && trace_ent != e2 && trace_ent.takedamage)
	{
		particle (trace_endpos, '0 0 100', 225, damage*4);
		T_Damage (trace_ent, from, from, damage);
	}
};


void() W_FireLightning =
{
	local	vector		org;
	local	float		cells;

	if (self.ammo_cells < 1)
	{
#ifdef TEMPORALCORTEX
		self.tc_currentweapon = W_BestWeapon ();
#else
		self.weapon = W_BestWeapon ();
#endif
		W_SetCurrentAmmo ();
		return;
	}

// explode if under water
	if (self.waterlevel > 1)
	{
		cells = self.ammo_cells;
		self.ammo_cells = 0;
		W_SetCurrentAmmo ();
		T_RadiusDamage (self, self, 35*cells, world);
		return;
	}

	if (self.t_width < time)
	{
		sound (self, CHAN_WEAPON, "weapons/lhit.wav", 1, ATTN_NORM);
		self.t_width = time + 0.6;
	}
	self.punchangle_x = -2;

	self.currentammo = self.ammo_cells = self.ammo_cells - 1;

	org = self.origin + '0 0 16';

	traceline (org, org + v_forward*600, TRUE, self);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity (MSG_BROADCAST, self);
	WriteCoord (MSG_BROADCAST, org_x);
	WriteCoord (MSG_BROADCAST, org_y);
	WriteCoord (MSG_BROADCAST, org_z);
	WriteCoord (MSG_BROADCAST, trace_endpos_x);
	WriteCoord (MSG_BROADCAST, trace_endpos_y);
	WriteCoord (MSG_BROADCAST, trace_endpos_z);

	LightningDamage (self.origin, trace_endpos + v_forward*4, self, 30);
};


//=============================================================================


void() GrenadeExplode =
{
	T_RadiusDamage (self, self.owner, 120, world);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
};

void() GrenadeTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner
	if (other.takedamage == DAMAGE_AIM)
	{
		GrenadeExplode();
		return;
	}
	sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);	// bounce sound
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};

void() GrenadeThink =
{
	if ( self.wait < time )
	{
		self.think = GrenadeExplode;
		self.nextthink = time;
	}
	else
	{
		//self.SendFlags |= SENDFLAG_ORIGIN | SENDFLAG_ANGLES | SENDFLAG_VELOCITY | SENDFLAG_AVELOCITY;
		self.think = GrenadeThink;
		self.nextthink = time + 0.25;
	}
};

/*
================
W_FireGrenade
================
*/
void() W_FireGrenade =
{
	local	entity missile;

	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;

	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";

// set missile speed

	makevectors (self.v_angle);

	if (self.v_angle_x)
		missile.velocity = v_forward*600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
	else
	{
		missile.velocity = aim(self, 10000);
		missile.velocity = missile.velocity * 600;
		missile.velocity_z = 200;
	}

	missile.avelocity = '300 300 300';

	missile.angles = vectoangles(missile.velocity);

	missile.touch = GrenadeTouch;

// set missile duration
	missile.wait = time + 2.5;
	missile.nextthink = time;
	missile.think = GrenadeThink;

	setmodel (missile, "progs/grenade.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, self.origin);

	//missile.SendEntity = SendGrenade;
};


//=============================================================================

void() spike_touch;
void() superspike_touch;


/*
===============
launch_spike

Used for both the player and the ogre
===============
*/
void(vector org, vector dir) launch_spike =
{
	newmis = spawn ();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;

	newmis.angles = vectoangles(dir);

	newmis.touch = spike_touch;
	newmis.classname = "spike";
	newmis.think = SUB_Remove;
	newmis.nextthink = time + 6;
	setmodel (newmis, "progs/spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (newmis, org);

	newmis.velocity = dir * 1000;

	newmis.SendEntity = SendNail;
	newmis.SendFlags = FULLSEND;
	newmis.source = newmis.origin;
	newmis.starttime = time;
};

void() W_FireSuperSpikes =
{
	local vector	dir;

	sound (self, CHAN_WEAPON, "weapons/spike2.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - 2;
	dir = aim (self, 1000);
	launch_spike (self.origin + '0 0 16', dir);
	newmis.touch = superspike_touch;
	setmodel (newmis, "progs/s_spike.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	self.punchangle_x = -2;
};

void(float ox) W_FireSpikes =
{
	local vector	dir;

	makevectors (self.v_angle);

#ifdef TEMPORALCORTEX
	if (self.ammo_nails >= 2 && self.tc_currentweapon.classname == "weapon_supernailgun")
#else
	if (self.ammo_nails >= 2 && self.weapon == IT_SUPER_NAILGUN)
#endif
	{
		W_FireSuperSpikes ();
		return;
	}

	if (self.ammo_nails < 1)
	{
#ifdef TEMPORALCORTEX
		self.tc_currentweapon = W_BestWeapon ();
#else
		self.weapon = W_BestWeapon ();
#endif
		W_SetCurrentAmmo ();
		return;
	}

	sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
	self.attack_finished = time + 0.2;
	self.currentammo = self.ammo_nails = self.ammo_nails - 1;
	dir = aim (self, 1000);
	launch_spike (self.origin + '0 0 16' + v_right*ox, dir);

	self.punchangle_x = -2;
};



void() spike_touch =
{
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (9);
		T_Damage (other, self, self.owner, 9);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);

		if (self.classname == "wizspike")
			WriteByte (MSG_BROADCAST, TE_WIZSPIKE);
		else if (self.classname == "knightspike")
			WriteByte (MSG_BROADCAST, TE_KNIGHTSPIKE);
		else
			WriteByte (MSG_BROADCAST, TE_SPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	remove(self);

};

void() superspike_touch =
{
	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (18);
		T_Damage (other, self, self.owner, 18);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_SUPERSPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

	remove(self);

};


/*
===============================================================================

PLAYER WEAPON USE

===============================================================================
*/

void() W_SetCurrentAmmo =
{
	player_run ();		// get out of any weapon firing states

#ifdef TEMPORALCORTEX
	self.items = self.items - ( self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS) );

	if (self.tc_currentweapon.classname == stringpool_get_string( "weapon_axe"))
	{
		self.currentammo = 0;
		self.weaponmodel = "progs/v_axe.mdl";
		self.weaponframe = 0;
	}
	else if (self.tc_currentweapon.classname == stringpool_get_string( "weapon_shotgun"))
	{
		self.currentammo = self.ammo_shells;
		self.weaponmodel = "progs/v_shot.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
	}
	else if (self.tc_currentweapon.classname == stringpool_get_string( "weapon_supershotgun"))
	{
		self.currentammo = self.ammo_shells;
		self.weaponmodel = "progs/v_shot2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
	}
	else if (self.tc_currentweapon.classname == stringpool_get_string( "weapon_nailgun"))
	{
		self.currentammo = self.ammo_nails;
		self.weaponmodel = "progs/v_nail.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
	}
	else if (self.tc_currentweapon.classname == stringpool_get_string( "weapon_supernailgun"))
	{
		self.currentammo = self.ammo_nails;
		self.weaponmodel = "progs/v_nail2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
	}
	else if (self.tc_currentweapon.classname == stringpool_get_string( "weapon_grenadelauncher"))
	{
		self.currentammo = self.ammo_rockets;
		self.weaponmodel = "progs/v_rock.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.tc_currentweapon.classname == stringpool_get_string( "weapon_rocketlauncher"))
	{
		self.currentammo = self.ammo_rockets;
		self.weaponmodel = "progs/v_rock2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.tc_currentweapon.classname == stringpool_get_string( "weapon_lightning"))
	{
		self.currentammo = self.ammo_cells;
		self.weaponmodel = "progs/v_light.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_CELLS;
	}
	else
	{
		self.currentammo = 0;
		self.weaponmodel = "";
		self.weaponframe = 0;
	}
#else
	self.items = self.items - ( self.items & (IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS) );

	if (self.weapon == IT_AXE)
	{
		self.currentammo = 0;
		self.weaponmodel = "progs/v_axe.mdl";
		self.weaponframe = 0;
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		self.weaponmodel = "progs/v_shot.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		self.currentammo = self.ammo_shells;
		self.weaponmodel = "progs/v_shot2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_SHELLS;
	}
	else if (self.weapon == IT_NAILGUN)
	{
		self.currentammo = self.ammo_nails;
		self.weaponmodel = "progs/v_nail.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		self.currentammo = self.ammo_nails;
		self.weaponmodel = "progs/v_nail2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_NAILS;
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		self.weaponmodel = "progs/v_rock.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		self.currentammo = self.ammo_rockets;
		self.weaponmodel = "progs/v_rock2.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_ROCKETS;
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		self.currentammo = self.ammo_cells;
		self.weaponmodel = "progs/v_light.mdl";
		self.weaponframe = 0;
		self.items = self.items | IT_CELLS;
	}
	else
	{
		self.currentammo = 0;
		self.weaponmodel = "";
		self.weaponframe = 0;
	}
#endif
};

#ifdef TEMPORALCORTEX
entity(entity player, string w) W_AddWeaponToPlayer =
{
	local entity pw;
	local float i;

	for (i = 0; i < 32; i++)
	{
		pw = player.tc_weapons[i];
		if (pw)
		{
			if (pw.classname == w)
				return pw;		// Missi: already have it (2026.10.26)
		}
		else
		{
			break;
		}
	}

	pw = spawn();
	pw.classname = w;
	pw.owner = player;

	switch(w)
	{
		case "weapon_grenadelauncher":
			setmodel(pw, "progs/g_rock2.mdl");
			break;
	}

	setorigin(self, player.origin);

	dprint ("new player weapon at index ");
	dprint (ftos(i));
	dprint (": ");
	dprint (pw.classname);
	dprint ("\n");

	player.tc_weapons[i] = pw;

	return pw;
};

entity(vector org, string w) W_SpawnWeapon =
{
	local entity pw;
	local float i;

	pw = spawn();
	pw.classname = w;

	switch(w)
	{
		case "weapon_shotgun":
			precache_model("progs/g_shot.mdl");
			setmodel(pw, "progs/g_shot.mdl");
			break;
		case "weapon_supershotgun":
			precache_model("progs/g_shot.mdl");
			setmodel(pw, "progs/g_shot.mdl");
			break;
		case "weapon_grenadelauncher":
			precache_model("progs/g_rock1.mdl");
			setmodel(pw, "progs/g_rock1.mdl");
			break;
		case "weapon_rocketlauncher":
			precache_model("progs/g_rock2.mdl");
			setmodel(pw, "progs/g_rock2.mdl");
			break;
	}

	pw.touch = weapon_touch;
	setorigin(pw, org);
	setsize (pw, '-16 -16 0', '16 16 56');
	StartItemExplicit(pw);

	dprint ("new weapon spawn at ");
	dprint (vtos(org));
	dprint ("\n");

	return pw;
};

void(entity player) W_ClearWeaponsFromPlayer =
{
	local entity pw;
	local float i;

	for (i = 0; i < 32; i++)
	{
		pw = player.tc_weapons[i];

		dprint ("destroying weapon on player: ");
		dprint (pw.classname);
		dprint ("\n");

		remove(pw);
		player.tc_weapons[i] = world;
	}
};

entity(entity ent, string name) W_FindWeaponInInventory =
{
	local float i;
	local entity e;

	for (i = 0; i < 32; i++)
	{
		e = ent.tc_weapons[i];

		if (!e)
			continue;	// Missi: Empty slots are reclaimed (2026.10.27)

		if (e.classname == name)
			return e;
	}

	return world;
};

entity() W_BestWeapon =
{
	local entity it;
	local float i;

	for (i = 0; i < 32; i++)
	{
		it = self.tc_weapons[i];

		if (self.waterlevel <= 1 && self.ammo_cells >= 1 && it.classname == stringpool_get_string("weapon_lightning"))
			return it;
		if(self.ammo_nails >= 2 && it.classname == stringpool_get_string("weapon_supernailgun"))
			return it;
		if(self.ammo_shells >= 2 && it.classname == stringpool_get_string("weapon_supershotgun"))
			return it;
		if(self.ammo_nails >= 1 && it.classname == stringpool_get_string("weapon_nailgun"))
			return it;
		if(self.ammo_shells >= 1 && it.classname == stringpool_get_string("weapon_shotgun"))
			return it;
	}
	return world;
};
#else
float() W_BestWeapon =
{
	local	float	it;

	it = self.items;

	if (self.waterlevel <= 1 && self.ammo_cells >= 1 && (it & IT_LIGHTNING) )
		return IT_LIGHTNING;
	if(self.ammo_nails >= 2 && (it & IT_SUPER_NAILGUN) )
		return IT_SUPER_NAILGUN;
	if(self.ammo_shells >= 2 && (it & IT_SUPER_SHOTGUN) )
		return IT_SUPER_SHOTGUN;
	if(self.ammo_nails >= 1 && (it & IT_NAILGUN) )
		return IT_NAILGUN;
	if(self.ammo_shells >= 1 && (it & IT_SHOTGUN) )
		return IT_SHOTGUN;
	return IT_AXE;
};
#endif

float() W_CheckNoAmmo =
{
	if (self.currentammo > 0)
		return TRUE;

#ifdef TEMPORALCORTEX
	if (self.tc_currentweapon.classname == "weapon_axe")
#else
	if (self.weapon == IT_AXE)
#endif
		return TRUE;

#ifdef TEMPORALCORTEX
	self.tc_currentweapon = W_BestWeapon ();
#else
	self.weapon = W_BestWeapon ();
#endif

	W_SetCurrentAmmo ();

// drop the weapon down
	return FALSE;
};

/*
============
W_Attack

An attack impulse can be triggered now
============
*/
void()	player_axe1;
void()	player_axeb1;
void()	player_axec1;
void()	player_axed1;
void()	player_shot1;
void()	player_nail1;
void()	player_light1;
void()	player_rocket1;

#ifdef TEMPORALCORTEX
void() W_Attack =
{
	local	float	r;

	if (!W_CheckNoAmmo ())
		return;

	makevectors	(self.v_angle);			// calculate forward angle for velocity
	self.show_hostile = time + 1;	// wake monsters up

	if (self.tc_currentweapon.classname == stringpool_get_string( "weapon_axe"))
	{
		sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);
		r = random();
		if (r < 0.25)
			player_axe1 ();
		else if (r<0.5)
			player_axeb1 ();
		else if (r<0.75)
			player_axec1 ();
		else
			player_axed1 ();
		self.attack_finished = time + 0.5;
	}
	else if (self.tc_currentweapon.classname == stringpool_get_string( "weapon_shotgun"))
	{
		player_shot1 ();
		W_FireShotgun ();
		self.attack_finished = time + 0.5;
	}
	else if (self.tc_currentweapon.classname == stringpool_get_string( "weapon_supershotgun"))
	{
		player_shot1 ();
		W_FireSuperShotgun ();
		self.attack_finished = time + 0.7;
	}
	else if (self.tc_currentweapon.classname == stringpool_get_string( "weapon_nailgun"))
	{
		player_nail1 ();
	}
	else if (self.tc_currentweapon.classname == stringpool_get_string( "weapon_supernailgun"))
	{
		player_nail1 ();
	}
	else if (self.tc_currentweapon.classname == stringpool_get_string( "weapon_grenadelauncher"))
	{
		player_rocket1();
		W_FireGrenade();
		self.attack_finished = time + 0.6;
	}
	else if (self.tc_currentweapon.classname == stringpool_get_string( "weapon_rocketlauncher"))
	{
		player_rocket1();
		W_FireRocket();
		self.attack_finished = time + 0.8;
	}
	else if (self.tc_currentweapon.classname == stringpool_get_string( "weapon_lightning"))
	{
		player_light1();
		self.attack_finished = time + 0.1;
		sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
	}
};
#else
void() W_Attack =
{
	local	float	r;

	if (!W_CheckNoAmmo ())
		return;

	makevectors	(self.v_angle);			// calculate forward angle for velocity
	self.show_hostile = time + 1;	// wake monsters up

	if (self.weapon == IT_AXE)
	{
		sound (self, CHAN_WEAPON, "weapons/ax1.wav", 1, ATTN_NORM);
		r = random();
		if (r < 0.25)
			player_axe1 ();
		else if (r<0.5)
			player_axeb1 ();
		else if (r<0.75)
			player_axec1 ();
		else
			player_axed1 ();
		self.attack_finished = time + 0.5;
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		player_shot1 ();
		W_FireShotgun ();
		self.attack_finished = time + 0.5;
	}
	else if (self.weapon == IT_SUPER_SHOTGUN)
	{
		player_shot1 ();
		W_FireSuperShotgun ();
		self.attack_finished = time + 0.7;
	}
	else if (self.weapon == IT_NAILGUN)
	{
		player_nail1 ();
	}
	else if (self.weapon == IT_SUPER_NAILGUN)
	{
		player_nail1 ();
	}
	else if (self.weapon == IT_GRENADE_LAUNCHER)
	{
		player_rocket1();
		W_FireGrenade();
		self.attack_finished = time + 0.6;
	}
	else if (self.weapon == IT_ROCKET_LAUNCHER)
	{
		player_rocket1();
		W_FireRocket();
		self.attack_finished = time + 0.8;
	}
	else if (self.weapon == IT_LIGHTNING)
	{
		player_light1();
		self.attack_finished = time + 0.1;
		sound (self, CHAN_AUTO, "weapons/lstart.wav", 1, ATTN_NORM);
	}
};
#endif

/*
============
W_ChangeWeapon

============
*/
void() W_ChangeWeapon =
{
#ifdef TEMPORALCORTEX
	local	entity	it, st;
	local	float	am;

	it = self.tc_currentweapon;
	am = 0;

	if (self.impulse == 1)
	{
		st = W_FindWeaponInInventory(self, stringpool_get_string( "weapon_axe"));
	}
	else if (self.impulse == 2)
	{
		st = W_FindWeaponInInventory(self, stringpool_get_string( "weapon_shotgun"));
		if (self.ammo_shells < 1)
			am = 1;
	}
	else if (self.impulse == 3)
	{
		st = W_FindWeaponInInventory(self, stringpool_get_string( "weapon_supershotgun"));
		if (self.ammo_shells < 2)
			am = 1;
	}
	else if (self.impulse == 4)
	{
		st = W_FindWeaponInInventory(self, stringpool_get_string( "weapon_nailgun"));
		if (self.ammo_nails < 1)
			am = 1;
	}
	else if (self.impulse == 5)
	{
		st = W_FindWeaponInInventory(self, stringpool_get_string( "weapon_supernailgun"));
		if (self.ammo_nails < 2)
			am = 1;
	}
	else if (self.impulse == 6)
	{
		st = W_FindWeaponInInventory(self, stringpool_get_string( "weapon_grenadelauncher"));
		if (self.ammo_rockets < 1)
			am = 1;
	}
	else if (self.impulse == 7)
	{
		st = W_FindWeaponInInventory(self, stringpool_get_string( "weapon_rocketlauncher"));
		if (self.ammo_rockets < 1)
			am = 1;
	}
	else if (self.impulse == 8)
	{
		st = W_FindWeaponInInventory(self, stringpool_get_string( "weapon_lightning"));
		if (self.ammo_cells < 1)
			am = 1;
	}
	else
		st = 0;

	self.impulse = 0;

	if (!st)
	{	// don't have the weapon or the ammo
		sprint (self, "no weapon.\n");
		return;
	}

	if (am)
	{	// don't have the ammo
		sprint (self, "not enough ammo.\n");
		return;
	}

//
// set weapon, set ammo
//
	self.tc_currentweapon = st;
	W_SetCurrentAmmo ();
#else
	local	float	it, am, fl;

	it = self.items;
	am = 0;

	if (self.impulse == 1)
	{
		fl = IT_AXE;
	}
	else if (self.impulse == 2)
	{
		fl = IT_SHOTGUN;
		if (self.ammo_shells < 1)
			am = 1;
	}
	else if (self.impulse == 3)
	{
		fl = IT_SUPER_SHOTGUN;
		if (self.ammo_shells < 2)
			am = 1;
	}
	else if (self.impulse == 4)
	{
		fl = IT_NAILGUN;
		if (self.ammo_nails < 1)
			am = 1;
	}
	else if (self.impulse == 5)
	{
		fl = IT_SUPER_NAILGUN;
		if (self.ammo_nails < 2)
			am = 1;
	}
	else if (self.impulse == 6)
	{
		fl = IT_GRENADE_LAUNCHER;
		if (self.ammo_rockets < 1)
			am = 1;
	}
	else if (self.impulse == 7)
	{
		fl = IT_ROCKET_LAUNCHER;
		if (self.ammo_rockets < 1)
			am = 1;
	}
	else if (self.impulse == 8)
	{
		fl = IT_LIGHTNING;
		if (self.ammo_cells < 1)
			am = 1;
	}
	else
		fl = 0;

	self.impulse = 0;

	if (!(self.items & fl))
	{	// don't have the weapon or the ammo
		sprint (self, "no weapon.\n");
		return;
	}

	if (am)
	{	// don't have the ammo
		sprint (self, "not enough ammo.\n");
		return;
	}

	//
	// set weapon, set ammo
	//
	self.weapon = fl;
	W_SetCurrentAmmo ();
#endif
};

/*
============
CheatCommand
============
*/
void() CheatCommand =
{
	if (deathmatch || coop)
		return;

	self.ammo_rockets = 100;
	self.ammo_nails = 200;
	self.ammo_shells = 100;

#ifdef TEMPORALCORTEX
	W_AddWeaponToPlayer(self, stringpool_get_string("weapon_axe"));
	W_AddWeaponToPlayer(self, stringpool_get_string("weapon_shotgun"));
	W_AddWeaponToPlayer(self, stringpool_get_string("weapon_supershotgun"));
	W_AddWeaponToPlayer(self, stringpool_get_string("weapon_nailgun"));
	W_AddWeaponToPlayer(self, stringpool_get_string("weapon_supernailgun"));
	W_AddWeaponToPlayer(self, stringpool_get_string("weapon_grenadelauncher"));
	W_AddWeaponToPlayer(self, stringpool_get_string("weapon_rocketlauncher"));
	W_AddWeaponToPlayer(self, stringpool_get_string("weapon_lightning"));
#else
	self.items = self.items |
		IT_AXE |
		IT_SHOTGUN |
		IT_SUPER_SHOTGUN |
		IT_NAILGUN |
		IT_SUPER_NAILGUN |
		IT_GRENADE_LAUNCHER |
		IT_ROCKET_LAUNCHER |
		IT_KEY1 | IT_KEY2;

	self.ammo_cells = 200;
	self.items = self.items | IT_LIGHTNING;

	self.weapon = IT_ROCKET_LAUNCHER;
#endif
	self.impulse = 0;
	W_SetCurrentAmmo ();
};

void() GiveCommand_f =
{
	if (deathmatch || coop)
		return;

#ifdef TEMPORALCORTEX
	local entity new;
#endif

	switch(argv(1))
	{
#ifndef TEMPORALCORTEX
	case "1": self.items |= IT_AXE; break;		//not sure why you'd need this, but oh well.
	case "2": self.items |= IT_SHOTGUN; break;	//not sure why you'd need this, but oh well.
	case "3": self.items |= IT_SUPER_SHOTGUN; break;
	case "4": self.items |= IT_NAILGUN; break;
	case "5": self.items |= IT_SUPER_NAILGUN; break;
	case "6": self.items |= IT_GRENADE_LAUNCHER; break;
	case "7": self.items |= IT_ROCKET_LAUNCHER; break;
	case "8": self.items |= IT_LIGHTNING; break;
#endif
	case "s": self.ammo_shells = stof(argv(2)); break;
	case "n": self.ammo_nails = stof(argv(2)); break;
	case "r": self.ammo_rockets = stof(argv(2)); break;
	case "c": self.ammo_cells = stof(argv(2)); break;
	case "h": self.health = stof(argv(2)); break;
	case "a":
		self.armorvalue = stof(argv(2));
		if (self.armorvalue < 1)
		{	//remove the armour type if they no longer have any.
			self.armortype = 0;
			self.items &= ~(IT_ARMOR1|IT_ARMOR2|IT_ARMOR3);
		}
		else if (self.armorvalue > 150 && self.armortype < 0.8)
		{	//prmote to red if its too high for yellow...
			self.armortype = 0.8;
			self.items = (self.items & ~(IT_ARMOR1|IT_ARMOR2|IT_ARMOR3)) | IT_ARMOR3;
		}
		else if (self.armorvalue > 100 && self.armortype < 0.6)
		{	//promote to yellow if its too high for green...
			self.armortype = 0.6;
			self.items = (self.items & ~(IT_ARMOR1|IT_ARMOR2|IT_ARMOR3)) | IT_ARMOR2;
		}
		else if (self.armortype < 0.3)
		{	//make sure we have at least green armour...
			self.armortype = 0.3;
			self.items = (self.items & ~(IT_ARMOR1|IT_ARMOR2|IT_ARMOR3)) | IT_ARMOR1;
		}
		break;
#ifdef TEMPORALCORTEX
	case "weapon_lightning":
	{
		new = W_SpawnWeapon(self.origin, argv(1));

		if (self.ammo_cells < 200)
			self.ammo_cells += 10;

		break;
	}
	case "weapon_grenadelauncher":
	case "weapon_rocketlauncher":
	{
		new = W_SpawnWeapon(self.origin, argv(1));

		if (self.ammo_rockets < 100)
			self.ammo_rockets += 10;

		break;
	}
	case "weapon_nailgun":
	case "weapon_supernailgun":
	{
		new = W_SpawnWeapon(self.origin, argv(1));

		if (self.ammo_nails < 250)
			self.ammo_nails += 10;

		break;
	}
	case "weapon_shotgun":
	case "weapon_supershotgun":
	{
		new = W_SpawnWeapon(self.origin, argv(1));

		if (self.ammo_shells < 250)
			self.ammo_shells += 10;

		break;
	}
#endif
	default:
		sprint(self, "Item \"", argv(1), "\" not understood\n");
		break;
	}
	W_SetCurrentAmmo ();
};

/*
============
CycleWeaponCommand

Go to the next weapon with ammo
============
*/
void() CycleWeaponCommand =
{
	local	float	it, am;

	it = self.items;
	self.impulse = 0;

	while (1)
	{
		am = 0;

#ifdef TEMPORALCORTEX
		if (self.tc_currentweapon.classname == stringpool_get_string( "weapon_lightning"))
		{
			self.tc_currentweapon = W_FindWeaponInInventory(self, stringpool_get_string( "weapon_axe"));
		}
		else if (self.tc_currentweapon.classname == stringpool_get_string( "weapon_axe"))
		{
			self.tc_currentweapon = W_FindWeaponInInventory(self, stringpool_get_string( "weapon_shotgun"));
			if (self.ammo_shells < 1)
				am = 1;
		}
		else if (self.tc_currentweapon.classname == stringpool_get_string( "weapon_shotgun"))
		{
			self.tc_currentweapon = W_FindWeaponInInventory(self, stringpool_get_string( "weapon_supershotgun"));
			if (self.ammo_shells < 2)
				am = 1;
		}
		else if (self.tc_currentweapon.classname == stringpool_get_string( "weapon_supershotgun"))
		{
			self.tc_currentweapon = W_FindWeaponInInventory(self, stringpool_get_string( "weapon_nailgun"));
			if (self.ammo_nails < 1)
				am = 1;
		}
		else if (self.tc_currentweapon.classname == stringpool_get_string( "weapon_nailgun"))
		{
			self.tc_currentweapon = W_FindWeaponInInventory(self, stringpool_get_string( "weapon_supernailgun"));
			if (self.ammo_nails < 2)
				am = 1;
		}
		else if (self.tc_currentweapon.classname == stringpool_get_string( "weapon_supernailgun"))
		{
			self.tc_currentweapon = W_FindWeaponInInventory(self, stringpool_get_string( "weapon_grenadelauncher"));
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.tc_currentweapon.classname == stringpool_get_string( "weapon_grenadelauncher"))
		{
			self.tc_currentweapon = W_FindWeaponInInventory(self, stringpool_get_string( "weapon_rocketlauncher"));
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.tc_currentweapon.classname == stringpool_get_string( "weapon_rocketlauncher"))
		{
			self.tc_currentweapon = W_FindWeaponInInventory(self, stringpool_get_string( "weapon_lightning"));
			if (self.ammo_cells < 1)
				am = 1;
		}

		if ( (it & self.weapon) && am == 0)
		{
			W_SetCurrentAmmo ();
			return;
		}
#else
		if (self.weapon == IT_LIGHTNING)
		{
			self.weapon = IT_AXE;
		}
		else if (self.weapon == IT_AXE)
		{
			self.weapon = IT_SHOTGUN;
			if (self.ammo_shells < 1)
				am = 1;
		}
		else if (self.weapon == IT_SHOTGUN)
		{
			self.weapon = IT_SUPER_SHOTGUN;
			if (self.ammo_shells < 2)
				am = 1;
		}
		else if (self.weapon == IT_SUPER_SHOTGUN)
		{
			self.weapon = IT_NAILGUN;
			if (self.ammo_nails < 1)
				am = 1;
		}
		else if (self.weapon == IT_NAILGUN)
		{
			self.weapon = IT_SUPER_NAILGUN;
			if (self.ammo_nails < 2)
				am = 1;
		}
		else if (self.weapon == IT_SUPER_NAILGUN)
		{
			self.weapon = IT_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_GRENADE_LAUNCHER)
		{
			self.weapon = IT_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_ROCKET_LAUNCHER)
		{
			self.weapon = IT_LIGHTNING;
			if (self.ammo_cells < 1)
				am = 1;
		}

		if ( (it & self.weapon) && am == 0)
		{
			W_SetCurrentAmmo ();
			return;
		}
#endif
	}

};

/*
============
CycleWeaponReverseCommand

Go to the prev weapon with ammo
============
*/
void() CycleWeaponReverseCommand =
{
	local	float	it, am;

	it = self.items;
	self.impulse = 0;

	while (1)
	{
		am = 0;

		if (self.weapon == IT_LIGHTNING)
		{
			self.weapon = IT_ROCKET_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_ROCKET_LAUNCHER)
		{
			self.weapon = IT_GRENADE_LAUNCHER;
			if (self.ammo_rockets < 1)
				am = 1;
		}
		else if (self.weapon == IT_GRENADE_LAUNCHER)
		{
			self.weapon = IT_SUPER_NAILGUN;
			if (self.ammo_nails < 2)
				am = 1;
		}
		else if (self.weapon == IT_SUPER_NAILGUN)
		{
			self.weapon = IT_NAILGUN;
			if (self.ammo_nails < 1)
				am = 1;
		}
		else if (self.weapon == IT_NAILGUN)
		{
			self.weapon = IT_SUPER_SHOTGUN;
			if (self.ammo_shells < 2)
				am = 1;
		}
		else if (self.weapon == IT_SUPER_SHOTGUN)
		{
			self.weapon = IT_SHOTGUN;
			if (self.ammo_shells < 1)
				am = 1;
		}
		else if (self.weapon == IT_SHOTGUN)
		{
			self.weapon = IT_AXE;
		}
		else if (self.weapon == IT_AXE)
		{
			self.weapon = IT_LIGHTNING;
			if (self.ammo_cells < 1)
				am = 1;
		}

		if ( (it & self.weapon) && am == 0)
		{
			W_SetCurrentAmmo ();
			return;
		}
	}

};

/*
============
ServerflagsCommand

Just for development
============
*/
void() ServerflagsCommand =
{
	serverflags = serverflags * 2 + 1;
};

void() QuadCheat =
{
	if (deathmatch || coop)
		return;
	self.super_time = 1;
	self.super_damage_finished = time + 30;
	self.items = self.items | IT_QUAD;
	dprint ("quad cheat\n");
};

#ifdef TEMPORALCORTEX
void() SlowmoCheat =
{
	if (deathmatch || coop)
		return;
	self.slowmo_time = 1;
	self.slowmo_finished = time + 20;
	self.items2 = self.items2 | IT2_SLOWMO;

	cvar_setf("sv_gamespeed", 0.5);
};

void() IncendiaryCheat =
{
	if (deathmatch || coop)
		return;

	self.items2 = self.items2 | IT2_INCENDIARY_AMMO;
	self.incendiary_ammo_count = 50;

	if (self.ammo_shells < 200)
		self.ammo_shells += 50;
};
#endif

/*
============
ImpulseCommands

============
*/
void() ImpulseCommands =
{
	local vector dir;

	if (self.impulse >= 1 && self.impulse <= 8)
		W_ChangeWeapon ();

	if (self.impulse == 9)
		CheatCommand ();
	if (self.impulse == 10)
		CycleWeaponCommand ();
	if (self.impulse == 11)
		ServerflagsCommand ();
	if (self.impulse == 12)
		CycleWeaponReverseCommand ();

#ifdef TEMPORALCORTEX
	if (self.impulse == 51)
	{
		if (self.items2 & IT2_GRAPPLING_HOOK)
		{
			if (!self.grappling)
			{
				dir = aim (self, 100000);
				makevectors (self.angles);

				self.grappling = 1;

				W_FireGrappleHook (5000, dir);
			}
			else
			{
				self.grappling = 0;
				self.hooked = 0;
			}
		}
		else
		{
			self.grappling = 0;
			self.hooked = 0;
		}
	}

	if (self.impulse == 253)
		SlowmoCheat ();

	if (self.impulse == 254)
		IncendiaryCheat ();
#endif

	if (self.impulse == 255)
		QuadCheat ();

	self.impulse = 0;
};

/*
============
W_WeaponFrame

Called every frame so impulse events can be handled as well as possible
============
*/
void() W_WeaponFrame =
{
	if (time < self.attack_finished)
		return;

	ImpulseCommands ();

// check for attack
	if (self.button0)
	{
		SuperDamageSound ();
		W_Attack ();
	}
};

/*
========
SuperDamageSound

Plays sound if needed
========
*/
void() SuperDamageSound =
{
	if (self.super_damage_finished > time)
	{
		if (self.super_sound < time)
		{
			self.super_sound = time + 1;
			sound (self, CHAN_BODY, "items/damage3.wav", 1, ATTN_NORM);
		}
	}
	return;
};

/*
==============================================================================

TEMPORAL CORTEX GRAPPLING HOOK

==============================================================================
*/

entity newhook;
entity hooktarget;
vector hookpoint;
vector oldhookpoint;
vector hookangle;
vector shotangle;

vector( vector pos1, vector pos2 ) RotationFromVector =
{
	local vector cross;

	cross = crossproduct( pos1, pos2 );

	return cross;
};

vector oldorg;

void() hook_think =
{
	local entity player;
	local vector vec;
	local vector start;
	local vector end;
	local vector adjust;
	local float dist;

	player = self.owner;
	start = player.origin;
	end = start;
	end_z = end_z - (self.size_z + 1);
	dist = vlen( self.origin - player.origin );

	if ( dist < 32 && player.hooked )
	{
		player.velocity = player.velocity * 0.2;
	}

	//dprint("Vec length ");
	//dprint(ftos(dist));
	//dprint("\n");

	self.SendFlags |= SENDFLAG_ORIGIN;
	self.SendFlags |= SENDFLAG_ANGLES;
	self.SendFlags |= SENDFLAG_VELOCITY;

	if (player.flags & FL_ONGROUND)
	{
		player.origin += '0 0 1';
		player.flags &= ~FL_ONGROUND;
	}

	if ( player.hooked )
	{
		// dprint( "Hooktarget: " );
		// dprint( hooktarget.classname );
		// dprint( "\n" );

		if ( hooktarget.classname == "worldspawn" )
		{
			self.velocity = VEC_ORIGIN;
			setorigin( self, hookpoint );

			vec = normalize( self.origin - player.origin );
			vec_z = vec_z * ( 150 / 100 );
		}
		else
		{
			self.velocity = hooktarget.velocity;
			//self.origin = self.origin + normalize( self.origin - hooktarget.velocity ) * vlen( self.origin - hooktarget.velocity );

			vec = normalize( self.origin - player.origin );
			vec_z = vec_z * ( 150 / 100 );
		}

		// Missi: This is the formula for the grappling hook effect (2026.9.22)
		player.velocity = player.velocity + vec * sqrt( vlen( player.velocity ) ) * 8.0 * ( frametime / cvar("sv_maxtic") ) * cvar("tc_sv_grapple_velocity_scale");

		//dprint("Player speed ");
		//dprint(ftos(vlen(player.velocity)));
		//dprint("\n");

		traceline (start, end, FALSE, self);

		if (trace_allsolid)
		{
			player.flags = player.flags - ( player.flags & FL_ONGROUND );
			adjust = player.velocity + trace_plane_normal * 200;
			//dprint(vtos(adjust));
			player.velocity = adjust;
		}
	}

	self.think = hook_think;
	self.nextthink = time + frametime;

	//dprint("dist: ");
	//dprint(ftos(dist));
	//dprint("\n");

	oldorg = self.origin;

	if ( dist >= 1536.0 || !player.grappling )
	{
		player.hooked = 0;
		player.grappling = 0;
		remove( self );
	}
};

void() hook_touch =
{
	local entity player;

	player = self.owner;
	oldhookpoint = VEC_ORIGIN;

	if (other == self.owner)
		return;

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

	if (player.grappling && player.hooked)
		return;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		player.attack_finished = time + 0.1;
		player.hooked = 0;
		player.grappling = 0;
		remove(self);
		return;
	}

	//dprint( "Grappled from class " );
	//dprint( player.classname );
	//dprint( "!\n" );
	player.attack_finished = time + 0.1;

	hookpoint = self.origin;
	hookangle = self.angles;

	player.hooked = 1;

	hooktarget = other;

// hit something that bleeds
	if (other.takedamage)
	{
		spawn_touchblood (9);
		T_Damage (other, self, self.owner, 9);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_TC_GRAPPLING_HOOK);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

};

void(float speed, vector org, vector dir) shoot_grapple_hook =
{
	newhook = spawn ();
	newhook.owner = self;
	newhook.movetype = MOVETYPE_FLYMISSILE;
	newhook.solid = SOLID_BBOX;

	newhook.angles = vectoangles(dir);

	newhook.touch = hook_touch;
	newhook.classname = "hook";
	newhook.flags = newhook.flags | FL_OMNIPRESENT;
	newhook.think = hook_think;
	newhook.nextthink = time; // 6;
	setmodel (newhook, "progs/spike.mdl");
	setsize (newhook, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (newhook, org);

	newhook.velocity = dir * speed;

	newhook.source = newhook.origin;
	newhook.SendEntity = SendGrapplingHook;
	newhook.starttime = time;
};

/*
================
FireGrappleHook

Temporal Cortex: Used by any entity that is capable of firing a weapon.
================
*/

void(float speed, vector dir) W_FireGrappleHook =
{
	local	vector	src;

	//makevectors(self.v_angle);
	makevectors(self.angles);

	if ( cvar( "tc_cl_q1viewmodel" ) == 0 )
		src = self.origin + v_forward*10;
	else
		src = self.origin + v_forward * 10;

	src_z = self.absmin_z + self.size_z * 0.7;

	ClearMultiDamage ();

	//traceline (src, src + direction*2048, FALSE, self);
	//if (trace_fraction != 1.0)
		//TraceAttack (4, direction);

	shotangle = self.v_angle;

	shoot_grapple_hook( speed, src, dir );
};

















