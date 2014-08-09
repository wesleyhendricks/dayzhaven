private ["_hunger","_thirst","_timeOut","_result","_randomSpot","_distance","_mylastPos","_lastTemp","_rnd","_listTalk","_messTimer","_PlayerNearby","_ZedsNearby","_saveTime"];
disableSerialization;
_timeOut = 0;
_messTimer = 0;
_lastTemp = dayz_temperatur;
_debug = getMarkerpos "respawn_west";

player setVariable ["temperature",dayz_temperatur,true];

dayz_myLoad = (((count dayz_myBackpackMags) * 0.2) + (count dayz_myBackpackWpns)) + (((count dayz_myMagazines) * 0.1) + (count dayz_myWeapons * 0.5));

[player,0] call player_humanityChange;

//player addMagazine "Hatchet_swing";
//player addWeapon "MeleeHatchet";

while {true} do {
	//Initialize
	_refObj = vehicle player;
	_size = (sizeOf typeOf _refObj) * 0.6;
	_vel = velocity player;
	_speed = round((_vel distance [0,0,0]) * 3.5);
	_saveTime = (playersNumber west * 2) + 10;

	/*
	//reset position
	_randomSpot = true;
	_tempPos = getPosATL player;
	_distance = _debug distance _tempPos;
	if (_distance < 2000) then {
		_randomSpot = false;
	};
	_distance = [0,0,0] distance _tempPos;
	if (_distance < 500) then {
		_randomSpot = false;
	};
	if (!isNil "_mylastPos") then {
		_distance = _mylastPos distance _tempPos;
		if (_distance > 400) then {
			_randomSpot = false;
		};
	};
	if (_randomSpot) then {
		_mylastPos = _tempPos;
	};

	if (!isNil "_mylastPos") then {
		dayz_mylastPos = _mylastPos;
	};
	dayz_areaAffect = _size;

	if (_speed > 0.1) then {
		_timeOut = _timeOut + 1;
	};

	if (_timeOut > 150) then {
		_humanity = player getVariable ["humanity",0];
		if (_humanity < 1) then {
			[player, round(_timeOut / 10)] call player_humanityChange;
		};
		_timeOut = 0;
	};
*/

/*
	//Has infection?
	if (r_player_infected) then {
		[player,"cough",4,false] call dayz_zombieSpeak;
	};
*/
	//Record Check
	_lastUpdate = diag_ticktime - dayZ_lastPlayerUpdate;
	if (_lastUpdate > 8) then {
		//POSITION?
		_distance = dayz_myPosition distance player;
		if (_distance > 10) then {
			//Player has moved
			dayz_myPosition = getPosATL player;
			player setVariable["posForceUpdate",true,true];
			dayz_unsaved = true;
			dayZ_lastPlayerUpdate = diag_ticktime;
		};
	};

	//Hunger
	if (dayz_hunger < 0) then {
		dayz_hunger = 0;
	};
	_hunger = (abs((((r_player_bloodTotal - r_player_blood) / r_player_bloodTotal) * 5) + _speed + dayz_myLoad) * 3);
	if (diag_ticktime - dayz_panicCooldown < 120) then {
		_hunger = _hunger * 2;
	};
	dayz_hunger = dayz_hunger + (_hunger / 60);

	//Thirst
	if (dayz_thirst < 0) then {
		dayz_thirst = 0;
	};
	_thirst = 2;
	if (_refObj == player) then {
		_thirst = (_speed + 4) * 3;
	};
	dayz_thirst = dayz_thirst + (_thirst / 60) * (dayz_temperatur / dayz_temperaturnormal);	//TeeChange Temperatur effects added Max Effects: -25% and + 16.6% waterloss
	
	//Calories
	if (dayz_nutrition > 0) then {
		_Nutrition = dayz_nutrition;
		_NutritionLoss = _Nutrition - (((_thirst / 1000) + (_hunger / 1000)) * (dayz_temperatur / dayz_temperaturnormal));		
		r_player_Nutrition = [_NutritionLoss];
	} else {
		r_player_Nutrition = [0];
	};
	dayz_nutrition = r_player_Nutrition select 0;

	
	//Temperatur
	2 call player_temp_calculation; //2 = sleep time of this loop //TeeChange
	if ((_lastTemp - dayz_temperatur) > 0.75 or (_lastTemp - dayz_temperatur) < -0.75 ) then {
		player setVariable ["temperature",dayz_temperatur,false];
		
		PVDZ_serverStoreVar = [player,"temperature",dayz_temperatur];
		publicVariableServer "PVDZ_serverStoreVar";
		
		_lastTemp = dayz_temperatur;
	};

	//can get nearby infection
	if (!r_player_infected) then {
		//	Infectionriskstart
		if (dayz_temperatur < ((80 / 100) * (dayz_temperaturnormal - dayz_temperaturmin) + dayz_temperaturmin)) then { //TeeChange
			private "_listTalk";
			_listTalk = _mylastPos nearEntities ["CAManBase",8];
			{
				if (_x getVariable["USEC_infected",false]) then {
					_rnd = (random 1) * (((dayz_temperaturnormal - dayz_temperatur) * (100 /(dayz_temperaturnormal - dayz_temperaturmin)))/ 50);	//TeeChange
					if (_rnd < 0.1) then {
						_rnd = random 1;
						if (_rnd > 0.7) then {
							r_player_infected = true;
							//player setVariable["USEC_infected",true];
						};
					};
				};
			} forEach _listTalk;
			if (dayz_temperatur < ((50 / 100) * (dayz_temperaturnormal - dayz_temperaturmin) + dayz_temperaturmin)) then { //TeeChange
				_rnd = (random 1) * (((dayz_temperaturnormal - dayz_temperatur) * (100 /(dayz_temperaturnormal - dayz_temperaturmin)))/ 25);	//TeeChange
				if (_rnd < 0.05) then {
					_rnd = random 1;
					if (_rnd > 0.95) then {
						r_player_infected = true;
						//player setVariable["USEC_infected",true];
					};
				};
			};
		};
	};	

	//If has infection reduce blood cough and add shake
	if (r_player_infected) then {
		if !(player getVariable["USEC_infected",false]) then {
			player setVariable["USEC_infected",true,true];
		};

		if (!r_player_unconscious) then {
			_rnd = 10; //_rnd = ceil (random 8);
			[player,"cough",_rnd,false] call dayz_zombieSpeak;

			if (_rnd < 3) then {
				addCamShake [2, 1, 25];
			};
		};
		
		_result = r_player_blood - 3;
		if (_result < 0) then {
			_id = [player,"sick"] spawn player_death;
		};
	};

	//Pain Shake Effects
	if (r_player_inpain and !r_player_unconscious) then {
		playSound "breath_1";
		addCamShake [2, 1, 25];
	};

	//Hunger Effect
	_foodVal = dayz_statusArray select 0;
	_thirstVal = dayz_statusArray select 1;
	if (_thirstVal <= 0) then {
		_result = r_player_blood - 10;
		if (_result < 0) then {
			_id = [player,"dehyd"] spawn player_death;
		} else {
			r_player_blood = _result;
		};
	};
	if (_foodVal <= 0) then {
		_result = r_player_blood - 10;
		if (_result < 0) then {
			_id = [player,"starve"] spawn player_death;
		} else {
			r_player_blood = _result;
		};
	};

	//Well Fed 
	//how are medical condiections
	if (!r_player_unconscious) then {
		//make sure player isnt infected or inpain.
		if (!r_player_infected AND !(r_player_Sepsis select 0)) then {
			//Check food, water and temperature is a good level
			if (r_player_blood < 12000) then {
				_wellfedVals = dayz_hunger + dayz_thirst;
				_WellFedpercentages = SleepWater + SleepFood;
				_result = 0;
				
				//diag_log format["Food %1, Water: %2 = WellFed: %3/%4 = %5",_foodVal,_thirstVal,_wellfedVals,_WellFedpercentages,(_wellfedVals / _WellFedpercentages)];
				
				switch (true) do 
				{ 
					case (((_wellfedVals / _WellFedpercentages) < 0.25)): {
						_result = 3; //1.2
					}; 
					case (((_wellfedVals / _WellFedpercentages) < 0.50)): {
						_result = 1.5; //0.6
					};
					case (((_wellfedVals / _WellFedpercentages) < 0.75)): {
						_result = 0.7; //0.3
					};
				};
				
				if (_result > 0) then {
				//If player isnt injured
					if (!r_player_injured AND !r_player_infected AND !(r_player_Sepsis select 0)) then {
						r_player_bloodregen = r_player_bloodregen + _result;
					};
				};
			};
		};
	};

	//Record low bloow
	_lowBlood = player getVariable ["USEC_lowBlood", false];
	if ((r_player_blood < r_player_bloodTotal) and !_lowBlood) then {
		player setVariable["USEC_lowBlood",true,false];
		
		PVDZ_serverStoreVar = [player,"USEC_lowBlood",true];
		publicVariableServer "PVDZ_serverStoreVar";
	};

	//Broadcast Hunger/Thirst
	_messTimer = _messTimer + 1;
	if (_messTimer > 15) then {
		_messTimer = 0;
		player setVariable ["messing",[dayz_hunger,dayz_thirst,dayz_nutrition],false];
		
		PVDZ_serverStoreVar = [player,"messing",[dayz_hunger,dayz_thirst,dayz_nutrition]];
		publicVariableServer "PVDZ_serverStoreVar";
	};

	//Save Checker
	if (dayz_unsaved or ((diag_ticktime - dayz_lastSave) > 300)) then {
		if ((diag_ticktime - dayz_lastSave) > _saveTime) then {

			PVDZ_plr_Save = [player,nil,false,dayz_playerAchievements];
			publicVariableServer "PVDZ_plr_Save";
			
			PVDZ_serverStoreVar = [player,"Achievements",dayz_playerAchievements];
			publicVariableServer "PVDZ_serverStoreVar";
			player setVariable ["Achievements",dayz_playerAchievements,false];

			if (isServer) then {
				PVDZ_plr_Save call server_playerSync;
			};

			dayz_unsaved = false;
			dayz_lastSave = diag_ticktime;
		};
	};

	// sort out pickup actions
	_isOK = (pickupInit and !canPickup) or (!pickupInit and canPickup);

	if (_isOK) then {
		if (pickupInit and !canPickup) then {
			canPickup = true;
			pickupInit = false;
		};
	} else {
		// reset
		canPickup = false;
		pickupInit = true;
	};

	_PlayerNearby = false;
	_ZedsNearby = false;
	if ({isPlayer _x} count (player nearEntities ["AllVehicles", 5]) > 1) then {
		_PlayerNearby = true;
	};
	if (count (player nearEntities ["zZombie_Base", 10]) > 0) then {
		_ZedsNearby = true;
	};

	_startcombattimer = player getVariable["startcombattimer", 0];
	if (_startcombattimer == 1 || _PlayerNearby) then {
		player setVariable["combattimeout", diag_tickTime + 30, false];
		player setVariable["startcombattimer", 0, false];
	} else {
		if (_ZedsNearby) then {
			player setVariable["combattimeout", diag_tickTime + 10, false];
			player setVariable["startcombattimer", 0, false];
		};
	};
	//setGroupIconsVisible [false,false];
	//clearGroupIcons group player;

	"colorCorrections" ppEffectAdjust [1, 1, 0, [1, 1, 1, 0.0], [1, 1, 1, 1 min (4*r_player_blood/3/r_player_bloodTotal)],  [1, 1, 1, 0.0]];
	"colorCorrections" ppEffectCommit 0;
	sleep 2;

	_myPos = player getVariable["lastPos",[]];
	if (count _myPos > 0) then {
		player setVariable["lastPos",_mylastPos, true];
		player setVariable["lastPos",[]];
	};

	//Melee Weapons ammo fix
	if(isNil {login_ammochecked}) then {
		login_ammochecked = true;
		 _wpnType = primaryWeapon player;
		_ismelee = (gettext (configFile >> "CfgWeapons" >> _wpnType >> "melee"));
		if (_ismelee == "true") then {
			call dayz_meleeMagazineCheck;
		};
	};
	
	//Two primary guns pickup exploit fix
	if ((primaryWeapon player != "") && (!(primaryWeapon player in MeleeWeapons)) && (dayz_onBack != "") && (!(dayz_onBack in MeleeWeapons)) && (isNull (findDisplay 106)) &&
	(animationState player != "amovpknlmstpslowwrfldnon_amovpknlmstpsraswrfldnon" OR animationState player != "amovpercmstpslowwrfldnon_amovpercmstpsraswrfldnon" OR animationState player != "amovpercmstpslowwrfldnon_amovpercmstpsraswrfldnon")) then {
		cutText ["You can't carry two primary weapons at the same time!","PLAIN DOWN"];
		player playActionNow "stop";
		player action ["dropWeapon", player, primaryWeapon player];
		sleep 3;
		["gear"] call player_switchWeapon;
		sleep 1;
	};

	//Crowbar ammo fix
	//"MeleeCrowbar" call dayz_meleeMagazineCheck;

};
