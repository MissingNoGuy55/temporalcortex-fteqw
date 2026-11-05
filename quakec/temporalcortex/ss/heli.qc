/*
==============================================================================

TEMPORAL CORTEX ATTACK HELICOPTER

==============================================================================
*/

$cd temporalcortex/models/heli
$origin 0 0 24
$base wizbase
$skin wizbase

$frame idle1 idle2 idle3 idle4 idle5 idle6
$frame idle7 idle8 idle9 idle10 idle11 idle12
$frame idle13 idle14 idle15 idle16

void()	heli_stand1		=[	$idle1,		heli_stand2		] {};
void()	heli_stand2		=[	$idle2,		heli_stand3		] {};
void()	heli_stand3		=[	$idle3,		heli_stand4		] {};
void()	heli_stand4		=[	$idle4,		heli_stand5		] {};
void()	heli_stand5		=[	$idle5,		heli_stand6		] {};
void()	heli_stand6		=[	$idle6,		heli_stand7		] {};
void()	heli_stand7		=[	$idle7,		heli_stand8		] {};
void()	heli_stand8		=[	$idle8,		heli_stand9		] {};
void()	heli_stand9		=[	$idle9,		heli_stand10	] {};
void()	heli_stand10	=[	$idle10,	heli_stand11	] {};
void()	heli_stand11	=[	$idle11,	heli_stand12	] {};
void()	heli_stand12	=[	$idle12,	heli_stand13	] {};
void()	heli_stand13	=[	$idle13,	heli_stand14	] {};
void()	heli_stand14	=[	$idle14,	heli_stand15	] {};
void()	heli_stand15	=[	$idle15,	heli_stand16	] {};
void()	heli_stand16	=[	$idle16,	heli_stand1		] {};

.float windup;
.float force;
.float goalspeed;
.float burst_finished;
.float burst_next;
.float firing;
.float rotor_update_time;
.vector goalpos;
.vector desiredfacedir;
.vector lastangleupdate;
.vector mount_offset;
.vector mount_dir;
.vector oldangles;
.vector oldavelocity;
.float mount_distance;
.float death_explosion_time;
.float death_explosion_stage;
.float rotor_oldangle;

const float SF_ROTOR_START_INACTIVE = 1;
const float SF_ROTOR_TAIL_ROTOR = 2;

const float HELI_FLIGHT_STATIC_POWER = 20;
const vector HELI_FLIGHT_ADJUST = '0 0 768';

float(float a2, float a1, float frac) qc_lerp =
{
	if (a1 - a2 > 180)
		a1 -= 360;
	if (a1 - a2 < -180)
		a1 += 360;
	return a2 + frac * (a1 - a2);
};

vector(vector v2, vector v1, float frac) qc_lerp_vector =
{
	local vector ret;
	ret = VEC_ORIGIN;

	ret_x = qc_lerp(v2_x, v1_x, frac);
	ret_y = qc_lerp(v2_y, v1_y, frac);
	ret_z = qc_lerp(v2_z, v1_z, frac);

	return ret;
};

float(vector p) qc_vlensqr =
{
	return p_x * p_x + p_y * p_y + p_z * p_z;
};

float(vector p) qc_vlen2d =
{
	return sqrt(p_x * p_x + p_y * p_y);
};

float(vector p) qc_vlen2dsqr =
{
	return p_x * p_x + p_y * p_y;
};

float(vector p1, vector p2) qc_distsqr =
{
	return qc_vlensqr(p2 - p1);
};

void(vector a, vector b, float scale, vector out) qc_vectorma =
{
	out_x = a_x + scale*b_x;
	out_y = a_y + scale*b_y;
	out_z = a_z + scale*b_z;
};

