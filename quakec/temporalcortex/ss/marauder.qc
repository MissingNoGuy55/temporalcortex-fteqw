/*
==============================================================================

TEMPORAL CORTEX TIME HUNTER

==============================================================================
*/

$cd id1/models/soldier3
$origin 0 -6 24
$base base		
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10

$frame deathc1 deathc2 deathc3 deathc4 deathc5 deathc6 deathc7 deathc8
$frame deathc9 deathc10 deathc11

$frame load1 load2 load3 load4 load5 load6 load7 load8 load9 load10 load11

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10
$frame painb11 painb12 painb13 painb14

$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8 painc9 painc10
$frame painc11 painc12 painc13

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame shoot1 shoot2 shoot3 shoot4 shoot5 shoot6 shoot7 shoot8 shoot9

$frame prowl_1 prowl_2 prowl_3 prowl_4 prowl_5 prowl_6 prowl_7 prowl_8
$frame prowl_9 prowl_10 prowl_11 prowl_12 prowl_13 prowl_14 prowl_15 prowl_16
$frame prowl_17 prowl_18 prowl_19 prowl_20 prowl_21 prowl_22 prowl_23 prowl_24

#if 0
#include "../cs/playerframes.inc"
float(float f) mapsoldieframetoplayer =
{
	switch(f)
	{
	case $stand1 .. $stand8 :
		return playerframe::stand1;
	case $death1 .. $deathc11 :
		return playerframe::deatha1;
	case $load1 .. $load11 :
		return 0;	//never used!
	case $death1 .. $deathc11 :
		return playerframe::deatha1;
	case $pain1 .. $painc13 :
		return playerframe::pain1;
	case $prowl_1 .. $prowl_24 :
	case $run1 .. $run8 :
		return playerframe::rockrun1;
	case $shoot1 .. $shoot9 :
		return playerframe::shotatt1;
	}
	return f;
};

/*
float(entity to, float fl) SendSoldier =
{
	WriteByte(MSG_ENTITY, CLASS_PLAYER);
	WriteByte(MSG_ENTITY, mapsoldieframetoplayer (self.frame));	//for clientside animation selection, in a way compatable with not having csqc.
	WriteByte(MSG_ENTITY, self.angles_x*(256/360));
	WriteByte(MSG_ENTITY, self.angles_y*(256/360));
	WriteCoord(MSG_ENTITY, self.origin_x);
	WriteCoord(MSG_ENTITY, self.origin_y);
	WriteCoord(MSG_ENTITY, self.origin_z);
	WriteShort(MSG_ENTITY, self.velocity_x*64);
	WriteShort(MSG_ENTITY, self.velocity_y*64);
	WriteShort(MSG_ENTITY, self.velocity_z*64);
	WriteByte(MSG_ENTITY, 0);

	return TRUE;
};
*/
#endif
/*
==============================================================================
SOLDIER CODE
==============================================================================
*/

void() timehunter_fire;
void() timehunter_cloak_check;

void()	timehunter_stand1	=[	$stand1,	timehunter_stand2	] {ai_stand();};
void()	timehunter_stand2	=[	$stand2,	timehunter_stand3	] {ai_stand();};
void()	timehunter_stand3	=[	$stand3,	timehunter_stand4	] {ai_stand();};
void()	timehunter_stand4	=[	$stand4,	timehunter_stand5	] {ai_stand();};
void()	timehunter_stand5	=[	$stand5,	timehunter_stand6	] {ai_stand();};
void()	timehunter_stand6	=[	$stand6,	timehunter_stand7	] {ai_stand();};
void()	timehunter_stand7	=[	$stand7,	timehunter_stand8	] {ai_stand();};
void()	timehunter_stand8	=[	$stand8,	timehunter_stand1	] {ai_stand();timehunter_cloak_check();};

