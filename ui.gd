extends Control

@onready var label = $MarginContainer/Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var t = "player_hp_current/player_hp_max: " + str(Stats.player_hp_current) + " / " + str(Stats.player_hp_max)
	t = t + "\nplayer_shield_current/player_shield_max: " + str(Stats.player_shield_current) + " / " + str(Stats.player_shield_max)
	t = t + "\nplayer_heat_current/player_heat_threshold: " + str(Stats.player_heat_current) + " / " + str(Stats.player_heat_threshold)
	t = t + "\nplayer_turn_radius: " + str(Stats.player_turn_radius)
	t = t + "\nplayer_move_speed: " + str(Stats.player_move_speed)
	label.text = t
