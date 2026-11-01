/*
==============================================================================

SOLDIER / PLAYER

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

void() army_fire;

void()	army_stand1	=[	$stand1,	army_stand2	] {ai_stand();};
void()	army_stand2	=[	$stand2,	army_stand3	] {ai_stand();};
void()	army_stand3	=[	$stand3,	army_stand4	] {ai_stand();};
void()	army_stand4	=[	$stand4,	army_stand5	] {ai_stand();};
void()	army_stand5	=[	$stand5,	army_stand6	] {ai_stand();};
void()	army_stand6	=[	$stand6,	army_stand7	] {ai_stand();};
void()	army_stand7	=[	$stand7,	army_stand8	] {ai_stand();};
void()	army_stand8	=[	$stand8,	army_stand1	] {ai_stand();};

void()	army_walk1	=[	$prowl_1,	army_walk2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_IDLE);
ai_walk(1);};
void()	army_walk2	=[	$prowl_2,	army_walk3	] {ai_walk(1);};
void()	army_walk3	=[	$prowl_3,	army_walk4	] {ai_walk(1);};
void()	army_walk4	=[	$prowl_4,	army_walk5	] {ai_walk(1);};
void()	army_walk5	=[	$prowl_5,	army_walk6	] {ai_walk(2);};
void()	army_walk6	=[	$prowl_6,	army_walk7	] {ai_walk(3);};
void()	army_walk7	=[	$prowl_7,	army_walk8	] {ai_walk(4);};
void()	army_walk8	=[	$prowl_8,	army_walk9	] {ai_walk(4);};
void()	army_walk9	=[	$prowl_9,	army_walk10	] {ai_walk(2);};
void()	army_walk10	=[	$prowl_10,	army_walk11	] {ai_walk(2);};
void()	army_walk11	=[	$prowl_11,	army_walk12	] {ai_walk(2);};
void()	army_walk12	=[	$prowl_12,	army_walk13	] {ai_walk(1);};
void()	army_walk13	=[	$prowl_13,	army_walk14	] {ai_walk(0);};
void()	army_walk14	=[	$prowl_14,	army_walk15	] {ai_walk(1);};
void()	army_walk15	=[	$prowl_15,	army_walk16	] {ai_walk(1);};
void()	army_walk16	=[	$prowl_16,	army_walk17	] {ai_walk(1);};
void()	army_walk17	=[	$prowl_17,	army_walk18	] {ai_walk(3);};
void()	army_walk18	=[	$prowl_18,	army_walk19	] {ai_walk(3);};
void()	army_walk19	=[	$prowl_19,	army_walk20	] {ai_walk(3);};
void()	army_walk20	=[	$prowl_20,	army_walk21	] {ai_walk(3);};
void()	army_walk21	=[	$prowl_21,	army_walk22	] {ai_walk(2);};
void()	army_walk22	=[	$prowl_22,	army_walk23	] {ai_walk(1);};
void()	army_walk23	=[	$prowl_23,	army_walk24	] {ai_walk(1);};
void()	army_walk24	=[	$prowl_24,	army_walk1	] {ai_walk(1);};

void()	army_run1	=[	$run1,		army_run2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_IDLE);
ai_run(11);};
void()	army_run2	=[	$run2,		army_run3	] {ai_run(15);};
void()	army_run3	=[	$run3,		army_run4	] {ai_run(10);};
void()	army_run4	=[	$run4,		army_run5	] {ai_run(10);};
void()	army_run5	=[	$run5,		army_run6	] {ai_run(8);};
void()	army_run6	=[	$run6,		army_run7	] {ai_run(15);};
void()	army_run7	=[	$run7,		army_run8	] {ai_run(10);};
void()	army_run8	=[	$run8,		army_run1	] {ai_run(8);};

void()	army_atk1	=[	$shoot1,	army_atk2	] {ai_face();};
void()	army_atk2	=[	$shoot2,	army_atk3	] {ai_face();};
void()	army_atk3	=[	$shoot3,	army_atk4	] {ai_face();};
void()	army_atk4	=[	$shoot4,	army_atk5	] {ai_face();};
void()	army_atk5	=[	$shoot5,	army_atk6	] {ai_face();army_fire();
self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_atk6	=[	$shoot6,	army_atk7	] {ai_face();};
void()	army_atk7	=[	$shoot7,	army_atk8	] {ai_face();SUB_CheckRefire (army_atk1);};
void()	army_atk8	=[	$shoot8,	army_atk9	] {ai_face();};
void()	army_atk9	=[	$shoot9,	army_run1	] {ai_face();};


void()	army_pain1	=[	$pain1,		army_pain2	] {};
void()	army_pain2	=[	$pain2,		army_pain3	] {};
void()	army_pain3	=[	$pain3,		army_pain4	] {};
void()	army_pain4	=[	$pain4,		army_pain5	] {};
void()	army_pain5	=[	$pain5,		army_pain6	] {};
void()	army_pain6	=[	$pain6,		army_run1	] {ai_pain(1);};

void()	army_painb1	=[	$painb1,	army_painb2	] {};
void()	army_painb2	=[	$painb2,	army_painb3	] {ai_painforward(13);};
void()	army_painb3	=[	$painb3,	army_painb4	] {ai_painforward(9);};
void()	army_painb4	=[	$painb4,	army_painb5	] {};
void()	army_painb5	=[	$painb5,	army_painb6	] {};
void()	army_painb6	=[	$painb6,	army_painb7	] {};
void()	army_painb7	=[	$painb7,	army_painb8	] {};
void()	army_painb8	=[	$painb8,	army_painb9	] {};
void()	army_painb9	=[	$painb9,	army_painb10] {};
void()	army_painb10=[	$painb10,	army_painb11] {};
void()	army_painb11=[	$painb11,	army_painb12] {};
void()	army_painb12=[	$painb12,	army_painb13] {ai_pain(2);};
void()	army_painb13=[	$painb13,	army_painb14] {};
void()	army_painb14=[	$painb14,	army_run1	] {};

void()	army_painc1	=[	$painc1,	army_painc2	] {};
void()	army_painc2	=[	$painc2,	army_painc3	] {ai_pain(1);};
void()	army_painc3	=[	$painc3,	army_painc4	] {};
void()	army_painc4	=[	$painc4,	army_painc5	] {};
void()	army_painc5	=[	$painc5,	army_painc6	] {ai_painforward(1);};
void()	army_painc6	=[	$painc6,	army_painc7	] {ai_painforward(1);};
void()	army_painc7	=[	$painc7,	army_painc8	] {};
void()	army_painc8	=[	$painc8,	army_painc9	] {ai_pain(1);};
void()	army_painc9	=[	$painc9,	army_painc10] {ai_painforward(4);};
void()	army_painc10=[	$painc10,	army_painc11] {ai_painforward(3);};
void()	army_painc11=[	$painc11,	army_painc12] {ai_painforward(6);};
void()	army_painc12=[	$painc12,	army_painc13] {ai_painforward(8);};
void()	army_painc13=[	$painc13,	army_run1] {};

/*
==============================================================================

TEMPORAL CORTEX ADDITIONS

==============================================================================
*/

