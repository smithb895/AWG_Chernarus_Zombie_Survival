// Perform teleport called from loadaction by use of addaction. 

player setPos (getPos (_this select 3));
player setpos [getpos player select 0,getpos player select 1, ((getpos player select 2)+0)];
while {(rating player) > -10000} do
{
	player addrating -1;
};
player removeAction act;