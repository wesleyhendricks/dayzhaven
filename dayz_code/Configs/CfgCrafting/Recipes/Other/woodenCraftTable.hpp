class Blueprint_woodenCraftTable : Recipe {
	displayName = "Wooden CraftTable";
	descriptionShort = "Wooden CraftTable used to craft items.";
	input[] = 
	{
		{"PartWoodPile","CfgMagazines",1}
		//{"equip_nails","CfgMagazines",1}
	};
	output[] = 
	{
		{"ItemcraftTable","CfgMagazines",1}
	};
	required[] = 
	{
		{"ItemToolbox","CfgWeapons",1}
	};
};