float SF_GRENADIER_RAPIDFIRE = 2;

void() army_fire_gunner =
{
	local	vector	dir;
	local	entity	en;
	local	float damage;
	local	vector spread;

	damage = cvar("tc_sv_army_gunner_damage");

	spread_x = cvar("tc_sv_army_gunner_accuracy_x");
	spread_y = cvar("tc_sv_army_gunner_accuracy_y");
	spread_z = cvar("tc_sv_army_gunner_accuracy_z");

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
		FireBullets_NoHitScan (damage, AMMO_5_56x45MM, cvar("tc_sv_ammo_556x45mm_speed"), 1, dir, spread);
	else
		FireBullets( 1, dir, spread );
};

void() SoldierGrenadierGrenadeExplode =
{
	local entity targ;
	local float friendly;
	local float damage;

	friendly = FALSE;
	damage = cvar("tc_sv_army_grenadier_damage");

	if (damage)
		targ = findradius(self.origin, damage + 128);
	else
		targ = findradius(self.origin, 40);

	while (targ)
	{
		if (targ.relationship_group & self.owner.relationship_group_like)
		{
			friendly = TRUE;
			break;
		}

		targ = targ.chain;
	}

	if (!friendly)
	{
		if (damage)
			T_RadiusDamage (self, self.owner, damage, world);
		else
			T_RadiusDamage (self, self.owner, 40, world);

		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_EXPLOSION);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);

		BecomeExplosion ();
	}
	else
	{
		self.think = SUB_Remove;
		self.nextthink = time + 0.1;
	}
};

void() SoldierGrenadierGrenadeTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner
	if (other.takedamage == DAMAGE_AIM)
	{
		if ( other.relationship_group & self.owner.relationship_group_like )
			return;

		SoldierGrenadierGrenadeExplode();
		return;
	}
	sound (self, CHAN_VOICE, "weapons/bounce.wav", 1, ATTN_NORM);	// bounce sound
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};

void() army_fire_grenadier =
{
	local	entity missile;
	local	vector spread;

	self.effects = self.effects | EF_MUZZLEFLASH;

	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;

// set missile speed

	makevectors (self.angles);

	missile.velocity = normalize(self.enemy.origin - self.origin);
	missile.velocity = missile.velocity * 600;

	missile.velocity_z = 200;

	missile.avelocity = '300 300 300';

	if (self.spawnflags & SF_GRENADIER_RAPIDFIRE)
	{
		spread_x = cvar("tc_sv_army_grenadier_barrage_accuracy_x");
		spread_y = cvar("tc_sv_army_grenadier_barrage_accuracy_y");
		spread_z = cvar("tc_sv_army_grenadier_barrage_accuracy_z");
	}
	else
	{
		spread_x = cvar("tc_sv_army_grenadier_accuracy_x");
		spread_y = cvar("tc_sv_army_grenadier_accuracy_y");
		spread_z = cvar("tc_sv_army_grenadier_accuracy_z");
	}

	if ( spread_x || spread_y || spread_z )
		missile.velocity = missile.velocity + spread * 100;

	missile.angles = vectoangles(missile.velocity);

	missile.touch = SoldierGrenadierGrenadeTouch;

// set missile duration
	missile.nextthink = time + 2.5;
	missile.think = SoldierGrenadierGrenadeExplode;

	setmodel (missile, "progs/grenade.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, self.origin);
};

void() army_fire_rocketeer =
{
	local	entity missile;
	local	vector spread;

	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;

	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;

// set missile speed

	makevectors (self.angles);

	// Missi: Was using the aim function but it limits where non-player
	// rockets can shoot
	missile.velocity = normalize(self.enemy.origin - self.origin);
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);

	if (self.spawnflags & SF_GRENADIER_RAPIDFIRE)
	{
		spread_x = cvar("tc_sv_army_rocketeer_barrage_accuracy_x");
		spread_y = cvar("tc_sv_army_rocketeer_barrage_accuracy_y");
		spread_z = cvar("tc_sv_army_rocketeer_barrage_accuracy_z");
	}
	else
	{
		spread_x = cvar("tc_sv_army_rocketeer_accuracy_x");
		spread_y = cvar("tc_sv_army_rocketeer_accuracy_y");
		spread_z = cvar("tc_sv_army_rocketeer_accuracy_z");
	}

	if ( spread_x || spread_y || spread_z )
	{
		missile.velocity = missile.velocity + spread * 100;
		missile.angles = vectoangles(missile.velocity);
	}

	missile.touch = T_MissileTouch_FFCheck;

// set missile duration
	missile.nextthink = time + 5;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/missile.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, self.origin + v_forward*8 + '0 0 16');
};

void()	army_charge1	=[	$run1,		army_charge2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_IDLE);
ai_run(11);};
void()	army_charge2		=	[	$run2,		army_charge3		] {ai_run(15*2);};
void()	army_charge3		=	[	$run3,		army_charge4		] {ai_run(10*2);};
void()	army_charge4		=	[	$run4,		army_charge5		] {ai_run(10*2);};
void()	army_charge5		=	[	$run5,		army_charge6		] {ai_run(8*2);};
void()	army_charge6		=	[	$run6,		army_charge7		] {ai_run(15*2);};
void()	army_charge7		=	[	$run7,		army_charge8		] {ai_run(10*2);};
void()	army_charge8		=	[	$run8,		army_charge1		] {ai_run(8*2);};

