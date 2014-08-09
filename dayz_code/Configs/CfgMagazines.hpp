class CfgMagazines {
	class CA_Magazine;	// External class reference
	//class FoodDrink; //External class reference
	class ItemSodaEmpty; //External class reference
	//class FoodEdible; //External class reference
	class TrashTinCan; //External class reference
	class HandGrenade; //External class reference
	
	class Quiver : CA_Magazine {
		scope = public;
		ammo = "WoodenArrow";
		count = 12;
		type = 256 * 2;
		descriptionShort = $STR_ITEMQUIVER_CODE_DESC;
		displayName = $STR_ITEMQUIVER_CODE_NAME;
		initSpeed = 150;
		model = "\z\addons\dayz_communityassets\models\quiver";
		picture = "\z\addons\dayz_communityassets\pictures\equip_quiver_ca.paa";
		
		class ItemActions {
		/*
			class TakeArrow {
				text = $STR_ACTION_TAKEARROW;
				script = "spawn player_takearrow;";
			};
		*/	
			class FillQuiver {
				text = $STR_ACTION_FILLQUIVER;
				script = "spawn player_fillquiver;";
			};
			class CombineMag {
				text = "Combine Quivers";
				script = "spawn player_combineMag; r_action_count = r_action_count + 1;";
			};
		};
	};
	
	class WoodenArrow : CA_Magazine {
		scope = public;
		displayName = $STR_ITEMWOODENARROW_CODE_NAME;
		model = "\dayz_weapons\models\bolt_gear";
		picture = "\z\addons\dayz_communityassets\pictures\equip_warrow_ca.paa";
		ammo = "WoodenArrow";
		count = 1;
		initSpeed = 150;
		descriptionShort = $STR_ITEMWOODENARROW_CODE_DESC;
		
		class ItemActions {
			class CreateQuiver {
				text = $STR_ACTION_CREATEQUIVER;
				script = "spawn player_createquiver;";
			};
		};
	};
	
	class FoodDrink : CA_Magazine {
		isWater = 1;
		count = 1;
		type = 256;
		Nutrition[] = {150,0,0,0}; //[Energy,food,water,temp]
		
		class ItemActions {
			class Drink {
				text = "Drink"; //$STR_ACTIONS_DRINK
				script = "spawn player_drink;";
			};
		};
	};

	class FoodEdible : CA_Magazine {
		isFood = 1;
		count = 1;
		type = 256;
		bloodRegen = 0;
		Nutrition[] = {239,150,0,0}; //[Energy,food,water,temp]
		
		class ItemActions {
			class Eat {
				text = "Eat"; //$STR_EAT_FOOD
				script = "spawn player_eat;";
			};
		};
	};
	
	class ItemSoda : FoodDrink {
		scope = public;
		sfx = "soda";
		sfxdis = 3;
		Nutrition[] = {90,0,100,0}; //[Energy,food,water,temp]
	};
	
	class ItemBrews : FoodDrink {
		scope = public;
		sfx = "";
		sfxdis = 3;
		Nutrition[] = {0,0,0,0}; //[Energy,food,water,temp]
	};
	
	class FoodRaw : FoodEdible {
		scope = public;
		count = 1;
		type = 256;
		Nutrition[] = {282,0,0,0}; //[Energy,food,water,temp]
	};
	
	class FoodCooked : FoodEdible {
		scope = public;
		count = 1;
		Nutrition[] = {239,0,0,0}; //[Energy,food,water,temp]
	};
	
	//add here any magazines types you want to be re-combined like shown before
	
	#include "CfgMagazines\CombineMag.hpp"
	#include "CfgMagazines\FoodEdible.hpp"
	#include "CfgMagazines\FoodCooked.hpp"
	#include "CfgMagazines\FoodRaw.hpp"
	#include "CfgMagazines\ItemSoda.hpp"
	#include "CfgMagazines\ItemSodaEmpty.hpp"
	#include "CfgMagazines\MeleeSwing.hpp"
	#include "CfgMagazines\TrashTinCan.hpp"
	#include "CfgMagazines\TrashLoot.hpp"
	//Chemlight and Roadflare
	#include "CfgMagazines\HandGrenade.hpp"
	//Skins
	#include "CfgMagazines\Skin.hpp"
	//Fuelcan
	//#include "CfgMagazines\Fuelcan.hpp"
	//#include "CfgMagazines\Jerrycan.hpp"
	//medical
	#include "CfgMagazines\medical.hpp"
	#include "CfgMagazines\BloodBags.hpp"
	//Attachments
	#include "CfgMagazines\Attachments\Attachment_ACG.hpp"
	#include "CfgMagazines\Attachments\Attachment_AIM.hpp"
	#include "CfgMagazines\Attachments\Attachment_Camo.hpp"
	#include "CfgMagazines\Attachments\Attachment_GL.hpp"
	#include "CfgMagazines\Attachments\Attachment_Kobra.hpp"
	//#include "CfgMagazines\Attachments\Attachment_Pso.hpp" Not done
	#include "CfgMagazines\Attachments\Attachment_Silencer.hpp"
	#include "CfgMagazines\Attachments\Attachment_SniperScope.hpp"
	#include "CfgMagazines\Attachments\Attachment_CrossbowCCO.hpp"
	
	
	//crafting
	#include "CfgCrafting\Mats.hpp"
	
	class PartWoodPile : CA_Magazine {
		scope = public;
		count = 1;
		type = (256);
		displayName = $STR_EQUIP_NAME_40;
		model = "\dayz_equip\models\woodPile.p3d";
		picture = "\dayz_equip\textures\equip_woodPile_ca.paa";
		descriptionShort = $STR_EQUIP_DESC_40;
	};
	
	class PartWoodLumber: CA_Magazine {
		scope = 2;
		count = 1;
		type = (256 * 2);
		displayName = "Lumber";
		//model = "\z\addons\dayz_communityassets\models\planks.p3d";
		picture = "\dayz_equip\textures\equip_woodPile_ca.paa";
		descriptionShort = "Lumber: Used for building many structures and can also be used to make plywood.";
	};
	
};
