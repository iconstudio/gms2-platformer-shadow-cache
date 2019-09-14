/// @description 메모리 정리
for (var i = 0; i < global.terrain_numbers; ++i)
  ds_list_destroy(ds_map_find_value(global.terrain_grounds, global.terrain_sprites[i]))
ds_map_destroy(global.terrain_grounds)
global.terrain_sprites = 0
