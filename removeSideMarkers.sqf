waitUntil { !isNull player };
_UID = getPlayerUID player;

// hide markers if player is not an admin
if !(_UID in masteradminsarray) then 
{
"adminbase" setMarkerAlphaLocal 0; // this makes the marker transparent
"respawn_base" setMarkerAlphaLocal 0;
};