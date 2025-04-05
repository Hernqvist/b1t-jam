extends TileMapLayer
class_name BloodSystem

const EMPTY_TILE := Vector2i(0, 0)
const WALL_TILE := Vector2i(1, 0)
const BLOOD_TILE := Vector2i(2, 0)

const WIDTH := 10
const HEIGHT := 10

static var TILES_ON_MAP :Array[Vector2i] = []
const DIRECTIONS : Array[Vector2i] = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]

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
	for new_blood : Vector2i in add_blood:
		set_cell(new_blood, 0, BLOOD_TILE)
	return true

func begin_adding_blood(from : Vector2i) -> void:
	clear_blood()
	set_cell(from, 0, BLOOD_TILE)

func mouse_tile() -> Vector2i:
	return Vector2i.ZERO

func _ready() -> void:
	for coords : Vector2i in TILES_ON_MAP:
		if get_cell_source_id(coords) == -1:
			set_cell(coords, 0, EMPTY_TILE)

func _process(_delta: float) -> void:
	if expand_blood():
		return
	if Input.is_action_just_pressed("click"):
		begin_adding_blood(mouse_tile())
