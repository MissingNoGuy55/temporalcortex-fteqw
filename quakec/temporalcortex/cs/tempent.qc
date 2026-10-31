float() CSQC_Parse_TempEntity =
{
	vector org;
	float te = readbyte();
#if 0	// Missi: This is more annoying than anything (2026.1.27)
	dprint(sprintf("CSQC_Parse_TempEntity(%g)\n", te));
#endif
	if (te == 130 || te == 200)
	{
		org_x = readcoord();
		org_y = readcoord();
		org_z = readcoord();
		te_gunshot(org, 1);
	}
	else
		return FALSE;
	return TRUE;
};
