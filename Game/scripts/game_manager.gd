extends Node

const NUM_TILES = 6
const TILE_0_POSITION : Vector2i = Vector2i(30, 50)
const TILE_DIMENSIONS : Vector2i = Vector2i(60, 60)

const STEPS_PER_TURN_PLAYER : int = 1
const STEPS_PER_TURN_MUMMY : int = 2

const NUM_LEVELS = 6

var current_level : int = 1

var player_position : Vector2i
var mummy_position : Vector2i
var exit_position : Vector2i
var exit_direction : String

var level_movement_flags
var entities_position_data
var user_data
const USER_DATA_PATH = "user://user_data.json"
const USER_DATA_TEMPLATE_PATH = "res://data/templates/user_data_template.json"
const POSITION_DATA_PATH = "res://data/entities_position_data.json"

func _ready() -> void:
	load_level_movement_flags() # podaci samo za trenutni level
	load_entities_position_data() # podaci za sve levele
	user_data = read_file(USER_DATA_PATH) # korisnicki podaci
	if user_data == null:
		user_data = read_file(USER_DATA_TEMPLATE_PATH)
#---------------------------------------------------------------------------------
func load_level():
	# TODO: updateuj podatke u level_manageru ili ovde
	GlobalTime.start()
	load_level_movement_flags()
	load_entities_position_data()
	get_tree().change_scene_to_file(\
		"res://scenes/levels/Level" + str(current_level) + ".tscn")
#---------------------------------------------------------------------------------
func to_next_level() -> void:
	if current_level == NUM_LEVELS:
		get_tree().change_scene_to_file("res://scenes/levels/ending.tscn")
		return
		
	GameManager.current_level += 1
	load_level()
#---------------------------------------------------------------------------------
func update_user_data(new_record_time : int) -> void:
	user_data["max_level"] = max(user_data["max_level"], current_level + 1)
	var level_data = GameManager.user_data["levels"][current_level - 1]
	var old_record_time = level_data["record_time"]
	if old_record_time == 0 or new_record_time < old_record_time:
		level_data["record_time"] = new_record_time
	
	write_to_file(USER_DATA_PATH, user_data) # cuvamo updatovane user podatke
#---------------------------------------------------------------------------------
func to_level(level : int) -> void:
	if level > NUM_LEVELS:
		return
	
	GameManager.current_level = level
	load_level()
#---------------------------------------------------------------------------------
func reset_level() -> void:
	load_entities_position_data()
	get_tree().reload_current_scene()	
#---------------------------------------------------------------------------------
func reset_progress() -> void:
	user_data = read_file(USER_DATA_TEMPLATE_PATH)
	write_to_file(USER_DATA_PATH, user_data) # cuvamo resetovane user podatke
	to_level(1) # povratak na pocetak
#---------------------------------------------------------------------------------
func load_level_movement_flags():
	var filePath = "res://data/map_layouts/level" + str(current_level) + ".json"
	level_movement_flags = read_file(filePath)
#---------------------------------------------------------------------------------
"""
Ucitava podatke iz fajla ako nisu ucitani i upisuje podatke za trenutni nivo 
u promenljive
"""
func load_entities_position_data():
	if entities_position_data == null:
		entities_position_data = read_file(POSITION_DATA_PATH)
		
	var current_index = current_level - 1 # indeksiranje od 0, a nivoi idu od 1
	player_position = \
		array_to_vector2i(entities_position_data[current_index]["player_position"])
	mummy_position = \
		array_to_vector2i(entities_position_data[current_index]["mummy_position"])
	exit_position = \
		array_to_vector2i(entities_position_data[current_index]["exit_position"])
	exit_direction = entities_position_data[current_index]["exit_direction"]
#---------------------------------------------------------------------------------
func array_to_vector2i(arr) -> Vector2i:
	return Vector2i(arr[0], arr[1])
#---------------------------------------------------------------------------------
func read_file(filePath):
	var file = FileAccess.open(filePath, FileAccess.READ)
	if file != null:
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		return data
	return null
#---------------------------------------------------------------------------------
func write_to_file(filePath, data) -> void:
	var file = FileAccess.open(filePath, FileAccess.WRITE)
	if file != null:
		file.store_string(JSON.stringify(data, "\t"))
		file.close()
