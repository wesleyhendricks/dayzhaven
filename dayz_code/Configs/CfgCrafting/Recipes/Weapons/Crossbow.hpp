class Blueprint_Crossbow_Kit : Recipe {
	displayName = "Compound Crossbow";
	descriptionShort = "kit is used to craft a compound Crossbow";
	input[] = 
	{
		{"Crossbow_Stock","CfgWeapons",1},
		{"equip_Crossbow_Kit","CfgMagazines",1}
	};
	output[] = 
	{
		{"Crossbow_DZ","CfgWeapons",1}
	};
	required[] = 
	{
		{"ItemToolbox","CfgWeapons",1}
	};
};