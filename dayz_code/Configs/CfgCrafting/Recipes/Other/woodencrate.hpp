class Blueprint_crate : Recipe {
	displayName = "Wooden crate";
	descriptionShort = "Wooden crate used to make more room in tents.";
	input[] = 
	{
		{"PartWoodPile","CfgMagazines",6},
		{"equip_nails","CfgMagazines",1}
	};
	output[] = 
	{
		{"equip_crate","CfgMagazines",1}
	};
	required[] = 
	{
		{"ItemToolbox","CfgWeapons",1}
	};
};
