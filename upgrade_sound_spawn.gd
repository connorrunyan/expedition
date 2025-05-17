extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_audio_stream_player_2d_finished():
	queue_free()
