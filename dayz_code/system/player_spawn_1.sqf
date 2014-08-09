private ["_timer","_timer1","_timer2"];
_timer = diag_tickTime;
_timer1 = diag_tickTime;
_spawnCheck = diag_tickTime;
_timer2 = diag_Ticktime;
_timer10 = diag_Ticktime;
_NewDay  = diag_tickTime;
_playerPos = getPosATL player;

while {true} do {
	//add player actions
	[] call fnc_usec_selfActions;
	
	if ((diag_tickTime - _timer2) > 0.5) then {
		[] call fnc_usec_damageActions;
		[] call fnc_usec_upgardeActions;
		_timer2 = diag_Ticktime;
	};
	
	if ((diag_tickTime - _timer10) > 10) then {
		{	
		//crickets
			(getPosATL _x) spawn {
				sleep random 10;
				_sound=format["Sound_Crickets%1",1+floor random 3];
				_x = createSoundSource [_sound, _this, [], 0];
				sleep 2;
				deleteVehicle _x;
			};
		/*
			//marker
			(getPosATL _x) spawn {
				_d = "Sign_sphere100cm_EP1" createVehicleLocal _this;
				_d setPosATL _this;
				sleep random 10;
				deleteVehicle _d;
			};
		*/			
		} foreach (nearestObjects [getPosATL player, ["Dayz_Plant1","Dayz_Plant2","Dayz_Plant3"], 15]);
		_timer10 = diag_Ticktime;
	};
	
	if ((diag_tickTime - _timer) > 300) then {

	//Other Counters
		dayz_currentGlobalAnimals = count entities "CAAnimalBase";
		dayz_currentGlobalZombies = count entities "zZombie_Base";
		
	//Animals
		[] call player_animalCheck;
		
		_timer = diag_tickTime;
	};
	
	if ((diag_tickTime - _timer1) > 10) then {
		_position = getPosATL player;
		_zeds = _position nearEntities ["zZombie_Base",200];
		dayz_spawnZombies = 0;
		dayz_CurrentNearByZombies = 0;
		//Current amounts
		{
			if (alive _x) then {
				if (local _x) then {
					dayz_spawnZombies = dayz_spawnZombies + 1;
				};
				dayz_CurrentNearByZombies = dayz_CurrentNearByZombies + 1;
			};
		} count _zeds;
		
		//dayz_spawnZombies = {alive _x AND local _x} count (_position nearEntities ["zZombie_Base",400]);
		//dayz_CurrentNearByZombies = {alive _x} count (_position nearEntities ["zZombie_Base",400]);
		dayz_currentWeaponHolders = count (_position nearObjects ["ReammoBox",200]);
		
		_timer1 = diag_tickTime;
	};
	
	//spawning system
	if ((diag_tickTime - _spawnCheck) > 6) then {
		[false] spawn player_spawnCheck;
		_spawnCheck  = diag_tickTime;
	};
	

	//Check if new day
	if ((diag_tickTime - _NewDay) > 5) then {
		private "_day";
		_day = round(360 * (dateToNumber date));
		if(dayz_currentDay != _day) then {
			dayz_sunRise = call world_sunRise;
			dayz_currentDay = _day;
		};
		
		_NewDay  = diag_tickTime;
	};
		
	//wait
	sleep 0.001; 
};