float(vector point, vector linea, vector lineb, vector dir) heli_closest_point_to_line =
{
	local float div;

	dir = lineb - linea;
	div = dotproduct(dir, dir);

	//dprint ("heli_closest_point_to_line: ");
	//dprint (ftos((dotproduct(dir, point) - dotproduct(dir, linea)) / div));
	//dprint ("\n");

	if (div < 0.0001)
	{
		return 0;
	}
	else
	{
		return (dotproduct(dir, point) - dotproduct(dir, linea)) / div;
	}
};

void(vector point, vector linea, vector lineb, vector closest, float out) heli_closest_point_on_line =
{
	local vector vdir = VEC_ORIGIN;

	float t = heli_closest_point_to_line (point, linea, lineb, vdir);
	out = t;
	qc_vectorma (linea, vdir, t, closest);
};

float(vector point) heli_closest_point_to_current_path =
{
	local float t = 0;

	heli_closest_point_on_line (self.origin, self.prev_path.origin, self.next_path.origin, point, t);

	//dprint ("heli_closest_point_to_current_path: ");
	//dprint (vtos(point));
	//dprint ("\n");

	return t;
};

// HACK: FIXME: This is ripped straight from HL2, with some changes.
// This needs to be rewritten before release as it is totally non-GPL'd.
void() heli_flight =
{
	local vector impulse;
	local vector avel, estimate;
	local vector forward2d, vel2d;
	local float dir, roll, dist;
	local float side;
	local float speed;
	local float dt;
	local vector adjust = '5 0 0';
	local vector temp;

	if (self.goalspeed < self.maxspeed)
		self.goalspeed += 5;

	avel = self.avelocity;

	dt = time-self.starttime;
	self.starttime = time;

	makevectors(self.angles + avel /* * 2 */ + adjust);

	side = dotproduct(self.desiredfacedir, v_right);
	if (side < 0)
	{
		if (avel_y < 60)
			avel_y += 8;
	}
	else
	{
		if (avel_y > -60)
			avel_y -= 8;
	}

	avel_y *= 0.98;

	makevectors(self.angles + avel /* * 1 */ + adjust);
	estimate = self.origin + self.velocity /* * 2 */ + v_up * self.force * HELI_FLIGHT_STATIC_POWER - HELI_FLIGHT_ADJUST;

	makevectors(self.angles + adjust);

	impulse = v_up * self.force;
	impulse_z -= 38.4;

	temp = self.velocity + impulse;
	self.velocity = temp;

	forward2d_x = v_forward_x;
	forward2d_y = v_forward_y;
	forward2d_z = 0;

	vel2d_x = self.velocity_x;
	vel2d_y = self.velocity_y;
	vel2d_z = 0;

	speed = vlen(self.velocity);
	dir = dotproduct(forward2d, vel2d);

	if (dir < 0)
		speed = -speed;

	dist = dotproduct(self.goalpos - estimate, v_forward);
	roll = -dotproduct(self.goalpos - estimate, v_right);

	if (roll > 0)
	{
		if (self.angles_z > -30 && avel_z > -15)
			avel_z -= 4;
		else
			avel_z += 2;
	}
	else
	{
		if (self.angles_z < 30 && avel_z < 15)
			avel_z += 4;
		else
			avel_z -= 2;
	}

	temp = self.velocity;
	temp_x *= 1 - fabs(v_right_x) * 0.005;
	temp_y *= 1 - fabs(v_right_y) * 0.005;
	temp_z *= 1 - fabs(v_right_z) * 0.005;
	self.velocity = temp;

	temp = self.velocity;
	temp *= 0.995;
	self.velocity = temp;

	if (self.force < 80 && estimate_z < self.goalpos_z)
	{
		self.force += 12;
	}
	else if (self.force > 30)
	{
		if (estimate_z > self.goalpos_z)
			self.force -= 8;
	}

	//dprint ("heli dist: ");
	//dprint (ftos(dist));
	//dprint ("\n");

	//dprint ("heli roll: ");
	//dprint (ftos(roll));
	//dprint ("\n");

	//dprint ("heli self.angles_x + avel_x: ");
	//dprint (ftos(self.angles_x + avel_x));
	//dprint ("\n");

	if (dist > 0 && speed < self.goalspeed && self.angles_x + avel_x < 40)
	{
		avel_x += 12;
	}
	else if (dist < 0 && speed > -50 && self.angles_x + avel_x > -20)
	{
		avel_x -= 12;
	}
	else if (self.angles_x + avel_x < 0)
	{
		avel_x += 4;
	}
	else if (self.angles_x + avel_x > 0)
	{
		avel_x -= 4;
	}

	self.avelocity = avel;
	self.nextthink = time;
};

