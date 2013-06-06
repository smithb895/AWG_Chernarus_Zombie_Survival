//Loadout script for fresh spawns without giving them loads of ammo
//By Superxpdude

//this addAction ["Select Loadout", "loadout.sqf",[loadout#]]
/*
_loadout1 = this addAction [("<t color=""#FF9900"">" + ("Select M4A1") + "</t>"), "loadout.sqf",1];
_loadout2 = this addAction [("<t color=""#FF9900"">" + ("Select M16A2") + "</t>"), "loadout.sqf",2];
_loadout3 = this addAction [("<t color=""#FF9900"">" + ("Select AKS-74U") + "</t>"), "loadout.sqf",3];
_loadout4 = this addAction [("<t color=""#FF9900"">" + ("Select MP5A5") + "</t>"), "loadout.sqf",4];
_loadout5 = this addAction [("<t color=""#FF9900"">" + ("Select M9") + "</t>"), "loadout.sqf",5];
_loadout6 = this addAction [("<t color=""#FF9900"">" + ("Select M1911") + "</t>"), "loadout.sqf",6];
*/
_unit = _this select 1;
_loadout = _this select 3;

removeallWeapons _unit;

switch (_loadout) do
{
   case 1:
   {
      {_unit addMagazine "30Rnd_556x45_Stanag";} forEach [1,2,3];
	  _unit addWeapon "M4A1";
   };	
   case 2:
   {
      {_unit addMagazine "30Rnd_556x45_Stanag";} forEach [1,2,3];
	  _unit addWeapon "M16A2";
   };	
   case 3:
   {
      {_unit addMagazine "30Rnd_545x39_AK";} forEach [1,2,3];
	  _unit addWeapon "AKS_74_U";
   };	
   case 4:
   {
      {_unit addMagazine "30Rnd_9x19_MP5";} forEach [1,2,3,4];
	  _unit addWeapon "MP5A5";
   };	
   case 5:
   {
      {_unit addMagazine "15Rnd_9x19_M9";} forEach [1,2,3,4];
	  _unit addWeapon "M9";
   };	
   case 6:
   {
      {_unit addMagazine "7Rnd_45ACP_1911";} forEach [1,2,3,4];
	  _unit addWeapon "Colt1911";
   };	
   default
   {
      {_unit addMagazine "30Rnd_556x45_Stanag";} forEach [1,2,3];
	  _unit addWeapon "M4A1";
   };
};

_primaryWeapon = primaryWeapon _unit;
_unit selectweapon _primaryWeapon;