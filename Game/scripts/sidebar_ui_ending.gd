extends Control

func _ready() -> void:
	init_level_buttons()
#---------------------------------------------------------------------------------
func init_level_buttons() -> void:
	for i in range(1, GameManager.NUM_LEVELS + 1):
		var button : Button = get_node("Level" + str(i))
		# konektovanje na kliktanje
		if button == null:
			Logger.error("Objekat nije prepoznat kao dugme!")
			continue
			
		button.pressed.connect(Callable(_on_go_to_level_pressed).bind(i))
#---------------------------------------------------------------------------------
func _on_go_to_level_pressed(level: int) -> void:
	GameManager.to_level(level)

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_reset_progress_pressed() -> void:
	GameManager.reset_progress()
