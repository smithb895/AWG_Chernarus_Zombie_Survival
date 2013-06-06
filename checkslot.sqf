_uid = _this select 0;
_name = _this select 1;
if (((isplayer admin1) or (isplayer admin2) or (isplayer admin3) or (isplayer admin4) or (isplayer admin5) or (isplayer admin6)) and not (_uid in masteradminsarray)) then
{
serverCommand Format["#kick %1",_name];
};