// Missi: Ahem... stupid quake bug (2026.9.25)
void() heli_flight_mesh =
{
	local vector impulse;
	local vector avel, estimate, ang, vel;
	local vector forward2d, vel2d;
	local float dir, roll, dist;
	local float side;
	local float speed;
	local float dt;
	local vector adjust = '5 0 0';
	local vector temp;

	if (self.goalspeed < self.maxspeed)
		self.goalspeed += 5;

	avel = self.avelocity;
	ang = self.angles;
	vel = self.velocity;

	dt = time-self.starttime;
	self.starttime = time;

	makevectors(ang + avel /* * 2 */ + adjust);

	side = dotproduct(self.desiredfacedir, v_right);
	if (side < 0)
	{
		if (avel_y < 60)
			avel_y += 8;
	}
	else
	{
		if (avel_y > -60)
			avel_y -= 8;
	}

	avel_y *= 0.98;

	makevectors(ang + avel /* * 1 */ + adjust);
	estimate = self.origin + vel /* * 2 */ + v_up * self.force * HELI_FLIGHT_STATIC_POWER - HELI_FLIGHT_ADJUST;

	makevectors(ang + adjust);

	impulse = v_up * self.force;
	impulse_z -= 38.4;

	temp = vel + impulse;
	self.velocity = temp;
	vel = self.velocity;

	forward2d_x = v_forward_x;
	forward2d_y = v_forward_y;
	forward2d_z = 0;

	vel2d_x = self.velocity_x;
	vel2d_y = self.velocity_y;
	vel2d_z = 0;

	speed = vlen(vel);
	dir = dotproduct(forward2d, vel2d);

	if (dir < 0)
		speed = -speed;

	dist = dotproduct(self.goalpos - estimate, v_forward);
	roll = -dotproduct(self.goalpos - estimate, v_right);

	if (roll > 0)
	{
		if (self.angles_z > -30 && avel_z > -15)
			avel_z -= 4;
		else
			avel_z += 2;
	}
	else
	{
		if (self.angles_z < 30 && avel_z < 15)
			avel_z += 4;
		else
			avel_z -= 2;
	}

	temp = vel;
	temp_x *= 1 - fabs(v_right_x) * 0.005;
	temp_y *= 1 - fabs(v_right_y) * 0.005;
	temp_z *= 1 - fabs(v_right_z) * 0.005;
	self.velocity = temp;
	vel = self.velocity;

	temp = vel;
	temp *= 0.995;
	self.velocity = temp;
	vel = self.velocity;

	if (self.force < 80 && estimate_z < self.goalpos_z)
	{
		self.force += 12;
	}
	else if (self.force > 30)
	{
		if (estimate_z > self.goalpos_z)
			self.force -= 8;
	}

	//dprint ("heli dist: ");
	//dprint (ftos(dist));
	//dprint ("\n");

	//dprint ("heli roll: ");
	//dprint (ftos(roll));
	//dprint ("\n");

	//dprint ("heli self.angles_x + avel_x: ");
	//dprint (ftos(self.angles_x + avel_x));
	//dprint ("\n");

	if (dist > 0 && speed < self.goalspeed && self.angles_x + avel_x < 40)
	{
		avel_x += 12;
	}
	else if (dist < 0 && speed > -50 && self.angles_x + avel_x > -20)
	{
		avel_x -= 12;
	}
	else if (self.angles_x + avel_x < 0)
	{
		avel_x += 4;
	}
	else if (self.angles_x + avel_x > 0)
	{
		avel_x -= 4;
	}

	self.avelocity = avel;
	self.nextthink = time;
};

