//cuas_dev_fired.sqf

//execute from config eventhandler
//finds drones and disrupts


//[unit, weapon, muzzle, mode, ammo, magazine, projectile] 
_unit = _this select 0;

if (local _unit && isPlayer _unit) then
{
	_weapon = _this select 1;
	
	//_weapon_mode = _this select 3;  //"land" or "SendHome"
	_weapon_mode = (weaponState player) select 2;  //"land" or "SendHome"

	//find drones and setvariable on drone to disrupted
	_tgtArray = [_unit, _weapon, _weapon_mode] call fn_cuas_dev_findTgts;
};
















