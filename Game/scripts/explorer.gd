extends Node2D

enum Direction { NONE, UP, DOWN, LEFT, RIGHT, SKIP }
const DIRECTION_STRING := [ "none", "up", "down", "left", "right", "skip"]

var current_direction : Direction = Direction.NONE

var steps_left : int
var my_turn : bool

signal turn_finished

@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var movement_component: Node = $MovementComponent
func _ready() -> void:
	movement_component.movement_finished.connect(_on_movement_finished)	
#---------------------------------------------------------------------------------
func _process(_delta: float) -> void:	
	if my_turn:
		_process_movement()

	_process_animation()
#---------------------------------------------------------------------------------
""" 
ako se trenutno krecemo u nekom smeru, onda ne obradjujemo novi
ako se ne krecemo u nekom smeru a dobili smo input da se krecemo
onda proveravamo da li mozemo da se krecemo u tom smeru i zovemo move_to_tile
on_movement_finished ce biti pozvano kad se zavrsi kretanje
"""
func _process_movement() -> void:
	if current_direction != Direction.NONE:
		return
	
	var new_direction : Direction = get_new_direction()
	
	if new_direction == Direction.SKIP: # preskacemo potez
		finish_turn()
		return
	
	if new_direction != Direction.NONE and is_walkable(new_direction):
		var new_tile_position = get_new_tile_position(new_direction)
		if GameManager.player_position != new_tile_position:
			current_direction = new_direction
			movement_component.move_to_tile(
				GameManager.player_position,
				new_tile_position)
			audio_stream_player.play()
			GameManager.player_position = new_tile_position
#---------------------------------------------------------------------------------
func _on_movement_finished():
	current_direction = Direction.NONE
	steps_left -= 1
	if steps_left == 0:
		finish_turn()
#---------------------------------------------------------------------------------
func finish_turn():
	Logger.info("Igrac zavrsio potez!")
	audio_stream_player.stop()
	animated_sprite.stop()
	my_turn = false
	turn_finished.emit()
#---------------------------------------------------------------------------------
func get_new_direction() -> Direction:
	if Input.is_action_just_pressed("move_up"):
		return Direction.UP
	elif Input.is_action_just_pressed("move_down"):
		return Direction.DOWN
	elif Input.is_action_just_pressed("move_right"):
		return Direction.RIGHT
	elif Input.is_action_just_pressed("move_left"):
		return Direction.LEFT
	elif Input.is_action_just_pressed("move_skip"):
		return Direction.SKIP
		
	return Direction.NONE
	
#---------------------------------------------------------------------------------
func get_new_tile_position(new_direction : Direction, num_moves = 1) -> Vector2i:
	var new_tile_position : Vector2i = GameManager.player_position
	match new_direction:
		Direction.UP:
			new_tile_position.y -= num_moves
		Direction.DOWN:
			new_tile_position.y += num_moves
		Direction.RIGHT:
			new_tile_position.x += num_moves
		Direction.LEFT:
			new_tile_position.x -= num_moves
	
	return new_tile_position
#---------------------------------------------------------------------------------
func is_walkable(direction : Direction) -> bool:
	var pos = GameManager.player_position
	return GameManager.level_movement_flags[pos.y][pos.x][DIRECTION_STRING[direction]]
#---------------------------------------------------------------------------------
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
func _process_animation() -> void:
	match current_direction:
		Direction.NONE:
			animated_sprite.play("idle")
		Direction.UP:
			animated_sprite.play("move_up")
		Direction.DOWN:
			animated_sprite.play("move_down")
		Direction.RIGHT:
			animated_sprite.play("move_right")
		Direction.LEFT:
			animated_sprite.play("move_left")
#---------------------------------------------------------------------------------
func _set_my_turn() -> void:
	my_turn = true
	steps_left = GameManager.STEPS_PER_TURN_PLAYER
#---------------------------------------------------------------------------------
func _move_to_exit() -> void:
	var directionIndex = DIRECTION_STRING.find(GameManager.exit_direction)
	
	var new_tile_position = get_new_tile_position(directionIndex, 2)
	current_direction = directionIndex
	movement_component.move_to_tile(
				GameManager.player_position,
				new_tile_position)
	audio_stream_player.play()
	