void() heli_think;

void() heli_find_target =
{
	local entity targ;

	targ = world;

	if (self.target)
	{
		targ = find (world, targetname, self.target);

		if (!targ.prev_path)
		{
			self.prev_path = world;
			self.next_path = targ;
		}
		else
		{
			self.prev_path = targ.prev_path;
			self.next_path = targ;
		}

		self.movetarget = self.next_path;
	}

	self.think = heli_think;
	self.nextthink = time + 1;
};

void() heli_update_enemy =
{
	if (self.enemy)
		return;

	local entity targ;

	targ = findradius (self.origin, 4096);

	while (targ)
	{
		if (targ.flags & FL_CLIENT)
		{
			if (targ.health > 0)
			{
				self.enemy = targ;
				break;
			}
		}

		targ = targ.chain;
	}
};

void() heli_update_goalpos =
{
	if (self.movetarget != self.prev_path)
	{
		self.prev_path = self.movetarget;
		self.movetarget = self.next_path;
		self.goalpos = self.movetarget.origin;
	}

	heli_closest_point_to_current_path (self.goalpos);
};

void() heli_facedir =
{
	local vector target, targetnorm;
	local vector desired, desirednorm;

	target = self.movetarget.origin - self.origin;
	desired = self.goalpos - self.origin;

	targetnorm = normalize(target);
	desirednorm = normalize(desired);

	if (self.enemy)
	{
		self.desiredfacedir = targetnorm;
	}
	else
	{
		self.desiredfacedir = desirednorm;
	}
};

void() heli_crash =
{
	if (other != world)
		return;

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion();

	self.deadflag = DEAD_DEAD;

	self.think = SUB_Remove;
	self.nextthink = time + 1;
};

// Missi: GTA III style helicopter spinout (2026.11.4)
void() heli_spinout =
{
	makevectors(self.angles);

	if (self.death_explosion_stage == 0)
	{
		// Missi: First stage.
		self.velocity_z *= 0.85;
		self.avelocity_x = 0;
		self.avelocity_y += 1;
		self.avelocity_z = 0;
	}
	else
	{
		self.velocity_z *= 0.995;
		self.avelocity_x = 0;
		self.avelocity_y += 2;
		self.avelocity_z = 0;
	}

	if (time > self.death_explosion_time)
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_EXPLOSION);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);

		makevectors(VEC_ORIGIN);
		self.velocity += v_right * 500;

		self.death_explosion_time = time + 999999;
		self.death_explosion_stage++;
	}

	self.SendFlags |= (SENDFLAG_ORIGIN | SENDFLAG_ANGLES | SENDFLAG_VELOCITY | SENDFLAG_AVELOCITY);
	self.nextthink = time;
};

void() heli_killed =
{
	// Missi: Mostly for brevity, though there is some
	// extra behavior that relies on that.
	self.deadflag = DEAD_DYING;

	self.death_explosion_time = time + 4;

	self.think = heli_spinout;
	self.touch = heli_crash;
};

void() heli_think =
{
	heli_update_enemy();
	heli_update_goalpos();
	heli_facedir();

	if (substring(self.model, strlen(self.model)-4, 4) == ".mdl")
		heli_flight_mesh();
	else
		heli_flight();

	if (time > self.rotor_update_time)
	{
		if (self.frame < $idle16)
			self.frame = self.frame + 1;
		else
			self.frame = $idle1;

		self.rotor_update_time = time + 0.005;
	}

	self.SendFlags |= (SENDFLAG_ORIGIN | SENDFLAG_ANGLES | SENDFLAG_VELOCITY | SENDFLAG_AVELOCITY);

	self.nextthink = time;
};

