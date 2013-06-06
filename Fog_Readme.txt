Fog script v1.62
Made by Rockhount[BAfH] (visit us on http://www.bafh.eu )

Discription:
I have reworked Yac`s scripts in a fsm for more atmosphere.
You have now more options and more performance.
Its a client-side script, it works in the Editor/SP and on a non-dedicated-server too and you can use markers to place it.
The script will not run on the dedicated-server-side and the server will not sychronize the fog, because it would cause to much lags,
otherwise the server would synchronize 50-300 clouds per second and every cloud would have 5-10 synchronized values and that is to much.

Install:

Open the editor, create a new unit/object and put the example into the init of the unit, after that replace 'l1' with 'Player'and save the mission.
Then open the folder .../Dokuments/ArmA 2 Other Profiles/Nickname/missions/misisonsname and copy the script into the folder.

example: null=[l1,100,11,10,3,7,-0.3,0.1,0.5,1,1,1,13,12,15,true,2,2.1,0.1,4,6,0,3.5,17.5] execFSM "Fog.fsm";

l1 = name of unit (use "" for markers and when you on a  multiplayer session only want to set the fog around the player: run the script once! with 'Player' (not 'this' and not 'name of the unit/object'!!!), example: null=[Player,200,10,... )
If the unit/building was destroyed/died or the marker was deleted, the script will exit automatically!
100 = Maximumdistance
11 = Minimumdistance
10 = Count of clouds
3 = Minimumsize of clouds
7 = Maximumsize of clouds
-0.3 = Height of clouds (must be a bit below the ground to look realistic)
0.1 = Respawntime of clouds
0.5 = Transparency
1,1,1 = Color of clouds
13 = Remove-speed of clouds
12 = Minimumlifetime of clouds
15 = Maximumlifetime of clouds
true = The fog will be effected by wind (for no wind effect: false)
2 = Windstrength (acts only when the wind effect is 'true')
2.1 = Random-direction-period(in seconds) (acts only when the wind effect is 'true')
0.1 = Random-direction-intensity (acts only when the wind effect is 'true')
4,6,0 = Move-direction-speed (x,y,z) - same effect as wind, but constant and adjustable(acts only when the wind effect is 'false')
3.5 = Stardaytime (the fog will spawn when the ingametime is 03:30)
17.5 = Enddaytime (the fog will spawn when the ingametime is 17:30)
RandomDirectionPeriod 2.1 with RandomDirectionIntensity 0.1 means that 0.1 will be added to the direction-speed (x,y,z-randomized) of a moving-cloud every 2.1 seconds.

An example for norrins revive-script:
revive_init.sqf:
NORRNCustomExec1 ="null=[Player,100,11,10,3,7,-0.3,0.1,0.5,1,1,1,13,12,15,true,1,2.1,0.1,4,6,0,0,24] execFSM ""Fog.fsm"";"; // Exec1 occurs following being revived
NORRNCustomExec3 ="null=[Player,100,11,10,3,7,-0.3,0.1,0.5,1,1,1,13,12,15,true,1,2.1,0.1,4,6,0,0,24] execFSM ""Fog.fsm"";"; // Exec3 occurs when you spawn at base

#Update 1:
Fixed: Position Error

#Update 2:
script optimized

#Update 3:
If the marker was deleted, the script will exit and will not continue to spawn the fog at position [0,0,0]
If the unit/building is dead/destroyed, the script will exit and will not cotinue to spawn the fog at the last position.

#Update 4:
Fixed: clouds spawned twice

#Update 5:
More options:
Releasetime of clouds
Lifetime of clouds
Move-direction-speed of clouds(x)
Move-direction-speed of clouds(y)
Move-direction-speed of clouds(z)

#Update 6:
The most of the options musn`t be set to get no errors (Only the first option must be set)
When a option isn`t set, it will get a stanard value.
Fixed: Maximumdistance doesn`t work correctly (Thanks to Celery)
More options:
Effect by wind
minimum and maximum options for the size of clouds

#Update 6.1:
Fixed: Minimumdistance doesn`t work correctly (Thanks to Celery)
More options:
Wind strength
minimum and maximum options for the lifetime of clouds

#Update 6.2:
script optimized
More Options:
Random-direction-period (in seconds) (acts only when the wind effect is 'true')
Random-direction-intensity (acts only when the wind effect is 'true')
Startdaytime (24 hour clock)
Enddaytime (24 hour clock)

Credits: 
Yac for the original Script

For questions visit:
http://forums.bistudio.com/showthread.php?t=112464