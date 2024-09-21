extends Node

const MIN_TIME := 1
const MAX_TIME := 2

signal on_timer_timeout

@onready var timer: Timer = $Timer
func restart() -> void:
	timer.stop()
	timer.one_shot = true
	timer.wait_time = randi_range(MIN_TIME, MAX_TIME)
	timer.start()
	
func stop() -> void:
	timer.stop()

func _on_timer_timeout() -> void:
	on_timer_timeout.emit()
