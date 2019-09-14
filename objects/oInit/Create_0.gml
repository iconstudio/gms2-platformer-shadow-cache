/// @description 지형 스프라이트 캐싱
var parent = oBlockParent
global.terrain_grounds = ds_map_create()
global.terrain_numbers = 5 // 순회할 부모 객체의 자식 객체 갯수입니다.
global.terrain_sprites = array_create(global.terrain_numbers, noone)

/*
	 스프라이트의 높이 지도(Height Map) 를 캐싱하는 방법은 여러가지가 있습니다. 지금 
	이 예제에서는 모든 스프라이트를 순회하면서 각 스프라이트에 대하여 1픽셀의 점 객체로 
	하여금 모의 충돌 검사를 시행하는 것입니다. 이 충돌 검사는 한번에 각 스프라이트의 
	너비만큼 반복됩니다. 모든 가로선 상의 점에 대해 수직 낙하를 시키며 각 x 좌표에 따라 
	스프라이트에서 그 부분의 가장 높은 y 좌표는 어디인지 저장해두는 것입니다.
*/
var target = instance_create_layer(0, 0, oScanDummy, layer)
sprite_index = sDot

/*
	 i 는 객체 인덱스(index) 를 의미합니다. 이 번호는 모든 객체가 만들어질 때마다 
	0부터 순서대로 1씩 증가되는 번호를 부여받습니다. for 문에서는 처음 만들어진 
	객체를 의미하는 0부터 객체를 순회합니다. 이는 위에서 선언한 자식 객체의 
	숫자만큼 현재 캐싱된 자식 객체의 숫자가 맞춰질 때 까지 계속합니다. 즉 i의 값 
	자체는 for 문의 진행에 영향을 끼치지 못합니다.

	 그러므로 이 for 문은 모든 자식 객체의 스프라이트를 캐싱하기 전까진 모든 객체를 
	순회한다는 의미가 됩니다.
*/
var child_count = 0
var width, height, list
for (var i = 0; child_count < global.terrain_numbers; ++i) {
	// 모든 객체 번호를 순회하는 도중에 부모 객체와 존재치 않는 객체를 만날 수 있습니다.
	//
	if !object_exists(i) or i == parent
		continue

	if object_is_ancestor(i, parent) {
		// i 가 캐싱할 부모 객체의 자식일 때만 캐싱을 해야합니다.

		// 객체의 기본 스프라이트를 받아옵니다. 이때 스프라이트가 존재하지 않으면 오류가 
		// 발생할 수도 있습니다.
		global.terrain_sprites[child_count] = object_get_sprite(i)

		target.sprite_index = global.terrain_sprites[child_count]
		target.x = sprite_get_xoffset(global.terrain_sprites[child_count])
		target.y = sprite_get_yoffset(global.terrain_sprites[child_count])
		width = target.sprite_width
		height = target.sprite_height

		list = ds_list_create()
		ds_map_add(global.terrain_grounds, global.terrain_sprites[child_count], list)
		for (var j = 0; j < width; ++j) { // 너비만큼 반복합니다.
			x = j
			y = -1
			move_contact_solid(270, height)
			ds_list_add(list, y)
		}

		++child_count
	}
}
instance_destroy(target)

instance_create_layer(0, 0, oGlobal, layer)

alarm[0] = 1
