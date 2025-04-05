extends TileMapLayer
class_name BloodSystem

const EMPTY_TILE := Vector2i(0, 0)
const WALL_TILE := Vector2i(1, 0)
const BLOOD_TILE := Vector2i(2, 0)

const WIDTH := 10
const HEIGHT := 10
const TILE_SCALE := 1

var actions_left : int = 1

static var TILES_ON_MAP :Array[Vector2i] = []
const DIRECTIONS : Array[Vector2i] = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
@onready var marker : HoverMarker = $HoverMarker

static func _static_init() -> void:
	for x in range(WIDTH):
		for y in range(HEIGHT):
			TILES_ON_MAP.append(Vector2i(x, y))
	

func clear_blood() -> void:
	for coords : Vector2i in TILES_ON_MAP:
		if get_cell_atlas_coords(coords) == BLOOD_TILE:
			set_cell(coords, 0, EMPTY_TILE)

func expand_blood() -> bool:
	var add_blood : Array[Vector2i] = []
	for coords : Vector2i in TILES_ON_MAP:
		if get_cell_atlas_coords(coords) != EMPTY_TILE:
			continue
		for delta : Vector2i in DIRECTIONS:
			var neighbour : Vector2i = coords + delta
			if get_cell_atlas_coords(neighbour) == BLOOD_TILE:
				add_blood.append(coords)
	if add_blood.size() == 0:
		return false
	add_blood.shuffle()
	for new_blood : Vector2i in add_blood:
		set_cell(new_blood, 0, BLOOD_TILE)
		if randi() % 2 == 0:
			break
	return true

func begin_adding_blood(from : Vector2i) -> void:
	clear_blood()
	set_cell(from, 0, BLOOD_TILE)

func to_tile(global : Vector2) -> Vector2i:
	return Vector2i((global - global_position) / TILE_SCALE)

func to_position(tile : Vector2i) -> Vector2:
	return position + (Vector2(tile) + Vector2.ONE * 0.5) * TILE_SCALE

func mouse_tile() -> Vector2i:
	return to_tile(get_global_mouse_position())

func _ready() -> void:
	for coords : Vector2i in TILES_ON_MAP:
		if get_cell_source_id(coords) == -1:
			set_cell(coords, 0, EMPTY_TILE)

func _process(_delta: float) -> void:
	if expand_blood():
		return
	if actions_left > 0:
		marker.global_position = to_position(mouse_tile())
		
	if Input.is_action_just_pressed("click"):
		begin_adding_blood(mouse_tile())
