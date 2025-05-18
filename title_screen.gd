extends Control
@onready var title = $Title
@onready var credits = $"Credits container"

func _ready():
	MusicMan.finale_started()

func _on_end_pressed():
	get_tree().quit()

func _on_start_pressed():
	get_tree().change_scene_to_file("res://final_game_scene.tscn")


func _on_credits_pressed():
	if title.visible:
		title.visible = false
		credits.visible = true
	else:
		title.visible = true
		credits.visible = false
