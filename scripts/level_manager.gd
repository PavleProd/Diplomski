extends Node

enum Turn { EXPLORER, MUMMY }
var onTurn = Turn.EXPLORER

# Called when the node enters the scene tree for the first time.
@onready var explorer: Node = $Explorer
@onready var mummy: Node = $Mummy
func _ready() -> void:
	explorer.turn_finished.connect(_on_explorer_turn_finished)
	mummy.turn_finished.connect(_on_mummy_white_turn_finished)
	explorer._set_my_turn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
#---------------------------------------------------------------------------------
func _on_explorer_turn_finished() -> void:
	if !check_for_end():
		onTurn = Turn.MUMMY
		#explorer._set_my_turn() # DEBUG
		mummy._set_my_turn()
#---------------------------------------------------------------------------------	
func _on_mummy_white_turn_finished() -> void:
	if !check_for_end():
		onTurn = Turn.EXPLORER
		explorer._set_my_turn()
#---------------------------------------------------------------------------------
@onready var death_timer: Timer = $DeathTimer
@onready var death_sound: AudioStreamPlayer2D = $DeathSound		
@onready var end_timer: Timer = $EndTimer	
func check_for_end() -> bool:
	if GameManager.player_position == GameManager.mummy_position:
		Logger.info("Igrac je izgubio!")
		death_sound.play()
		death_timer.start()
		return true
	elif GameManager.player_position == GameManager.exit_position:
		Logger.info("Igrac je pobedio!")
		GameManager.update_user_data(GlobalTime.current_time)
		explorer._move_to_exit()
		end_timer.start()
		return true
		
	return false
#---------------------------------------------------------------------------------	
func _on_end_timer_timeout() -> void:
	GameManager.to_next_level()
#---------------------------------------------------------------------------------	
func _on_death_timer_timeout() -> void:
	GameManager.reset_level()
