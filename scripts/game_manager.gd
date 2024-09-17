extends Node

const NUM_TILES = 6
const TILE_0_POSITION : Vector2i = Vector2i(30, 50)
const TILE_DIMENSIONS : Vector2i = Vector2i(60, 60)

const STEPS_PER_TURN_PLAYER : int = 1
const STEPS_PER_TURN_MUMMY : int = 2

var current_level : int = 0
var player_position : Vector2i
var mummy_position : Vector2i

var level_movement_flags

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_level = 0
	load_level_movement_flags()
#---------------------------------------------------------------------------------
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
#---------------------------------------------------------------------------------
func load_level_movement_flags():
	var filePath = "res://maps/level" + str(current_level) + ".json"
	var file = FileAccess.open(filePath, FileAccess.READ)
	if file != null:
		level_movement_flags = JSON.parse_string(file.get_as_text())
		file.close()