float(entity toplayer, float fl) SendHeli =
{
	vector v;

	v = self.origin + self.velocity*(time-self.starttime);

	WriteByte (MSG_ENTITY, CLASS_HELI);

	//dprint("self.frame: ");
	//dprint(ftos(self.frame));
	//dprint("\n");

	WriteByte (MSG_ENTITY, self.frame);
	WriteLong (MSG_ENTITY, fl);

	if (fl & SENDFLAG_ORIGIN)
	{
		WriteCoord (MSG_ENTITY, self.origin_x);
		WriteCoord (MSG_ENTITY, self.origin_y);
		WriteCoord (MSG_ENTITY, self.origin_z);
	}
	if (fl & SENDFLAG_ANGLES)
	{
		WriteShort (MSG_ENTITY, self.angles_x*(256/360) * autocvar(r_meshpitch, -1));
		WriteShort (MSG_ENTITY, self.angles_y*(256/360));
		WriteShort (MSG_ENTITY, self.angles_z*(256/360));
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

	WriteEntity (MSG_ENTITY, self.owner);

	return TRUE;
};

/*QUAKED func_helicopter (0.0 0.5 0.8) ? start_inactive
*/
void() func_helicopter =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_sound ("heli/rotors.wav");

	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_TOSS;
	setorigin (self, self.origin);
	setmodel (self, self.model);
	setsize (self, self.mins, self.maxs);
	self.windup = 1;

	if (self.health)
	{
		self.max_health = self.health;
		self.takedamage = DAMAGE_YES;
		self.th_die = heli_killed;
	}

	self.force = 0;
	self.goalpos = self.origin;
	self.desiredfacedir = VEC_ORIGIN;

	self.think = heli_find_target;
	self.nextthink = self.ltime + 1;

	self.next_path = world;
	self.prev_path = world;

	self.source = self.origin;

	if (!self.maxspeed)
		self.maxspeed = 3000;

	self.goalspeed = 0;
	self.death_explosion_time = 0;
	self.death_explosion_stage = 0;
	self.rotor_oldangle = 0;

	self.starttime = time + 1;
	self.SendEntity = SendHeli;
	self.SendFlags = FULLSEND;
};

void() heli_rotor_update_angle =
{
	local float td;
	local vector ad;

	self.rotor_oldangle += frametime * 100;

	//dprint ("self.goalentity.angles: ");
	//dprint (vtos(self.goalentity.angles));
	//dprint ("\n");

	td = time - self.starttime;
	self.starttime = time;

	makevectors(self.owner.angles);
	ad = crossproduct(v_forward, v_right);
	self.angles = rotateaxisangle(self.angles, self.owner.angles, self.origin, ad, self.rotor_oldangle);

	//dprint("self.angles: ");
	//dprint(vtos(self.angles));
	//dprint("\n");

	self.SendFlags |= (SENDFLAG_ORIGIN | SENDFLAG_ANGLES | SENDFLAG_VELOCITY | SENDFLAG_AVELOCITY | SENDFLAG_MINS | SENDFLAG_MAXS);
};

void() heli_rotor_think =
{
	local vector org = self.goalentity.origin - self.origin;
	local vector angvel = self.goalentity.avelocity - self.avelocity;

	if (!self.owner)
		self.think = SUB_Remove;

	setorigin (self, self.goalentity.origin);

	heli_rotor_update_angle ();

	self.nextthink = time + frametime;
};

