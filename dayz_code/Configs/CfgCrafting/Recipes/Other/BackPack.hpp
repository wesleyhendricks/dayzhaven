class Blueprint_PatrolPack : Recipe {
	displayName = "Makeshift Backpack";
	input[] = 
	{
		{"equip_rag","CfgMagazines",5},
		{"PartWoodPile","CfgMagazines",1},
		{"equip_string","CfgMagazines",3}
	};
	output[] = 
	{
		{"DZ_Assault_Pack_EP1","CfgVehicles",1}
	};
	required[] = 
	{
	};
};