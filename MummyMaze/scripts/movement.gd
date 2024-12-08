extends Node

const MOVE_SPEED : float = 2.0

var start_position : Vector2
var end_position : Vector2
var is_moving : bool = false
var move_progress : float = 0.0

signal movement_finished

func move_to_tile(start_tile : Vector2i, end_tile : Vector2i ) -> void:
	start_position = tile_to_position(start_tile)
	end_position = tile_to_position(end_tile)
	is_moving = true
	move_progress = 0.0
#---------------------------------------------------------------------------------
func _process(delta: float) -> void:
	if !is_moving:
		return
	move_progress += delta * MOVE_SPEED
	
	get_parent().position = start_position.lerp(end_position, move_progress)
	
	if move_progress >= 1.0:
		is_moving = false
		get_parent().position = end_position
		movement_finished.emit()
#---------------------------------------------------------------------------------
func tile_to_position(tile : Vector2i):
	var result_position : Vector2
	result_position.x = GameManager.TILE_0_POSITION.x + \
		GameManager.TILE_DIMENSIONS.x * tile.x
	result_position.y = GameManager.TILE_0_POSITION.y + \
		GameManager.TILE_DIMENSIONS.y * tile.y
	return result_position	
