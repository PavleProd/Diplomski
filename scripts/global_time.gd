extends Node

var start_time : int = 0
var current_time : int = -1

func start() -> void:
	start_time = Time.get_ticks_msec()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Format: MM min SS sec
	current_time = Time.get_ticks_msec() - start_time
	
 # time -> vreme u milisekundama
func time_to_string(time : int) -> String:
	var seconds = (time / 1000) % 60
	var minutes = time / 60000
	return str(minutes) + "m " + str(seconds) + "s"