void()	timehunter_walk1	=[	$prowl_1,	timehunter_walk2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_IDLE);
ai_walk(1);};
void()	timehunter_walk2	=[	$prowl_2,	timehunter_walk3	] {ai_walk(1);};
void()	timehunter_walk3	=[	$prowl_3,	timehunter_walk4	] {ai_walk(1);};
void()	timehunter_walk4	=[	$prowl_4,	timehunter_walk5	] {ai_walk(1);};
void()	timehunter_walk5	=[	$prowl_5,	timehunter_walk6	] {ai_walk(2);};
void()	timehunter_walk6	=[	$prowl_6,	timehunter_walk7	] {ai_walk(3);};
void()	timehunter_walk7	=[	$prowl_7,	timehunter_walk8	] {ai_walk(4);};
void()	timehunter_walk8	=[	$prowl_8,	timehunter_walk9	] {ai_walk(4);};
void()	timehunter_walk9	=[	$prowl_9,	timehunter_walk10	] {ai_walk(2);};
void()	timehunter_walk10	=[	$prowl_10,	timehunter_walk11	] {ai_walk(2);};
void()	timehunter_walk11	=[	$prowl_11,	timehunter_walk12	] {ai_walk(2);};
void()	timehunter_walk12	=[	$prowl_12,	timehunter_walk13	] {ai_walk(1);};
void()	timehunter_walk13	=[	$prowl_13,	timehunter_walk14	] {ai_walk(0);};
void()	timehunter_walk14	=[	$prowl_14,	timehunter_walk15	] {ai_walk(1);};
void()	timehunter_walk15	=[	$prowl_15,	timehunter_walk16	] {ai_walk(1);};
void()	timehunter_walk16	=[	$prowl_16,	timehunter_walk17	] {ai_walk(1);};
void()	timehunter_walk17	=[	$prowl_17,	timehunter_walk18	] {ai_walk(3);};
void()	timehunter_walk18	=[	$prowl_18,	timehunter_walk19	] {ai_walk(3);};
void()	timehunter_walk19	=[	$prowl_19,	timehunter_walk20	] {ai_walk(3);};
void()	timehunter_walk20	=[	$prowl_20,	timehunter_walk21	] {ai_walk(3);};
void()	timehunter_walk21	=[	$prowl_21,	timehunter_walk22	] {ai_walk(2);};
void()	timehunter_walk22	=[	$prowl_22,	timehunter_walk23	] {ai_walk(1);};
void()	timehunter_walk23	=[	$prowl_23,	timehunter_walk24	] {ai_walk(1);};
void()	timehunter_walk24	=[	$prowl_24,	timehunter_walk1	] {ai_walk(1);timehunter_cloak_check();};

void()	timehunter_run1	=[	$run1,		timehunter_run2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_IDLE);
ai_run(11);};
void()	timehunter_run2	=[	$run2,		timehunter_run3	] {ai_run(15);};
void()	timehunter_run3	=[	$run3,		timehunter_run4	] {ai_run(10);};
void()	timehunter_run4	=[	$run4,		timehunter_run5	] {ai_run(10);};
void()	timehunter_run5	=[	$run5,		timehunter_run6	] {ai_run(8);};
void()	timehunter_run6	=[	$run6,		timehunter_run7	] {ai_run(15);};
void()	timehunter_run7	=[	$run7,		timehunter_run8	] {ai_run(10);};
void()	timehunter_run8	=[	$run8,		timehunter_run1	] {ai_run(8);timehunter_cloak_check();};

void()	timehunter_atk1	=[	$shoot1,	timehunter_atk2	] {ai_face();timehunter_cloak_check();};
void()	timehunter_atk2	=[	$shoot2,	timehunter_atk3	] {ai_face();};
void()	timehunter_atk3	=[	$shoot3,	timehunter_atk4	] {ai_face();};
void()	timehunter_atk4	=[	$shoot4,	timehunter_atk5	] {ai_face();};
void()	timehunter_atk5	=[	$shoot5,	timehunter_atk6	] {ai_face();timehunter_fire();
self.effects = self.effects | EF_MUZZLEFLASH;};
void()	timehunter_atk6	=[	$shoot6,	timehunter_atk7	] {ai_face();};
void()	timehunter_atk7	=[	$shoot7,	timehunter_atk8	] {ai_face();SUB_CheckRefire (timehunter_atk1);};
void()	timehunter_atk8	=[	$shoot8,	timehunter_atk9	] {ai_face();};
void()	timehunter_atk9	=[	$shoot9,	timehunter_run1	] {ai_face();};


