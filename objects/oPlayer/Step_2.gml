/// @description 좌표 제한과 그림자 갱신
x = clamp(x, sprite_xoffset, room_width - sprite_xoffset)

if x != xprevious
	event_user(0)
