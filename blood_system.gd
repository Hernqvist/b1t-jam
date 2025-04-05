extends TileMapLayer
class_name BloodSystem

const EMPTY_TILE := 1
const WALL_TILE := 2
const BLOOD_TILE := 3
const VIRUS_TILE := 4
const HEART_TILE := 5
const LUNGS_TILE := 6
const SOURCE := 2

const WIDTH := 10
const HEIGHT := 10
const TILE_SCALE := 8

var actions_left : int = 1

static var TILES_ON_MAP :Array[Vector2i] = []
const DIRECTIONS : Array[Vector2i] = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
@onready var marker : HoverMarker = $HoverMarker

static func _static_init() -> void:
	for x in range(WIDTH):
		for y in range(HEIGHT):
			TILES_ON_MAP.append(Vector2i(x, y))

func sc(coords : Vector2i, type : int) -> void:
	set_cell(coords, SOURCE, Vector2i.ZERO, type)

func gc(coords : Vector2i) -> int:
	return get_cell_alternative_tile(coords)

func clear_blood() -> void:
	for coords : Vector2i in TILES_ON_MAP:
		if gc(coords) == BLOOD_TILE:
			sc(coords, EMPTY_TILE)

func expand_blood() -> bool:
	var add_blood : Array[Vector2i] = []
	for coords : Vector2i in TILES_ON_MAP:
		if gc(coords) != EMPTY_TILE:
			continue
		for delta : Vector2i in DIRECTIONS:
			var neighbour : Vector2i = coords + delta
			if gc(neighbour) == BLOOD_TILE:
				add_blood.append(coords)
	if add_blood.size() == 0:
		return false
	add_blood.shuffle()
	for new_blood : Vector2i in add_blood:
		sc(new_blood, BLOOD_TILE)
		if randi() % 2 == 0:
			break
	return true

func begin_adding_blood(from : Vector2i) -> void:
	clear_blood()
	sc(from, BLOOD_TILE)

func to_tile(global : Vector2) -> Vector2i:
	return Vector2i((global - global_position) / TILE_SCALE)

func to_position(tile : Vector2i) -> Vector2:
	return position + (Vector2(tile) + Vector2.ONE * 0.5) * TILE_SCALE

func mouse_tile() -> Vector2i:
	return to_tile(get_global_mouse_position())

func add_viruses(count : int) -> void:
	for i in range(count):
		TILES_ON_MAP.shuffle()
		var pos = Vector2i(-1, -1)
		for coords in TILES_ON_MAP:
			if gc(coords) == EMPTY_TILE:
				pos = coords
				break
		if pos == Vector2i(-1, -1):
			return
		sc(pos, VIRUS_TILE)

func _ready() -> void:
	for coords : Vector2i in TILES_ON_MAP:
		if get_cell_source_id(coords) == -1:
			sc(coords, EMPTY_TILE)

func _process(_delta: float) -> void:
	if expand_blood():
		return
	if actions_left > 0:
		marker.global_position = to_position(mouse_tile())
		
	if Input.is_action_just_pressed("click"):
		begin_adding_blood(mouse_tile())
