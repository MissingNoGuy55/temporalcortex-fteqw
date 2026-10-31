/*
==============================================================================

LOUISE FLETCHER

==============================================================================
*/

/*QUAKED monster_boss_fletcher (1 0 0) (-16 -16 -24) (16 16 40) Ambush RapidFire
Boss for "Mental Hospital" map. Can command other soldiers and can inflict the
"lobotomized" debuff, which freezes the player's inputs for a short time.
*/
void() monster_boss_fletcher =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	total_monsters = total_monsters + 1;
};

//===========================================================================