void()	army_rapidfire1		=	[	$shoot1,	army_rapidfire2		] {ai_face();};
void()	army_rapidfire2		=	[	$shoot2,	army_rapidfire3		] {ai_face();};
void()	army_rapidfire3		=	[	$shoot3,	army_rapidfire4		] {ai_face();};
void()	army_rapidfire4		=	[	$shoot4,	army_rapidfire5		] {ai_face();};
void()	army_rapidfire5		=	[	$shoot5,	army_rapidfire6		] {ai_face();army_fire_gunner();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire6		=	[	$shoot5,	army_rapidfire7		] {ai_face();army_fire_gunner();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire7		=	[	$shoot5,	army_rapidfire8		] {ai_face();army_fire_gunner();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire8		=	[	$shoot5,	army_rapidfire9		] {ai_face();army_fire_gunner();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire9		=	[	$shoot5,	army_rapidfire10	] {ai_face();army_fire_gunner();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire10	=	[	$shoot5,	army_rapidfire11	] {ai_face();army_fire_gunner();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire11	=	[	$shoot5,	army_rapidfire12	] {ai_face();army_fire_gunner();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire12	=	[	$shoot5,	army_rapidfire13	] {ai_face();army_fire_gunner();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire13	=	[	$shoot5,	army_rapidfire14	] {ai_face();army_fire_gunner();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire14	=	[	$shoot5,	army_rapidfire15	] {ai_face();army_fire_gunner();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire15	=	[	$shoot5,	army_rapidfire16	] {ai_face();army_fire_gunner();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire16	=	[	$shoot5,	army_rapidfire17	] {ai_face();army_fire_gunner();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire17	=	[	$shoot5,	army_rapidfire18	] {ai_face();army_fire_gunner();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire18	=	[	$shoot6,	army_rapidfire19	] {ai_face();};
void()	army_rapidfire19	=	[	$shoot7,	army_rapidfire20	] {ai_face();SUB_CheckRefire (army_rapidfire1);};
void()	army_rapidfire20	=	[	$shoot8,	army_rapidfire21	] {ai_face();};
void()	army_rapidfire21	=	[	$shoot9,	army_run1			] {ai_face();};

void()	army_rapidfire_grenade1		=	[	$shoot1,	army_rapidfire_grenade2		] {ai_face();};
void()	army_rapidfire_grenade2		=	[	$shoot2,	army_rapidfire_grenade3		] {ai_face();};
void()	army_rapidfire_grenade3		=	[	$shoot3,	army_rapidfire_grenade4		] {ai_face();};
void()	army_rapidfire_grenade4		=	[	$shoot4,	army_rapidfire_grenade5		] {ai_face();};
void()	army_rapidfire_grenade5		=	[	$shoot5,	army_rapidfire_grenade6		] {ai_face();army_fire_grenadier();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire_grenade6		=	[	$shoot5,	army_rapidfire_grenade7		] {ai_face();army_fire_grenadier();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire_grenade7		=	[	$shoot5,	army_rapidfire_grenade8		] {ai_face();army_fire_grenadier();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire_grenade8		=	[	$shoot5,	army_rapidfire_grenade9		] {ai_face();army_fire_grenadier();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire_grenade9		=	[	$shoot5,	army_rapidfire_grenade10	] {ai_face();army_fire_grenadier();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire_grenade10	=	[	$shoot5,	army_rapidfire_grenade11	] {ai_face();army_fire_grenadier();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire_grenade11	=	[	$shoot5,	army_rapidfire_grenade12	] {ai_face();army_fire_grenadier();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire_grenade12	=	[	$shoot5,	army_rapidfire_grenade13	] {ai_face();army_fire_grenadier();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire_grenade13	=	[	$shoot5,	army_rapidfire_grenade14	] {ai_face();army_fire_grenadier();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire_grenade14	=	[	$shoot5,	army_rapidfire_grenade15	] {ai_face();army_fire_grenadier();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire_grenade15	=	[	$shoot5,	army_rapidfire_grenade16	] {ai_face();army_fire_grenadier();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire_grenade16	=	[	$shoot5,	army_rapidfire_grenade17	] {ai_face();army_fire_grenadier();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire_grenade17	=	[	$shoot5,	army_rapidfire_grenade18	] {ai_face();army_fire_grenadier();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire_grenade18	=	[	$shoot6,	army_rapidfire_grenade19	] {ai_face();};
void()	army_rapidfire_grenade19	=	[	$shoot7,	army_rapidfire_grenade20	] {ai_face();SUB_CheckRefire (army_rapidfire_grenade1);};
void()	army_rapidfire_grenade20	=	[	$shoot8,	army_rapidfire_grenade21	] {ai_face();};
void()	army_rapidfire_grenade21	=	[	$shoot9,	army_run1			] {ai_face();};

void()	army_firegrenade1	=	[	$shoot1,	army_firegrenade2	] {ai_face();};
void()	army_firegrenade2	=	[	$shoot2,	army_firegrenade3	] {ai_face();};
void()	army_firegrenade3	=	[	$shoot3,	army_firegrenade4	] {ai_face();};
void()	army_firegrenade4	=	[	$shoot4,	army_firegrenade5	] {ai_face();};
void()	army_firegrenade5	=	[	$shoot5,	army_firegrenade6	] {ai_face();army_fire_grenadier();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_firegrenade6	=	[	$shoot6,	army_firegrenade7	] {ai_face();};
void()	army_firegrenade7	=	[	$shoot7,	army_firegrenade8	] {ai_face();SUB_CheckRefire (army_firegrenade1);};
void()	army_firegrenade8	=	[	$shoot8,	army_firegrenade9	] {ai_face();};
void()	army_firegrenade9	=	[	$shoot9,	army_run1			] {ai_face();};

void()	army_rapidfire_rocket1	=	[	$shoot1,	army_rapidfire_rocket2		] {ai_face();};
void()	army_rapidfire_rocket2	=	[	$shoot2,	army_rapidfire_rocket3		] {ai_face();};
void()	army_rapidfire_rocket3	=	[	$shoot3,	army_rapidfire_rocket4		] {ai_face();};
void()	army_rapidfire_rocket4	=	[	$shoot4,	army_rapidfire_rocket5		] {ai_face();};
void()	army_rapidfire_rocket5	=	[	$shoot5,	army_rapidfire_rocket6		] {ai_face();army_fire_rocketeer();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire_rocket6	=	[	$shoot5,	army_rapidfire_rocket7		] {ai_face();army_fire_rocketeer();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire_rocket7	=	[	$shoot5,	army_rapidfire_rocket8		] {ai_face();army_fire_rocketeer();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire_rocket8	=	[	$shoot5,	army_rapidfire_rocket9		] {ai_face();army_fire_rocketeer();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire_rocket9	=	[	$shoot5,	army_rapidfire_rocket10		] {ai_face();army_fire_rocketeer();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire_rocket10	=	[	$shoot5,	army_rapidfire_rocket11		] {ai_face();army_fire_rocketeer();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire_rocket11	=	[	$shoot5,	army_rapidfire_rocket12		] {ai_face();army_fire_rocketeer();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire_rocket12	=	[	$shoot5,	army_rapidfire_rocket13		] {ai_face();army_fire_rocketeer();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire_rocket13	=	[	$shoot5,	army_rapidfire_rocket14		] {ai_face();army_fire_rocketeer();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire_rocket14	=	[	$shoot5,	army_rapidfire_rocket15		] {ai_face();army_fire_rocketeer();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire_rocket15	=	[	$shoot5,	army_rapidfire_rocket16		] {ai_face();army_fire_rocketeer();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire_rocket16	=	[	$shoot5,	army_rapidfire_rocket17		] {ai_face();army_fire_rocketeer();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire_rocket17	=	[	$shoot5,	army_rapidfire_rocket18		] {ai_face();army_fire_rocketeer();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_rapidfire_rocket18	=	[	$shoot6,	army_rapidfire_rocket19		] {ai_face();};
void()	army_rapidfire_rocket19	=	[	$shoot7,	army_rapidfire_rocket20		] {ai_face();SUB_CheckRefire (army_rapidfire_rocket1);};
void()	army_rapidfire_rocket20	=	[	$shoot8,	army_rapidfire_rocket21		] {ai_face();};
void()	army_rapidfire_rocket21	=	[	$shoot9,	army_run1					] {ai_face();};

void()	army_firerocket1	=	[	$shoot1,	army_firerocket2	] {ai_face();};
void()	army_firerocket2	=	[	$shoot2,	army_firerocket3	] {ai_face();};
void()	army_firerocket3	=	[	$shoot3,	army_firerocket4	] {ai_face();};
void()	army_firerocket4	=	[	$shoot4,	army_firerocket5	] {ai_face();};
void()	army_firerocket5	=	[	$shoot5,	army_firerocket6	] {ai_face();army_fire_rocketeer();self.effects = self.effects | EF_MUZZLEFLASH;};
void()	army_firerocket6	=	[	$shoot6,	army_firerocket7	] {ai_face();};
void()	army_firerocket7	=	[	$shoot7,	army_firerocket8	] {ai_face();SUB_CheckRefire (army_firerocket1);};
void()	army_firerocket8	=	[	$shoot8,	army_firerocket9	] {ai_face();};
void()	army_firerocket9	=	[	$shoot9,	army_run1			] {ai_face();};

//==============================================================================

void(entity attacker, float damage)	army_pain =
{
	local float r;
	
	if (self.pain_finished > time)
		return;

	r = random();

	if (r < 0.2)
	{
		self.pain_finished = time + 0.6;
		army_pain1 ();
		sound (self, CHAN_VOICE, "soldier/pain1.wav", 1, ATTN_NORM);
	}
	else if (r < 0.6)
	{
		self.pain_finished = time + 1.1;
		army_painb1 ();
		sound (self, CHAN_VOICE, "soldier/pain2.wav", 1, ATTN_NORM);
	}
	else
	{
		self.pain_finished = time + 1.1;
		army_painc1 ();
		sound (self, CHAN_VOICE, "soldier/pain2.wav", 1, ATTN_NORM);
	}
};


void() army_fire =
{
	local	vector	dir;
	local	entity	en;
	
	ai_face();
	
	sound (self, CHAN_WEAPON, "soldier/sattck1.wav", 1, ATTN_NORM);	

// fire somewhat behind the player, so a dodging player is harder to hit
	en = self.enemy;
	
	dir = en.origin - en.velocity*0.2;
	dir = normalize (dir - self.origin);
	
	FireBullets (4, dir, '0.1 0.1 0');
};



void()	army_die1	=[	$death1,	army_die2	] {};
void()	army_die2	=[	$death2,	army_die3	] {};
void()	army_die3	=[	$death3,	army_die4	]
{
	self.solid = SOLID_NOT;
	self.ammo_shells = 5;
#ifdef TEMPORALCORTEX
	DropWeapon();
#else
	DropBackpack();
#endif
};
void()	army_die4	=[	$death4,	army_die5	] {};
void()	army_die5	=[	$death5,	army_die6	] {};
void()	army_die6	=[	$death6,	army_die7	] {};
void()	army_die7	=[	$death7,	army_die8	] {};
void()	army_die8	=[	$death8,	army_die9	] {};
void()	army_die9	=[	$death9,	army_die10	] {};
void()	army_die10	=[	$death10,	army_die10	] {};

void()	army_cdie1	=[	$deathc1,	army_cdie2	] {};
void()	army_cdie2	=[	$deathc2,	army_cdie3	] {ai_back(5);};
void()	army_cdie3	=[	$deathc3,	army_cdie4	]
{
	self.solid = SOLID_NOT;
	self.ammo_shells = 5;
	DropBackpack();
	ai_back(4);
};
void()	army_cdie4	=[	$deathc4,	army_cdie5	] {ai_back(13);};
void()	army_cdie5	=[	$deathc5,	army_cdie6	] {ai_back(3);};
void()	army_cdie6	=[	$deathc6,	army_cdie7	] {ai_back(4);};
void()	army_cdie7	=[	$deathc7,	army_cdie8	] {};
void()	army_cdie8	=[	$deathc8,	army_cdie9	] {};
void()	army_cdie9	=[	$deathc9,	army_cdie10	] {};
void()	army_cdie10	=[	$deathc10,	army_cdie11	] {};
void()	army_cdie11	=[	$deathc11,	army_cdie11	] {};


void() army_die =
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
		army_die1 ();
	else
		army_cdie1 ();
};


/*QUAKED monster_army (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_army =
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

	self.th_stand = army_stand1;
	self.th_walk = army_walk1;
	self.th_run = army_run1;
	self.th_missile = army_atk1;
	self.th_pain = army_pain;
	self.th_die = army_die;

	if (!self.timeperiod)
		self.timeperiod = 0;

	//self.SendEntity = SendSoldier;

	walkmonster_start ();
};

/*QUAKED monster_army_gunner (1 0 0) (-16 -16 -24) (16 16 40) Ambush RapidFire
Generic soldier enemy. RapidFire spawnflag makes weapon fire fully automatic.
*/
void() monster_army_gunner =
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

	self.flags = self.flags;

	self.th_stand = army_stand1;
	self.th_walk = army_walk1;
	self.th_run = army_charge1;
	self.th_missile = army_rapidfire1;
	self.th_pain = army_pain;
	self.th_die = army_die;

	self.relationship_group = RELATION_MILITARY_PRESENT + self.timeperiod;

	if ( self.timeperiod == 0 )
	{
		self.relationship_group_like = RELATION_MILITARY_PRESENT_LIKE;
		self.relationship_group_hate = RELATION_MILITARY_PRESENT_HATE;
		self.relationship_group_fear = RELATION_MILITARY_PRESENT_FEAR;
		self.relationship_group_neutral = RELATION_MILITARY_PRESENT_NEUTRAL;
	}
	else if ( self.timeperiod == 1 )
	{
		self.relationship_group_like = RELATION_MILITARY_PAST_LIKE;
		self.relationship_group_hate = RELATION_MILITARY_PAST_HATE;
		self.relationship_group_fear = RELATION_MILITARY_PAST_FEAR;
		self.relationship_group_neutral = RELATION_MILITARY_PAST_NEUTRAL;
	}
	else if ( self.timeperiod == 2 )
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

	walkmonster_start ();
};

/*QUAKED monster_army_grenadier (1 0 0) (-16 -16 -24) (16 16 40) Ambush RapidFire
Generic soldier enemy. RapidFire spawnflag makes weapon fire fully automatic.
*/
void() monster_army_grenadier =
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

	self.th_stand = army_stand1;
	self.th_walk = army_walk1;
	self.th_run = army_charge1;

	if ( self.spawnflags & SF_GRENADIER_RAPIDFIRE )
		self.th_missile = army_rapidfire_grenade1;
	else
		self.th_missile = army_firegrenade1;

	self.th_pain = army_pain;
	self.th_die = army_die;

	self.relationship_group = RELATION_MILITARY_PRESENT + self.timeperiod;

	if ( self.timeperiod == 0 )
	{
		self.relationship_group_like = RELATION_MILITARY_PRESENT_LIKE;
		self.relationship_group_hate = RELATION_MILITARY_PRESENT_HATE;
		self.relationship_group_fear = RELATION_MILITARY_PRESENT_FEAR;
		self.relationship_group_neutral = RELATION_MILITARY_PRESENT_NEUTRAL;
	}
	else if ( self.timeperiod == 1 )
	{
		self.relationship_group_like = RELATION_MILITARY_PAST_LIKE;
		self.relationship_group_hate = RELATION_MILITARY_PAST_HATE;
		self.relationship_group_fear = RELATION_MILITARY_PAST_FEAR;
		self.relationship_group_neutral = RELATION_MILITARY_PAST_NEUTRAL;
	}
	else if ( self.timeperiod == 2 )
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

	walkmonster_start ();
};

/*QUAKED monster_army_rocketeer (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_army_rocketeer =
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

	self.th_stand = army_stand1;
	self.th_walk = army_walk1;
	self.th_run = army_charge1;

	if ( self.spawnflags & SF_GRENADIER_RAPIDFIRE )
		self.th_missile = army_rapidfire_rocket1;
	else
		self.th_missile = army_firerocket1;

	self.th_pain = army_pain;
	self.th_die = army_die;

	self.relationship_group = RELATION_MILITARY_PRESENT + self.timeperiod;

	if ( self.timeperiod == 0 )
	{
		self.relationship_group_like = RELATION_MILITARY_PRESENT_LIKE;
		self.relationship_group_hate = RELATION_MILITARY_PRESENT_HATE;
		self.relationship_group_fear = RELATION_MILITARY_PRESENT_FEAR;
		self.relationship_group_neutral = RELATION_MILITARY_PRESENT_NEUTRAL;
	}
	else if ( self.timeperiod == 1 )
	{
		self.relationship_group_like = RELATION_MILITARY_PAST_LIKE;
		self.relationship_group_hate = RELATION_MILITARY_PAST_HATE;
		self.relationship_group_fear = RELATION_MILITARY_PAST_FEAR;
		self.relationship_group_neutral = RELATION_MILITARY_PAST_NEUTRAL;
	}
	else if ( self.timeperiod == 2 )
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

	walkmonster_start ();
};