void() heli_rotor_find =
{
	local entity own;

	own = find (world, targetname, self.target);

	if (!own)
		objerror ("func_helicopter_rotor without a target");

	//dprint("heli rotors found target: ");
	//dprint(own.classname);
	//dprint("\n");

	if (!own.owner)
		objerror ("func_helicopter_rotor couldn't find a func_helicopter");

	//dprint("heli rotors found owner: ");
	//dprint(own.owner.classname);
	//dprint("\n");

	self.goalentity = own;
	self.owner = own.owner;

	self.mount_offset = self.origin - self.owner.origin;
	self.mount_dir = normalize(self.origin - self.owner.origin);
	self.mount_distance = vlen(self.mount_offset);
	self.angles = self.goalentity.angles;

	self.oldangles = self.owner.angles;

	self.think = heli_rotor_think;
	self.nextthink = time;
};

/*QUAKED func_helicopter_rotor (0 .5 .8) ? start_inactive tail_rotor
*/
void() func_helicopter_rotor =
{
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_FLY;

	setmodel (self, self.model);
	self.windup = 1;

	if (self.health)
	{
		self.takedamage = DAMAGE_YES;
		self.th_die = heli_killed;
	}

	self.starttime = time;
	self.think = heli_rotor_find;
	self.nextthink = time + 0.1;	// Missi: Needs to find the mount point AFTER func_helicopter_rotormount finds the heli (2026.8.8)
	self.lastangleupdate = self.angles;

	self.source = self.origin;	// Mount point of rotor (2026.8.7)

	self.mount_offset = VEC_ORIGIN;
	self.mount_distance = 0;

	self.SendEntity = SendHeli;
	self.SendFlags = FULLSEND;
};

void() rotor_mountpoint_think =
{
	makevectors(self.owner.angles);

	if (self.owner)
	{
		setorigin (self, self.owner.origin + v_forward + self.mount_offset);
		self.angles = self.owner.angles;
		self.avelocity = self.owner.avelocity;
	}
	else
		self.think = SUB_Remove;

	self.SendFlags |= (SENDFLAG_ORIGIN | SENDFLAG_ANGLES | SENDFLAG_VELOCITY | SENDFLAG_AVELOCITY | SENDFLAG_MINS | SENDFLAG_MAXS);
	self.nextthink = time;
};

void() rotor_mountpoint_find =
{
	local entity targ;

	if (!self.target)
	{
		objerror ("func_helicopter_rotormount without a target");
	}

	targ = find (world, targetname, self.target);

	if (targ)
	{
		//dprint("heli rotor mount found target: ");
		//dprint(targ.classname);
		//dprint("\n");

		self.owner = targ;
		self.mount_offset = self.origin - self.owner.origin;

		setorigin(self, self.owner.origin + self.mount_offset);
		self.angles = self.owner.angles;
	}
	else
	{
		objerror ("func_helicopter_rotormount couldn't find its target");
	}

	//dprint("rotor offset: ");
	//dprint(vtos(self.mount_offset));
	//dprint("\n");

	self.think = rotor_mountpoint_think;
	self.nextthink = time;
};

/*QUAKED func_helicopter_rotormount (0 .5 .8) (-16 -16 -16) (16 16 16)
Mounting point for func_helicopter_rotor if targeted. Throws an error otherwise.
*/
void() func_helicopter_rotormount =
{
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_FLY;

	setsize(self, VEC_ORIGIN, VEC_ORIGIN);

	self.think = rotor_mountpoint_find;
	self.nextthink = time;		// Missi: Needs to find the helicopter before func_helicopter_rotor

	self.starttime = time;
	self.SendEntity = SendHeli;
	self.SendFlags = FULLSEND;
}

