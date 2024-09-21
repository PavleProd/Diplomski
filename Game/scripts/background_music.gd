extends AudioStreamPlayer2D

const ENTRANCE_MUSIC_PATH = "res://assets/music/music_entrance.wav"
const LOOP_MUSIC_PATH = "res://assets/music/music_loop.mp3"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stream = preload(ENTRANCE_MUSIC_PATH)
	play()

# Entrance muzika je zavrsena, krece loop muzika
func _on_finished() -> void:
	stream = preload(LOOP_MUSIC_PATH)
	play()
