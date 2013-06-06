//Zombie mission init script by Celery

cutText ["","BLACK FADED",1];

//Wait for JIP to load
waitUntil {isDedicated or !isNull player};

//Parameters
if (isNil "paramsArray") then {paramsArray=[2,0]};
CLY_friendlyfire=paramsArray select 0;
CLY_terraingrid=paramsArray select 1;

//Variable inits
CLY_cutscene=false;
CLY_playerrating=0;
if (isNil "CLY_alldead") then {CLY_alldead=false};

//Random zombie classname
CLY_randomzombie={
	_selected=false;
	_zombie=CLY_zombieclasses select floor random count CLY_zombieclasses;
	while {typeName _zombie=="ARRAY"} do {
		_zombie=_zombie select floor random count _zombie;
	};
	_zombie;
};

//Random armored zombie classname
CLY_randomarmoredzombie={
	_zombie=CLY_armoredzombieclasses select floor random count CLY_armoredzombieclasses;
	while {typeName _zombie=="ARRAY"} do {
		_zombie=_zombie select floor random count _zombie;
	};
	_zombie;
};

//Disable saving
enableSaving [false,false];

//Weather
setViewDistance 500;
setWind [2,-2,true];

//Fog script by Rockhount (original by Yac)
[player,200,10,10,3,6,-0.3,0.1,0.3,1,1,1,30,10,15,true,0.4,0.5,0.025,0,0,0,0,24] execFSM "Fog.fsm";

//CLY Remove Dead
[45,0] execVM "cly_removedead.sqf";
player setVariable ["CLY_removedead",false,true];



/////No dedicated after this/////
if (isDedicated) exitWith {};
/////No dedicated after this/////



//Put player in proper start position
[] spawn {
	sleep 1;
	//JIP
	player setVelocity [0,0,0];
	player setPos [getPos player select 0,getPos player select 1,(getPosATL player select 2)-(getPos player select 2)];
	if (!isNil "CLY_jipresumepos" and !(typeOf player in CLY_deadcharacters)) then {
		player setPosATL CLY_jipresumepos;
	};
	if !(typeOf player in CLY_deadcharacters) then {
		sleep 1;
		cutText ["","BLACK IN",3];
		sleep 10;
		player setVariable ["victim",nil,true];
		player setVariable ["CLY_addweapon",nil];
	} else {
		player setPosATL CLY_jipresumepos;
	};
};

//---Accuracy boost---
//Activate accuracy boost
//Designed and recommended only for sidearms with a high spread.
CLY_accuracy=true;

//Minimum dispersion value in config before a handgun receives accuracy boost
CLY_mindispersion=0.002;

//Weapons that receive an accuracy boost regardless of type and dispersion
CLY_accuracyarray=[];

//Load the script
CLY_accuracyscript=compile preProcessFile "cly_accuracy.sqf";

//Event handler
player addEventHandler ["Fired",{_this call CLY_accuracyscript}];

//Update weapon direction
if (CLY_accuracy) then {
	[] spawn {
		_lasttime=0;
		while {true} do {
			sleep 0.02;
			CLY_weapondir=[player weaponDirection currentWeapon player,time,_lasttime];
			_lasttime=time;
		};
	};
};
//////////////////////



//Leave group
_group=createGroup west;
[player] join _group;

//Friendly fire damage modifier
if (CLY_friendlyfire!=1) then {
	player addEventHandler ["HandleDamage",{if (isPlayer (_this select 3) and (_this select 3)!=(_this select 0)) then {damage (_this select 0)+(_this select 2)*(CLY_friendlyfire*0.1)} else {_this select 2}}];
};

//Zombie face update for clients
[] exec "zombie_scripts\cly_z_textures.sqs";

//GPS markers
[] exec "cly_gps.sqs";

//CLY Jukebox
[
	1,
	["auldale",0,323,0.35],
	["Fallout",0,207,0.35],
	["cradle",0,367,0.35],
	["kurshok",0,210,0.35],
	["pavelock",0,121,0.35],
	["oldquarter",0,257,0.35],
	["Wasteland",0,195,0.35]
] execVM "cly_jukebox.sqf";

//Claw script
CLY_z_claw={
	_victim=_this select 0;
	_claw=_this select 1;
	if (player==_victim) then {
		titleRsc [format ["claw%1",_claw],"PLAIN"]
	} else {
		if (!isNil {player getVariable "spectating"}) then {
			if (player getVariable "spectating"==_victim) then {
				titleRsc [format ["claw%1",_claw],"PLAIN"];
			};
		};
	};
	true;
};

//Claw mark HUD
[] execVM "cly_hud.sqf";

