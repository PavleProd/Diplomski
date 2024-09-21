extends Node2D


enum Direction { NONE, UP, DOWN, LEFT, RIGHT }
const DIRECTION_STRING := [ "none", "up", "down", "left", "right"]

var current_direction : Direction = Direction.NONE

var steps_left : int
var my_turn : bool

signal turn_finished

@onready var movement_component: Node = $MovementComponent
func _ready() -> void:
	movement_component.movement_finished.connect(_on_movement_finished)
#---------------------------------------------------------------------------------
func _process(delta: float) -> void:
	if my_turn:
		_process_movement()
		
	_process_animation()

#---------------------------------------------------------------------------------
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
func _process_movement() -> void:
	if current_direction != Direction.NONE:
		return
	
	var new_direction : Direction = get_new_direction()
	
	if new_direction != Direction.NONE:
		var new_tile_position = get_new_tile_position(new_direction)
		current_direction = new_direction
		movement_component.move_to_tile(
			GameManager.mummy_position,
			new_tile_position)
		audio_stream_player.play()
		GameManager.mummy_position = new_tile_position
	else:
		_on_movement_finished() # skipujemo potez jer nemamo gde da se krecemo
		
			
#---------------------------------------------------------------------------------
func get_new_direction() -> Direction:
	var player_pos = GameManager.player_position
	var mummy_pos = GameManager.mummy_position
	
	if player_pos.y < mummy_pos.y and is_walkable(Direction.UP):
		return Direction.UP
	elif player_pos.y > mummy_pos.y and is_walkable(Direction.DOWN):
		return Direction.DOWN 
	elif player_pos.x < mummy_pos.x and is_walkable(Direction.LEFT):
		return Direction.LEFT
	elif player_pos.x > mummy_pos.x and is_walkable(Direction.RIGHT):
		return Direction.RIGHT
	
	return Direction.NONE
#---------------------------------------------------------------------------------
func is_walkable(direction : Direction) -> bool:
	var pos = GameManager.mummy_position
	return GameManager.level_movement_flags[pos.y][pos.x][DIRECTION_STRING[direction]]
#---------------------------------------------------------------------------------
func get_new_tile_position(direction : Direction) -> Vector2i:
	var new_tile_position : Vector2i = GameManager.mummy_position
	match direction:
		Direction.UP:
			if new_tile_position.y > 0:
				new_tile_position.y -= 1
		Direction.DOWN:
			if new_tile_position.y < GameManager.NUM_TILES - 1:
				new_tile_position.y += 1
		Direction.RIGHT:
			if new_tile_position.x < GameManager.NUM_TILES - 1:
				new_tile_position.x += 1
		Direction.LEFT:
			if new_tile_position.x > 0:
				new_tile_position.x -= 1
				
	return new_tile_position
#---------------------------------------------------------------------------------		
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
func _process_animation() -> void:
	match current_direction:
		Direction.NONE:
			animated_sprite.stop()
		Direction.UP:
			animated_sprite.play("move_up")
		Direction.DOWN:
			animated_sprite.play("move_down")
		Direction.RIGHT:
			animated_sprite.play("move_right")
		Direction.LEFT:
			animated_sprite.play("move_left")

#---------------------------------------------------------------------------------
func _on_movement_finished():
	current_direction = Direction.NONE
	steps_left -= 1
	if steps_left == 0:
		Logger.info("Mumija zavrsila potez!")
		audio_stream_player.stop()
		animated_sprite.stop()
		my_turn = false
		turn_finished.emit()
#---------------------------------------------------------------------------------
func _set_my_turn() -> void:
	my_turn = true
	steps_left = GameManager.STEPS_PER_TURN_MUMMY
