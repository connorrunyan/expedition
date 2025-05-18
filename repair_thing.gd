extends Node2D

@onready var brokeArt = $ThingBroken
@onready var fixedArt = $ThingNotBroken
@onready var progressBar = $ProgressBar

var is_broken = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_tree().get_nodes_in_group("Player").size() < 1:
		return
	var player = get_tree().get_nodes_in_group("Player")[0]
	var player_pos = player.global_position
	var our_pos = global_position
	var distance = abs((player_pos - our_pos).length())
	if distance <= Stats.repair_distance:
		var p = progressBar.value
		p += delta * Stats.repair_rate
		progressBar.value = p

func break_down():
	progressBar.visible = true
	brokeArt.visible = true
	fixedArt.visible = false
	progressBar.value = 0.0
	Stats.repairs_needed += 1

func repairs_complete():
	progressBar.visible = false
	brokeArt.visible = false
	fixedArt.visible = true
	Stats.repairs_needed -= 1

func _on_progress_bar_value_changed(value):
	if value >= 100.0:
		repairs_complete()
