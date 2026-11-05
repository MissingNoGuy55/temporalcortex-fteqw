void() plat_center_touch;
void() plat_outside_touch;
void() plat_trigger_use;
void() plat_go_up;
void() plat_go_down;
void() plat_crush;
float PLAT_LOW_TRIGGER = 1;

void() plat_spawn_inside_trigger =
{
	local entity	trigger;
	local vector	tmin, tmax;

//
// middle trigger
//	
	trigger = spawn();
	trigger.touch = plat_center_touch;
	trigger.movetype = MOVETYPE_NONE;
	trigger.solid = SOLID_TRIGGER;
	trigger.enemy = self;
	
	tmin = self.mins + '25 25 0';
	tmax = self.maxs - '25 25 -8';
	tmin_z = tmax_z - (self.pos1_z - self.pos2_z + 8);
	if (self.spawnflags & PLAT_LOW_TRIGGER)
		tmax_z = tmin_z + 8;
	
	if (self.size_x <= 50)
	{
		tmin_x = (self.mins_x + self.maxs_x) / 2;
		tmax_x = tmin_x + 1;
	}
	if (self.size_y <= 50)
	{
		tmin_y = (self.mins_y + self.maxs_y) / 2;
		tmax_y = tmin_y + 1;
	}
	
	setsize (trigger, tmin, tmax);
};

void() plat_hit_top =
{
	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	self.state = STATE_TOP;
	self.think = plat_go_down;
	self.nextthink = self.ltime + 3;
};

void() plat_hit_bottom =
{
	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	self.state = STATE_BOTTOM;
};

void() plat_go_down =
{
	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	self.state = STATE_DOWN;
	SUB_CalcMove (self.pos2, self.speed, plat_hit_bottom);
};

void() plat_go_up =
{
	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	self.state = STATE_UP;
	SUB_CalcMove (self.pos1, self.speed, plat_hit_top);
};

void() plat_center_touch =
{
	if (other.classname != "player")
		return;
		
	if (other.health <= 0)
		return;

	self = self.enemy;
	if (self.state == STATE_BOTTOM)
		plat_go_up ();
	else if (self.state == STATE_TOP)
		self.nextthink = self.ltime + 1;	// delay going down
};

void() plat_outside_touch =
{
	if (other.classname != "player")
		return;

	if (other.health <= 0)
		return;
		
//dprint ("plat_outside_touch\n");
	self = self.enemy;
	if (self.state == STATE_TOP)
		plat_go_down ();
};

void() plat_trigger_use =
{
	if (self.think)
		return;		// allready activated
	plat_go_down();
};


void() plat_crush =
{
//dprint ("plat_crush\n");

	T_Damage (other, self, self, 1);
	
	if (self.state == STATE_UP)
		plat_go_down ();
	else if (self.state == STATE_DOWN)
		plat_go_up ();
	else
		objerror ("plat_crush: bad self.state\n");
};

void() plat_use =
{
	self.use = SUB_Null;
	if (self.state != STATE_UP)
		objerror ("plat_use: not in up state");
	plat_go_down();
};


/*QUAKED func_plat (0 .5 .8) ? PLAT_LOW_TRIGGER
speed	default 150

Plats are always drawn in the extended position, so they will light correctly.

If the plat is the target of another trigger or button, it will start out disabled in the extended position until it is trigger, when it will lower and become a normal plat.

If the "height" key is set, that will determine the amount the plat moves, instead of being implicitly determined by the model's height.
Set "sounds" to one of the following:
1) base fast
2) chain slow
*/


void() func_plat =
{
	if (!self.t_length)
		self.t_length = 80;
	if (!self.t_width)
		self.t_width = 10;

	if (self.sounds == 0)
		self.sounds = 2;
// FIX THIS TO LOAD A GENERIC PLAT SOUND

	if (self.sounds == 1)
	{
		precache_sound ("plats/plat1.wav");
		precache_sound ("plats/plat2.wav");
		self.noise = "plats/plat1.wav";
		self.noise1 = "plats/plat2.wav";
	}

	if (self.sounds == 2)
	{
		precache_sound ("plats/medplat1.wav");
		precache_sound ("plats/medplat2.wav");
		self.noise = "plats/medplat1.wav";
		self.noise1 = "plats/medplat2.wav";
	}


	self.mangle = self.angles;
	self.angles = '0 0 0';

	self.classname = "plat";
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	setorigin (self, self.origin);	
	setmodel (self, self.model);
	setsize (self, self.mins , self.maxs);

	self.blocked = plat_crush;
	if (!self.speed)
		self.speed = 150;

// pos1 is the top position, pos2 is the bottom
	self.pos1 = self.origin;
	self.pos2 = self.origin;
	if (self.height)
		self.pos2_z = self.origin_z - self.height;
	else
		self.pos2_z = self.origin_z - self.size_z + 8;

	self.use = plat_trigger_use;

	plat_spawn_inside_trigger ();	// the "start moving" trigger	

	if (self.targetname!="")
	{
		self.state = STATE_UP;
		self.use = plat_use;
	}
	else
	{
		setorigin (self, self.pos2);
		self.state = STATE_BOTTOM;
	}
};

