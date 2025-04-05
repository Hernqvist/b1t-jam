extends TileMapLayer
class_name BloodSystem


enum Tile {NULL, EMPTY, WALL, BLOOD, VIRUS, HEART, LUNGS}


const SOURCE := 2

var WIDTH := 12
var HEIGHT := 15
const TILE_SCALE := 8

var actions_left : int = 1

var TILES_ON_MAP :Array[Vector2i] = []
const DIRECTIONS : Array[Vector2i] = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
@onready var marker : HoverMarker = $HoverMarker
@onready var entities : Node2D = $Entities
@onready var heart : Heart = %Heart

var protected : Dictionary[Vector2i, Object] = {}


func sc(coords : Vector2i, type : Tile) -> void:
	set_cell(coords, SOURCE, Vector2i.ZERO, type)

func gc(coords : Vector2i) -> Tile:
	return get_cell_alternative_tile(coords)

static func is_removable(tile : Tile) -> bool:
	return tile == Tile.WALL or tile == Tile.VIRUS

func clear_blood() -> void:
	for coords : Vector2i in TILES_ON_MAP:
		if gc(coords) == Tile.BLOOD:
			sc(coords, Tile.EMPTY)

func expand_blood() -> bool:
	var add_blood : Array[Vector2i] = []
	for coords : Vector2i in TILES_ON_MAP:
		if gc(coords) != Tile.EMPTY:
			continue
		for delta : Vector2i in DIRECTIONS:
			var neighbour : Vector2i = coords + delta
			if gc(neighbour) == Tile.BLOOD:
				add_blood.append(coords)
	if add_blood.size() == 0:
		return false
	for new_blood : Vector2i in add_blood:
		sc(new_blood, Tile.BLOOD)
	return true

func begin_adding_blood(from : Vector2i) -> void:
	clear_blood()
	sc(from, Tile.BLOOD)

func to_tile(global : Vector2) -> Vector2i:
	return Vector2i((global - global_position) / TILE_SCALE)

func to_position(tile : Vector2i) -> Vector2:
	return position + (Vector2(tile) + Vector2.ONE * 0.5) * TILE_SCALE

func mouse_tile() -> Vector2i:
	return to_tile(get_global_mouse_position())

func evaluate() -> void:
	for entity : BoardEntity in entities.get_children():
		entity.evaluate()

func add_viruses(count : int) -> void:
	for i in range(count):
		TILES_ON_MAP.shuffle()
		var pos = Vector2i(-1, -1)
		for coords in TILES_ON_MAP:
			if gc(coords) == Tile.EMPTY and not coords in protected:
				pos = coords
				break
		if pos == Vector2i(-1, -1):
			return
		sc(pos, Tile.VIRUS)

func _ready() -> void:
	WIDTH = get_used_rect().size.x
	HEIGHT = get_used_rect().size.y
	for x in range(WIDTH):
		for y in range(HEIGHT):
			TILES_ON_MAP.append(Vector2i(x, y))
	for coords : Vector2i in TILES_ON_MAP:
		if get_cell_source_id(coords) == -1:
			sc(coords, Tile.EMPTY)
	for entity : BoardEntity in entities.get_children():
		entity.init(self)

func _process(_delta: float) -> void:
	if expand_blood():
		return
	marker.active = false
	if actions_left > 0:
		marker.global_position = to_position(mouse_tile())
		if is_removable(gc(mouse_tile())):
			marker.active = true
			
		if Input.is_action_just_pressed("click"):
			if actions_left > 0 and is_removable(gc(mouse_tile())):
				actions_left -= 1
				sc(mouse_tile(), Tile.EMPTY)
