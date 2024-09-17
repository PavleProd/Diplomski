extends Node

enum Turn { EXPLORER, MUMMY }
var onTurn = Turn.EXPLORER

# Called when the node enters the scene tree for the first time.
@onready var explorer: Node = $Explorer
@onready var mummy: Node = $MummyWhite
func _ready() -> void:
	GameManager.player_position = Vector2i(2, 2)
	GameManager.mummy_position = Vector2i(0, 0)
	
	explorer.turn_finished.connect(_on_explorer_turn_finished)
	mummy.turn_finished.connect(_on_mummy_white_turn_finished)
	explorer._set_my_turn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_explorer_turn_finished() -> void:
	if !check_for_end():
		onTurn = Turn.MUMMY
		mummy._set_my_turn()
	
func _on_mummy_white_turn_finished() -> void:
	if !check_for_end():
		onTurn = Turn.EXPLORER
		explorer._set_my_turn()
	
func check_for_end() -> bool:
	if GameManager.player_position != GameManager.mummy_position:
		return false
	
	Logger.info("Igrac je izgubio!")
	get_tree().reload_current_scene()
	return true
	