//============================================================================

void() train_next;
void() func_train_find;

void() train_blocked =
{
	if (time < self.attack_finished)
		return;
	self.attack_finished = time + 0.5;
	T_Damage (other, self, self, self.dmg);
};
void() train_use =
{
	if (self.think != func_train_find)
		return;		// already activated
	train_next();
};

void() train_wait =
{
	if (self.wait)
	{
		self.nextthink = self.ltime + self.wait;
		sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	}
	else
		self.nextthink = self.ltime + 0.1;
	
	self.think = train_next;
};

void() train_next =
{
	local entity	targ;

	targ = find (world, targetname, self.target);
	self.target = targ.target;
	if (!self.target)
		objerror ("train_next: no next target");
	if (targ.wait)
		self.wait = targ.wait;
	else
		self.wait = 0;
	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	SUB_CalcMove (targ.origin - self.mins, self.speed, train_wait);
};

void() func_train_find =

{
	local entity	targ;

	targ = find (world, targetname, self.target);
	self.target = targ.target;
	setorigin (self, targ.origin - self.mins);
	if (!self.targetname)
	{	// not triggered, so start immediately
		self.nextthink = self.ltime + 0.1;
		self.think = train_next;
	}
};

/*QUAKED func_train (0 .5 .8) ?
Trains are moving platforms that players can ride.
The targets origin specifies the min point of the train at each corner.
The train spawns at the first target it is pointing at.
If the train is the target of a button or trigger, it will not begin moving until activated.
speed	default 100
dmg		default	2
sounds
1) ratchet metal

*/
void() func_train =
{	
	if (!self.speed)
		self.speed = 100;
	if (!self.target)
		objerror ("func_train without a target");
	if (!self.dmg)
		self.dmg = 2;

	if (self.sounds == 0)
	{
		self.noise = ("misc/null.wav");
		precache_sound ("misc/null.wav");
		self.noise1 = ("misc/null.wav");
		precache_sound ("misc/null.wav");
	}

	if (self.sounds == 1)
	{
		self.noise = ("plats/train2.wav");
		precache_sound ("plats/train2.wav");
		self.noise1 = ("plats/train1.wav");
		precache_sound ("plats/train1.wav");
	}

	self.cnt = 1;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	self.blocked = train_blocked;
	self.use = train_use;
	self.classname = "train";

	setmodel (self, self.model);
	setsize (self, self.mins , self.maxs);
	setorigin (self, self.origin);

// start trains on the second frame, to make sure their targets have had
// a chance to spawn
	self.nextthink = self.ltime + 0.1;
	self.think = func_train_find;
};

/*QUAKED misc_teleporttrain (0 .5 .8) (-8 -8 -8) (8 8 8)
This is used for the final bos
*/
void() misc_teleporttrain =
{	
	if (!self.speed)
		self.speed = 100;
	if (!self.target)
		objerror ("func_train without a target");

	self.cnt = 1;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_PUSH;
	self.blocked = train_blocked;
	self.use = train_use;
	self.avelocity = '100 200 300';

	self.noise = ("misc/null.wav");
	precache_sound ("misc/null.wav");
	self.noise1 = ("misc/null.wav");
	precache_sound ("misc/null.wav");

	precache_model2 ("progs/teleport.mdl");
	setmodel (self, "progs/teleport.mdl");
	setsize (self, self.mins , self.maxs);
	setorigin (self, self.origin);

// start trains on the second frame, to make sure their targets have had
// a chance to spawn
	self.nextthink = self.ltime + 0.1;
	self.think = func_train_find;
};

//============================================================================
//
//	TEMPORAL CORTEX TRAINS
//
//============================================================================

void() tracktrain_find;
void() tracktrain_next;

const float SF_TRACKTRAIN_NO_PITCH = 1;
const float SF_TRACKTRAIN_FIXED_ORIENTATION = 2;
const float SF_TRACKTRAIN_UNBLOCKABLE = 4;

.vector goalangle;

void() tracktrain_blocked =
{
	if (time < self.attack_finished)
		return;
	self.attack_finished = time + 0.5;
	T_Damage (other, self, self, self.dmg);
};

void() tracktrain_use =
{
	if (self.think != tracktrain_find)
		return;		// already activated

	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM, 100, SOUNDFLAG_FOLLOW);

	tracktrain_next();
};