void() turret_think =
{
	local vector dir;
	local entity en;
	local float dist;
	local vector newang;

	if (!self.owner)
		self.think = SUB_Remove;

	en = self.owner.enemy;

	if (en)
	{
		dist = vlen(en.origin - self.origin);

		traceline (self.origin, en.origin, false, self);

		if (dist < 4096)
		{
			newang = vectoangles(en.origin - self.origin);
			newang_x *= autocvar (r_meshpitch, -1);
			self.angles = newang - (self.angles - self.lastangleupdate);

			makevectors(self.angles);
			dir = aim(self, 20000);

			if (self.burst_next < time && !self.firing)
			{
				self.firing = TRUE;
				self.burst_finished = time + 5;
			}

			if (self.firing)
			{
				if (self.attack_finished < time && !trace_startsolid)
				{
					self.effects = self.effects | EF_MUZZLEFLASH;
					FireBullets_NoHitScan (cvar("tc_sv_army_helicopter_turret_damage"), TC_AMMO_7_62x51MM, 6500, 1, dir, '0.04 0.04 0');
					self.attack_finished = time + 0.000166666666667;	// ~6000 RPM
				}

				if (self.burst_finished < time || en.deadflag == DEAD_DEAD || trace_startsolid)
				{
					self.firing = FALSE;
					self.burst_next = time + 5;
				}
			}
		}
	}

	self.lastangleupdate = self.angles;

	makevectors(self.owner.angles);
	self.origin = self.owner.origin + v_forward * self.mount_distance;

	self.nextthink = time;
};

void() turret_find_heli =
{
	local entity targ;

	if (!self.target)
		objerror ("func_helicopter_turret without a target");

	targ = find (world, targetname, self.target);

	if (!targ)
		objerror ("func_helicopter_turret couldn't find target");

	self.owner = targ;
	self.mount_offset = self.origin - self.owner.origin;
	self.mount_distance = vlen(self.mount_offset);

	self.think = turret_think;
	self.nextthink = time;
};

/*QUAKED func_helicopter_turret (0.0 0.5 0.8)
*/
void() func_helicopter_turret =
{
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_NONE;

	setmodel(self, self.model);
	setsize(self, self.mins, self.maxs);

	self.think = turret_find_heli;
	self.nextthink = time + 0.1;

	self.firing = 0;
	self.mount_distance = 0;
	self.attack_finished = time;
	self.burst_finished = time;
	self.burst_next = time;
}

/*QUAKED monster_army_helicopter_turret (1 0 0) (-16 -16 -16) (16 16 16)
model="progs/heli_turret.mdl"
Point entity version of helicopter turret.
*/
void() monster_army_helicopter_turret =
{
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_NONE;

	setmodel(self, self.model);
	setsize(self, self.mins, self.maxs);

	self.think = turret_find_heli;
	self.nextthink = time + 0.1;

	self.firing = 0;
	self.mount_distance = 0;
	self.attack_finished = time;
	self.burst_finished = time;
	self.burst_next = time;
}

/*QUAKED monster_army_helicopter (1 0 0) (-256 -256 -32) (256 256 32)
model="progs/heli.mdl"
Point entity version of helicopter that does not have as many restrictions as func_helicopter.
*/

const vector HELI_BBOX_MINS = '-256 -256 -32';
const vector HELI_BBOX_MAXS = '256 256 32';

void() monster_army_helicopter =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	precache_sound ("heli/rotors.wav");

	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_TOSS;

	precache_model (self.model);

	setmodel (self, self.model);
	setsize (self, HELI_BBOX_MINS, HELI_BBOX_MAXS);

	self.windup = 1;

	if (self.health)
	{
		self.max_health = self.health;
		self.takedamage = DAMAGE_YES;
		self.th_die = heli_killed;
	}

	self.force = 0;
	self.goalpos = self.origin;
	self.desiredfacedir = VEC_ORIGIN;

	self.think = heli_find_target;
	self.nextthink = self.ltime + 0.1;

	self.next_path = world;
	self.prev_path = world;

	self.source = self.origin;

	if (!self.maxspeed)
		self.maxspeed = 3000;

	self.goalspeed = 0;
	self.death_explosion_time = 0;
	self.death_explosion_stage = 0;
	self.rotor_oldangle = 0;

	self.starttime = time;
	self.SendEntity = SendHeli;
	self.SendFlags = FULLSEND;
};


















