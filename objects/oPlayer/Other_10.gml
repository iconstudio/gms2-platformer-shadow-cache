/// @description 그림자 계산
var border = bbox_top
var highest = room_height
var temp = 0

var lind, rind, height_left, height_right
with oBlockParent {
	// 자신과 좌우로 맞닿아있지 않는 블록 객체들은 모두 제외시킵니다.
	//
	if other.bbox_right < bbox_left or bbox_right < other.bbox_left
		continue

	// 블록 객체가 좌우 반전인지 아닌지를 확인합니다.
	//
	/*
		 맞닿은 블록 객체가 플레이어 자신과 비교해서 어느 쪽에 위치해있는지 계산합니다.
		 이 예제에서 사용되는 경사진 블록 스프라이트가 좌우 반전이 되어있지 않고, 플레이어가 그 
		위에 밖으로 삐져 나오지 않게 올라가 있다면, lind와 rind는 둘 다 양수입니다. 플레이어가 
		왼쪽으로 살짝 삐져 나가 있다면 lind는 음수이고 rind는 양수입니다. 그리고 플레이어가 
		오른쪽으로 삐져 나가 있다면 이때도 lind와 rind 둘 다 양수입니다. 즉 플레이어가 블록의 
		왼쪽 끝자락의 오른쪽에만 있는다면 두 변수는 모두 양수입니다.

		 블록의 xscale을 반영하기 때문에 블록이 변형되어도 상관이 없습니다.

		lind, rind: 현재 플레이어와 블록이 맞닿은 부분의 중심 x 좌표
	*/
	if 0 < image_xscale {
		lind = (other.bbox_left - bbox_left) / image_xscale
		rind = (other.bbox_right - bbox_left) / image_xscale
	} else {
		lind = (other.bbox_left - bbox_right) / image_xscale
		rind = (other.bbox_right - bbox_right) / image_xscale
	}

	/*
		 먼저 스프라이트를 통해 캐싱된 높이 지도(Height Map) 를 가져옵니다. 그 다음엔 
		lind와 rind가 각각 스프라이트 너비보다 같거나 작은 양수인지를 확인합니다. 그 
		이유는 lind와 rind를 통해 어느 x 좌표에서 이 스프라이트의 맨 윗부분 접점은 
		어디인지를 알아내야하기 때문입니다. 이 검사를 거치지 않으면 리스트의 크기를 
		벗어난 참조가 되어 오류가 발생합니다.

		 yscale을 반영하기 때문에 블록이 변형되어도 상관이 없습니다
	*/
	var list = ds_map_find_value(global.terrain_grounds, sprite_index)
	if 0 <= lind and lind <= bbox_right - bbox_left
    height_left = image_yscale * ds_list_find_value(list, lind)
  else
    height_left = room_height

	if 0 <= rind and rind <= bbox_right - bbox_left
		height_right = image_yscale * ds_list_find_value(list, rind)
	else
		height_right = room_height

	/*
		 두 값 중 작은 쪽을 택하는 이유는 큰 값은 자신의 위치에서 너무 많이 벗어날
		가능성이 있지만 작은 값을 택하면 그럴 위험성이 줄어듭니다.
	*/
	temp = y + min(height_left, height_right)
	
	/*
		무조건 자기 자신보다 아래에 있는 값을 택하면서 동시에 점점 값을 줄여나갑니다.
	*/
	if border < temp and temp < highest
		highest = temp
}
shadow_y = highest