void() tracktrain_wait =
{
	if (self.wait)
	{
		self.nextthink = self.ltime + self.wait;
		sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM, 100, SOUNDFLAG_FOLLOW);
	}
	else
		self.nextthink = self.ltime + frametime;

	self.think = tracktrain_next;
};

void() tracktrain_adjust_angle =
{
	local float td;
	local float dot;

	makevectors(self.angles);

	vectorvectors(self.goalentity.origin - self.origin);
	dot = dotproduct(v_forward, v_right);

	if (!(self.spawnflags & SF_TRACKTRAIN_FIXED_ORIENTATION))
	{
		td = time - self.starttime;
		self.starttime = time;

		if (self.style == 0)	// Missi: Instantly at path_corner entities (2026.1.24)
		{
			self.angles = self.goalangle;
		}
		if (self.style == 1)	// Missi: Linear blend (2026.1.24)
		{
			self.angles += v_right * dot;
		}

		if (self.spawnflags & SF_TRACKTRAIN_NO_PITCH)
			self.angles_x = 0;
		else
			self.angles_x = self.angles_x * -1;

		dprint("dist(\"");
		dprint(self.targetname);
		dprint("\"): ");
		dprint(ftos(dot));
		dprint("\n");
		dprint("self.angles: ");
		dprint(vtos(self.angles));
		dprint("\n");
	}

	self.nextthink = self.ltime + frametime;
};

void() tracktrain_next =
{
	local entity targ, targ2, killtarg, temp;

	targ = find (world, targetname, self.target);

	if (!targ)
		return;

	targ2 = find (world, targetname, targ.target);

	self.goalentity = targ;

	if (!self.target)
		objerror ("train_next: no next target");

	if (targ.wait)
		self.wait = targ.wait;
	else
		self.wait = 0;

	sound (self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);

	//dprint("Tracktrain target: ");
	//dprint(self.target);
	//dprint("\n");

	SUB_CalcMove (self.goalentity.origin, self.speed, tracktrain_wait);
};

void() tracktrain_find =
{
	local entity	targ, targ2;

	targ = find (world, targetname, self.target);
	targ2 = find (world, targetname, targ.target);

	setorigin (self, targ.origin);

	self.goalentity = targ2;

	dprint("tracktrain_find: found target named ");
	dprint(targ.targetname);
	dprint(" at ");
	dprint(vtos(targ.origin));
	dprint("\n");

	if (!self.targetname)
	{	// not triggered, so start immediately
		self.nextthink = self.ltime + 0.1;
		self.think = tracktrain_next;

		sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM, 100, SOUNDFLAG_FOLLOW);
	}
};

float(entity toplayer, float fl) SendPlat =
{
	vector v;

	if (self.source == VEC_ORIGIN)
		self.source = self.origin;

	v = self.source + self.velocity*(time-self.starttime);

	WriteByte (MSG_ENTITY, CLASS_PLAT);
	WriteLong (MSG_ENTITY, fl);

	if (fl & SENDFLAG_ORIGIN)
	{
		WriteCoord (MSG_ENTITY, v_x);
		WriteCoord (MSG_ENTITY, v_y);
		WriteCoord (MSG_ENTITY, v_z);
	}
	if (fl & SENDFLAG_ANGLES)
	{
		WriteShort (MSG_ENTITY, self.angles_x*(256/360));
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

	WriteEntity (MSG_ENTITY, self);

	return TRUE;
};

/*QUAKED func_tracktrain (0.0 0.5 0.8) ? no_pitch fixed_orientation unblockable
{
choice "sounds"
 (
  (0,"no sound")
  (1,"ratchet metal")
 );
}
Trains are moving platforms that players can ride.
The targets origin specifies the min point of the train at each corner.
The train spawns at the first target it is pointing at.
If the train is the target of a button or trigger, it will not begin moving until activated.
"speed"		default 100
"dmg"		default	2
"sounds"	sound played
*/
void() func_tracktrain =
{
	if (!self.speed)
		self.speed = 100;
	if (!self.target)
		objerror ("func_tracktrain without a target");

	if (self.noise)
	{
		precache_sound(self.noise);
	}
	if (self.noise1)
	{
		precache_sound(self.noise1);
	}

	self.cnt = 1;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	self.blocked = tracktrain_blocked;
	self.use = tracktrain_use;

	setmodel (self, self.model);
	setorigin (self, self.origin);

	if (!self.style)
		self.style = 0;

	self.starttime = time;

// start trains on the second frame, to make sure their targets have had
// a chance to spawn
	self.nextthink = self.ltime + 0.1;
	self.think = tracktrain_find;

	//self.SendEntity = SendPlat;
	//self.SendFlags = FULLSEND;
};

/*QUAKED path_track (1 0.5 0) (-8 -8 -8) (8 8 8)
For func_tracktrain only.
*/
void() path_track =
{
	movetrack_f ();
};
