void()	timehunter_pain1	=[	$pain1,		timehunter_pain2	] {timehunter_cloak_check();};
void()	timehunter_pain2	=[	$pain2,		timehunter_pain3	] {};
void()	timehunter_pain3	=[	$pain3,		timehunter_pain4	] {};
void()	timehunter_pain4	=[	$pain4,		timehunter_pain5	] {};
void()	timehunter_pain5	=[	$pain5,		timehunter_pain6	] {};
void()	timehunter_pain6	=[	$pain6,		timehunter_run1	] {ai_pain(1);};

void()	timehunter_painb1	=[	$painb1,	timehunter_painb2	] {timehunter_cloak_check();};
void()	timehunter_painb2	=[	$painb2,	timehunter_painb3	] {ai_painforward(13);};
void()	timehunter_painb3	=[	$painb3,	timehunter_painb4	] {ai_painforward(9);};
void()	timehunter_painb4	=[	$painb4,	timehunter_painb5	] {};
void()	timehunter_painb5	=[	$painb5,	timehunter_painb6	] {};
void()	timehunter_painb6	=[	$painb6,	timehunter_painb7	] {};
void()	timehunter_painb7	=[	$painb7,	timehunter_painb8	] {};
void()	timehunter_painb8	=[	$painb8,	timehunter_painb9	] {};
void()	timehunter_painb9	=[	$painb9,	timehunter_painb10] {};
void()	timehunter_painb10=[	$painb10,	timehunter_painb11] {};
void()	timehunter_painb11=[	$painb11,	timehunter_painb12] {};
void()	timehunter_painb12=[	$painb12,	timehunter_painb13] {ai_pain(2);};
void()	timehunter_painb13=[	$painb13,	timehunter_painb14] {};
void()	timehunter_painb14=[	$painb14,	timehunter_run1	] {};

void()	timehunter_painc1	=[	$painc1,	timehunter_painc2	] {timehunter_cloak_check();};
void()	timehunter_painc2	=[	$painc2,	timehunter_painc3	] {ai_pain(1);};
void()	timehunter_painc3	=[	$painc3,	timehunter_painc4	] {};
void()	timehunter_painc4	=[	$painc4,	timehunter_painc5	] {};
void()	timehunter_painc5	=[	$painc5,	timehunter_painc6	] {ai_painforward(1);};
void()	timehunter_painc6	=[	$painc6,	timehunter_painc7	] {ai_painforward(1);};
void()	timehunter_painc7	=[	$painc7,	timehunter_painc8	] {};
void()	timehunter_painc8	=[	$painc8,	timehunter_painc9	] {ai_pain(1);};
void()	timehunter_painc9	=[	$painc9,	timehunter_painc10] {ai_painforward(4);};
void()	timehunter_painc10=[	$painc10,	timehunter_painc11] {ai_painforward(3);};
void()	timehunter_painc11=[	$painc11,	timehunter_painc12] {ai_painforward(6);};
void()	timehunter_painc12=[	$painc12,	timehunter_painc13] {ai_painforward(8);};
void()	timehunter_painc13=[	$painc13,	timehunter_run1] {};

float SF_GRENADIER_RAPIDFIRE = 2;

