//////////////////////////////////////////////////////////////////
// you can put the following line of code into the player or an object.
// the actions will be placed in the action menu.
// nul=[this,[gl1,gl2,gl3],[trigg1,trigg2]] execVM "loadaction.sqf"
// simply place the locations you want to visit into the the correct arrays.
// [gl1,gl2,gl3] is where you place game logic, objects or unit names that you want to visit
// [trig1,trig2] are the names of triggers you may wish to visit, leave empty if niot usesd.
//////////////////////////////////////////////////////////////////

_unit = _this select 0;// unit teleporting
_port = _this select 1;// game logic or unit name
_trig = _this select 2;// trigger, uses text not trigger name. 


// Game Logic Actions
for [{_i=0},{_i < count _port},{_i = _i+1}] do
{
  _pad = _port select _i;
      _unit addAction [("<t color=""#FF9900"">" + ("Teleport to "+str _pad) + "</t>"),"teleport.sqf",_pad,1,false,true,""];
};

// Trigger Actions
for [{_i=0},{_i < count _trig},{_i = _i+1}] do
{
  _pad = _trig select _i; 
     _padname = triggertext (_trig select _i);
        _unit addAction [("<t color=""#FF9900"">" + ("Teleport to "+str _padname) + "</t>"),"teleport.sqf",_pad,1,false,true,""];
};

//("<t color=""#FF9900"">" + ("Select M1911") + "</t>")