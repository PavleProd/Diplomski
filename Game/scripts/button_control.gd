extends Control

func _ready() -> void:
	init_level_buttons()
	set_record_time()
#---------------------------------------------------------------------------------
func init_level_buttons() -> void:
	for i in range(1, GameManager.NUM_LEVELS + 1):
		var button : Button = get_node("Level" + str(i))
		# konektovanje na kliktanje
		if button == null:
			Logger.error("Objekat nije prepoznat kao dugme!")
			continue
			
		button.pressed.connect(Callable(_on_go_to_level_pressed).bind(i))
		if GameManager.user_data["max_level"] < i:
			button.disabled = true
#---------------------------------------------------------------------------------
@onready var record_time_value: Label = $RecordTimeValue
func set_record_time() -> void:
	var level_data = GameManager.user_data["levels"][GameManager.current_level - 1]
	var record_time = level_data["record_time"]
	if record_time != 0:
		record_time_value.text = GlobalTime.time_to_string(record_time)
#---------------------------------------------------------------------------------
@onready var current_time_value: Label = $CurrentTimeValue		
func _process(delta: float) -> void:
	current_time_value.text = GlobalTime.time_to_string(GlobalTime.current_time)
#---------------------------------------------------------------------------------
func _on_reset_level_pressed() -> void:
	# radimo to_level jer hocemo da restartujemo tajmere i ostale stvari
	GameManager.to_level(GameManager.current_level)
#---------------------------------------------------------------------------------
func _on_exit_pressed() -> void:
	get_tree().quit()
#---------------------------------------------------------------------------------
func _on_go_to_level_pressed(level: int) -> void:
	GameManager.to_level(level)