//Public variable event handlers
"CLY_z_noisepv" addPublicVariableEventHandler {
	_var=_this select 1;
	_zombie=_var select 0;
	_zombie say3D (_var select 1);
};
"CLY_z_attackpv" addPublicVariableEventHandler {
	_var=_this select 1;
	_zombie=_var select 0;
	_sound=_var select 1;
	_anim=if (count _var>2) then {_var select 2} else {""};
	_object="HeliHEmpty" createVehicleLocal [0,0,0];
	_object attachTo [_zombie,[0,0,1.5]];
	_object say3D _sound;
	if (_anim!="") then {_zombie switchMove _anim};
	[_object] spawn {sleep 10;deleteVehicle (_this select 0)};
};
"CLY_z_victimpv" addPublicVariableEventHandler {
	_var=_this select 1;
	_victim=_var select 0;
	_sound=_var select 1;
	_claw=_var select 2;
	_object="HeliHEmpty" createVehicleLocal [0,0,0];
	_object attachTo [_victim,[0,0,1.5]];
	if (_sound!="") then {_object say3D _sound};
	[_object] spawn {sleep 5;deleteVehicle (_this select 0)};
	if (_claw>0) then {[_victim,_claw] call CLY_z_claw};
};
"CLY_z_radiopv" addPublicVariableEventHandler {
	_var=_this select 1;
	_talker=_var select 0;
	_radio=_var select 1;
	_say=if (count _var>2) then {_var select 2} else {""};
	if (isPlayer _talker) then {
		if (_say!="") then {_talker say _say};
		_talker commandRadio _radio;
	} else {
		if (_say!="") then {_talker say _say};
		_talker globalRadio _radio;
	};
};



sleep 3;


//CLY Heal
_bandages=if ((typeOf player=="Assistant") or (typeOf player=="FR_Assault_R")) then {8} else {1};

//Load player state
if !(typeOf player in CLY_deadcharacters) then {
	_array=[];
	_index=0;
	_i=0;
	{
		if (typeOf player in _x) then {_array=_x;_index=_i};
		_i=_i+1;
	} forEach CLY_playerstates;
	if (count _array>0) then {
		_damage=_array select 2;
		_bandages=_array select 3;
		_magazines=_array select 4;
		_weapons=_array select 5;
		_items=_array select 6;
		
		//2/3 of the original magazines
		_newmagazines=[];
		{
			if !(_x in _newmagazines) then {
				_mag=_x;
				for "_x" from 1 to round (({_x==_mag} count _magazines)*0.66) do {
					_newmagazines set [count _newmagazines,_mag];
				};
			};
		} forEach _magazines;
		
		removeAllWeapons player;
		removeAllItems player;
		player setDamage _damage;
		{player addMagazine _x} forEach _newmagazines;
		{player addWeapon _x} forEach _weapons;
		if (count _weapons>0) then {
			_gun=_weapons select 0;
			_muzzles=getArray (configFile/"CfgWeapons"/_gun/"muzzles");
			_muzzle=if !("this" in _muzzles) then {_muzzles select 0} else {_gun};
			player selectWeapon _muzzle;
			if (vehicle player==player) then {
				_anim="";
				_guntype=getNumber (configFile/"CfgWeapons"/_gun/"type");
				if (_guntype in [1,5]) then {_anim="amovpercmstpsraswrfldnon"};
				if (_guntype==2) then {_anim="amovpercmstpsraswpstdnon"};
				if (_guntype==4) then {_anim="amovpercmstpsraswlnrdnon"};
				if (_anim!="") then {player switchMove _anim};
			};
		};
		{player addWeapon _x} forEach _items;
		CLY_playerstates set [_index,[player,typeOf player,_damage,_bandages,_newmagazines,_weapons,_items]];
		publicVariable "CLY_playerstates";
	};
};

//CLY Heal continued
[player,0.1,0,_bandages,false] execVM "cly_heal.sqf";



//Option to set terrain detail at start
if (!isDedicated) then {
	if (CLY_terraingrid==0) then {
		CLY_terrainaction0=player addAction ["Confirm terrain detail","terraingrid.sqs",0,2.5,true,true,"",""];
		CLY_terrainaction1=player addAction ["Terrain detail: very low","terraingrid.sqs",50,2.5,true,true,"",""];
		CLY_terrainaction2=player addAction ["Terrain detail: low","terraingrid.sqs",25,2.5,true,true,"",""];
		CLY_terrainaction3=player addAction ["Terrain detail: medium","terraingrid.sqs",12.5,2.5,true,true,"",""];
		CLY_terrainaction4=player addAction ["Terrain detail: high","terraingrid.sqs",6.25,2.5,true,true,"",""];
		CLY_terrainaction5=player addAction ["Terrain detail: very high","terraingrid.sqs",3.125,2.5,true,true,"",""];
	} else {
		if (CLY_terraingrid>0) then {setTerrainGrid CLY_terraingrid};
	};
} else {
	setTerrainGrid 50;
};

//CLY Spectate cameraView script (spectator sees aiming mode when player aims)
[] spawn {
	player setVariable ["cameraview","INTERNAL",true];
	while {true} do {
		if (alive player and cameraView!=(player getVariable "cameraview")) then {player setVariable ["cameraview",cameraView,true]};
		sleep 0.1;
	};
};

//Set players captive - prevents zombies from fleeing in MP
player setCaptive true;

masteradminsarray = [
	"1234567", // Replace with admin UIDs
	"09876545"
	];
masterClassArray = [
	"AH64D",
	"AV8B2",
	"F35B",
	"Ka52Black",
	"AH1Z",
	"A10",
	"M1A2_TUSK_MG",
	"UH1Y",
	"AV8B",
	"C130J",
	"MV22",
	"Mi17_rockets_RU"
	];

OnPlayerConnected "[_uid,_name] execVM ""checkslot.sqf""";
execVM "login.sqf";
execVM "loadout.sqf";
[] execVM "removeSideMarkers.sqf";