void() timehunter_fire =
{
	local	vector	dir;
	local	entity	en;
	local	float damage;
	local	vector spread;

	damage = cvar("tc_sv_timehunter_damage");

	spread_x = cvar("tc_sv_timehunter_accuracy_x");
	spread_y = cvar("tc_sv_timehunter_accuracy_y");
	spread_z = cvar("tc_sv_timehunter_accuracy_z");

	if (!damage)
		damage = 6;

	if (!spread_x)
		spread_x = 0.05;
	if (!spread_y)
		spread_y = 0.05;
	if (!spread_z)
		spread_z = 0.0;

	ai_face();

	sound (self, CHAN_WEAPON, "soldier/sattck1.wav", 1, ATTN_NORM);

// fire somewhat behind the player, so a dodging player is harder to hit
	en = self.enemy;

	dir = en.origin - en.velocity*0.2;
	dir = normalize (dir - self.origin);

	traceline( self.origin, ( self.origin + dir ) * 200, FALSE, self );

	if ( cvar( "tc_sv_hitscan" ) == 0 )
		FireBullets_NoHitScan (damage, TC_AMMO_5_56x45MM, cvar("tc_sv_ammo_556x45mm_speed"), 1, dir, spread);
	else
		FireBullets( 1, dir, spread );
};

void()	timehunter_charge1	=[	$run1,		timehunter_charge2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_IDLE);
ai_run(11);};
void()	timehunter_charge2		=	[	$run2,		timehunter_charge3		] {ai_run(15*2);timehunter_cloak_check();};
void()	timehunter_charge3		=	[	$run3,		timehunter_charge4		] {ai_run(10*2);};
void()	timehunter_charge4		=	[	$run4,		timehunter_charge5		] {ai_run(10*2);};
void()	timehunter_charge5		=	[	$run5,		timehunter_charge6		] {ai_run(8*2);};
void()	timehunter_charge6		=	[	$run6,		timehunter_charge7		] {ai_run(15*2);};
void()	timehunter_charge7		=	[	$run7,		timehunter_charge8		] {ai_run(10*2);};
void()	timehunter_charge8		=	[	$run8,		timehunter_charge1		] {ai_run(8*2);};

void()	timehunter_rapidfire1		=	[	$shoot1,	timehunter_rapidfire2		] {ai_face();timehunter_cloak_check();};
void()	timehunter_rapidfire2		=	[	$shoot2,	timehunter_rapidfire3		] {ai_face();};
void()	timehunter_rapidfire3		=	[	$shoot3,	timehunter_rapidfire4		] {ai_face();};
void()	timehunter_rapidfire4		=	[	$shoot4,	timehunter_rapidfire5		] {ai_face();};
void()	timehunter_rapidfire5		=	[	$shoot5,	timehunter_rapidfire6		] {ai_face();timehunter_fire();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	timehunter_rapidfire6		=	[	$shoot5,	timehunter_rapidfire7		] {ai_face();timehunter_fire();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	timehunter_rapidfire7		=	[	$shoot5,	timehunter_rapidfire8		] {ai_face();timehunter_fire();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	timehunter_rapidfire8		=	[	$shoot5,	timehunter_rapidfire9		] {ai_face();timehunter_fire();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	timehunter_rapidfire9		=	[	$shoot5,	timehunter_rapidfire10	] {ai_face();timehunter_fire();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	timehunter_rapidfire10	=	[	$shoot5,	timehunter_rapidfire11	] {ai_face();timehunter_fire();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	timehunter_rapidfire11	=	[	$shoot5,	timehunter_rapidfire12	] {ai_face();timehunter_fire();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	timehunter_rapidfire12	=	[	$shoot5,	timehunter_rapidfire13	] {ai_face();timehunter_fire();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	timehunter_rapidfire13	=	[	$shoot5,	timehunter_rapidfire14	] {ai_face();timehunter_fire();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	timehunter_rapidfire14	=	[	$shoot5,	timehunter_rapidfire15	] {ai_face();timehunter_fire();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	timehunter_rapidfire15	=	[	$shoot5,	timehunter_rapidfire16	] {ai_face();timehunter_fire();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	timehunter_rapidfire16	=	[	$shoot5,	timehunter_rapidfire17	] {ai_face();timehunter_fire();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	timehunter_rapidfire17	=	[	$shoot5,	timehunter_rapidfire18	] {ai_face();timehunter_fire();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	timehunter_rapidfire18	=	[	$shoot6,	timehunter_rapidfire19	] {ai_face();};
void()	timehunter_rapidfire19	=	[	$shoot7,	timehunter_rapidfire20	] {ai_face();SUB_CheckRefire (timehunter_rapidfire1);};
void()	timehunter_rapidfire20	=	[	$shoot8,	timehunter_rapidfire21	] {ai_face();};
void()	timehunter_rapidfire21	=	[	$shoot9,	timehunter_run1			] {ai_face();};

//==============================================================================

void(entity attacker, float damage)	timehunter_pain =
{
	local float r;
	
	if (self.pain_finished > time)
		return;

	r = random();

	if (r < 0.2)
	{
		self.pain_finished = time + 0.6;
		timehunter_pain1 ();
		sound (self, CHAN_VOICE, "soldier/pain1.wav", 1, ATTN_NORM);
	}
	else if (r < 0.6)
	{
		self.pain_finished = time + 1.1;
		timehunter_painb1 ();
		sound (self, CHAN_VOICE, "soldier/pain2.wav", 1, ATTN_NORM);
	}
	else
	{
		self.pain_finished = time + 1.1;
		timehunter_painc1 ();
		sound (self, CHAN_VOICE, "soldier/pain2.wav", 1, ATTN_NORM);
	}
};

void()	timehunter_die1	=[	$death1,	timehunter_die2	] {};
void()	timehunter_die2	=[	$death2,	timehunter_die3	] {};
void()	timehunter_die3	=[	$death3,	timehunter_die4	]
{
	self.solid = SOLID_NOT;
	self.ammo_shells = 5;
	DropBackpack();
};
void()	timehunter_die4	=[	$death4,	timehunter_die5	] {};
void()	timehunter_die5	=[	$death5,	timehunter_die6	] {};
void()	timehunter_die6	=[	$death6,	timehunter_die7	] {};
void()	timehunter_die7	=[	$death7,	timehunter_die8	] {};
void()	timehunter_die8	=[	$death8,	timehunter_die9	] {};
void()	timehunter_die9	=[	$death9,	timehunter_die10	] {};
void()	timehunter_die10	=[	$death10,	timehunter_die10	] {};

void()	timehunter_cdie1	=[	$deathc1,	timehunter_cdie2	] {};
void()	timehunter_cdie2	=[	$deathc2,	timehunter_cdie3	] {ai_back(5);};
void()	timehunter_cdie3	=[	$deathc3,	timehunter_cdie4	]
{
	self.solid = SOLID_NOT;
	self.ammo_shells = 5;
	DropBackpack();
	ai_back(4);
};
void()	timehunter_cdie4	=[	$deathc4,	timehunter_cdie5	] {ai_back(13);};
void()	timehunter_cdie5	=[	$deathc5,	timehunter_cdie6	] {ai_back(3);};
void()	timehunter_cdie6	=[	$deathc6,	timehunter_cdie7	] {ai_back(4);};
void()	timehunter_cdie7	=[	$deathc7,	timehunter_cdie8	] {};
void()	timehunter_cdie8	=[	$deathc8,	timehunter_cdie9	] {};
void()	timehunter_cdie9	=[	$deathc9,	timehunter_cdie10	] {};
void()	timehunter_cdie10	=[	$deathc10,	timehunter_cdie11	] {};
void()	timehunter_cdie11	=[	$deathc11,	timehunter_cdie11	] {};


void() timehunter_die =
{
// check for gib
	if (self.health < -35)
	{
		ThrowCSQCGibs(GIB_SOLDIER);
		return;
	}

// regular death
	sound (self, CHAN_VOICE, "soldier/death1.wav", 1, ATTN_NORM);
	if (random() < 0.5)
		timehunter_die1 ();
	else
		timehunter_cdie1 ();
};

.float timehunter_uncloak;
.string timehunter_oldmodel;
.float disttoplayer;

void() timehunter_cloak_check =
{
	local vector dist;
	local float distnorm;
	local float timeperiod;
	local float worldtimeperiod;
	local float targettimeperiod;

	if (self.enemy)
	{
		dist = self.enemy.origin - self.origin;
		distnorm = vlen(dist);

		if (distnorm < 512)
			self.timehunter_uncloak = 1;
	}

	if (self.timehunter_uncloak)
	{
		spawn_tfog (self.origin + '0 0 24');
		self.model = self.timehunter_oldmodel;
		self.th_missile = timehunter_rapidfire1;
		self.timehunter_uncloak = 0;
		timeperiod_change_ent(self, getworldtimeperiod());
		//self.solid = SOLID_SLIDEBOX;
	}
	else
	{
		timeperiod = getentitytimeperiod(self);
		worldtimeperiod = getworldtimeperiod();

		if (timeperiod == worldtimeperiod)
		{
			if (worldtimeperiod > 1)
				targettimeperiod = worldtimeperiod - 1;
			else
				targettimeperiod = worldtimeperiod + 1;

			//dprint("Marauder changing to time period ");
			//dprint(ftos(targettimeperiod));
			//dprint("\n");

			timeperiod_change_ent(self, targettimeperiod);
			self.th_missile = SUB_Null;
			//self.solid = SOLID_NOT;
		}
	}
};

void() timehunter_telefrag_think =
{
	if (pointcontents(self.origin + '0 0 16') != CONTENT_EMPTY)
		spawn_tdeath(self.origin, world);

	self.nextthink = time + 0.1;
};

/*QUAKED monster_timehunter (1 0 0) (-16 -16 -24) (16 16 40) Ambush
Monster that is aware of the player time travel ability and can cross
time periods to hunt them.
*/
void() monster_timehunter =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/soldier.mdl");
	precache_model ("progs/h_guard.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");

	precache_sound ("soldier/death1.wav");
	precache_sound ("soldier/idle.wav");
	precache_sound ("soldier/pain1.wav");
	precache_sound ("soldier/pain2.wav");
	precache_sound ("soldier/sattck1.wav");
	precache_sound ("soldier/sight1.wav");

	precache_sound ("player/udeath.wav");		// gib death


	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/soldier.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 30;

	self.th_stand = timehunter_stand1;
	self.th_walk = timehunter_walk1;
	self.th_run = timehunter_charge1;
	self.th_missile = timehunter_rapidfire1;
	self.th_pain = timehunter_pain;
	self.th_die = timehunter_die;

	self.think = timehunter_telefrag_think;
	self.nextthink = time + 0.1;

	self.relationship_group = RELATION_MILITARY_PRESENT + self.timeperiod;

	if (self.timeperiod == 0)
	{
		self.relationship_group_like = RELATION_MILITARY_PRESENT_LIKE;
		self.relationship_group_hate = RELATION_MILITARY_PRESENT_HATE;
		self.relationship_group_fear = RELATION_MILITARY_PRESENT_FEAR;
		self.relationship_group_neutral = RELATION_MILITARY_PRESENT_NEUTRAL;
	}
	else if (self.timeperiod == 1)
	{
		self.relationship_group_like = RELATION_MILITARY_PAST_LIKE;
		self.relationship_group_hate = RELATION_MILITARY_PAST_HATE;
		self.relationship_group_fear = RELATION_MILITARY_PAST_FEAR;
		self.relationship_group_neutral = RELATION_MILITARY_PAST_NEUTRAL;
	}
	else if (self.timeperiod == 2)
	{
		self.relationship_group_like = RELATION_MILITARY_FUTURE_LIKE;
		self.relationship_group_hate = RELATION_MILITARY_FUTURE_HATE;
		self.relationship_group_fear = RELATION_MILITARY_FUTURE_FEAR;
		self.relationship_group_neutral = RELATION_MILITARY_FUTURE_NEUTRAL;
	}
	else
	{
		self.relationship_group_like = RELATION_MILITARY_PRESENT_LIKE;
		self.relationship_group_hate = RELATION_MILITARY_PRESENT_HATE;
		self.relationship_group_fear = RELATION_MILITARY_PRESENT_FEAR;
		self.relationship_group_neutral = RELATION_MILITARY_PRESENT_NEUTRAL;
	}

	self.flags = self.flags | FL_OMNIPRESENT;
	self.timehunter_uncloak = 0;
	self.timehunter_oldmodel = self.model;

	walkmonster_start ();
};

