extends Node2D

var intro_popup = preload("res://IntroPopup.tscn")
var repair_popup = preload("res://RepairPopup.tscn")
var final_popup = preload("res://EndgamePopup.tscn")
@onready var canvas_layer = $CanvasLayer
@onready var textureRect = $CanvasLayer/TextureRect
var fade = 0

var shown_first_popup = false
var triggered_repair_1 = false
var triggered_repair_2 = false
var triggered_repair_3 = false
var triggered_repair_4 = false
var triggered_repair_5 = false
var triggered_repair_6 = false
var triggered_repair_7 = false
var triggered_repair_8 = false
var triggered_repair_9 = false
var triggered_final_rush = false
var triggered_last_ost = false

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	MusicMan._on_i_can_feel_it_coming_finished()
	rng.randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !shown_first_popup:
		shown_first_popup = true
		var pu = intro_popup.instantiate()
		canvas_layer.add_child(pu)
	
	var progress = Stats.progress_current
	if progress >= 1000 && !triggered_repair_1:
		triggered_repair_1 = true
		try_break_something()
		MusicMan.game_started()
		await get_tree().process_frame
		var pu = repair_popup.instantiate()
		canvas_layer.add_child(pu)
	if progress >= 2000 && !triggered_repair_2:
		triggered_repair_2 = true
		try_break_something()
	if progress >= 3000 && !triggered_repair_3:
		triggered_repair_3 = true
		try_break_something()
	if progress >= 4000 && !triggered_repair_4:
		triggered_repair_4 = true
		try_break_something()
	if progress >= 5000 && !triggered_repair_5:
		triggered_repair_5 = true
		try_break_something()
	if progress >= 6000 && !triggered_repair_6:
		triggered_repair_6 = true
		try_break_something()
	if progress >= 7000 && !triggered_repair_7:
		triggered_repair_7 = true
		try_break_something()
	if progress >= 8000 && !triggered_repair_8:
		triggered_repair_8 = true
		try_break_something()
	if progress >= 9000 && !triggered_repair_9:
		triggered_repair_9 = true
		try_break_something()
	if progress >= 10000 && !triggered_final_rush:
		triggered_final_rush = true
		try_break_everything()
		MusicMan.endgame_started()
		var pu = intro_popup.instantiate()
		canvas_layer.add_child(pu)
	
	if progress >= 10000 && triggered_final_rush && !triggered_last_ost && (Stats.repairs_needed <= 1):
		triggered_last_ost = true
		MusicMan.finale_started()
	
	if progress >= 10000 && Stats.repairs_needed == 0:
		var color = Color.WHITE
		color.a = fade
		textureRect.color = color
		fade += 1.0 * delta
		if fade > 255.0:
			# END GAME
			pass

func try_break_something():
	var breakables = get_tree().get_nodes_in_group("RepairThings")
	var broke_something = false
	# randomlly grab stuff till u find an unbroken then break it
	while !broke_something:
		var idx = rng.randi_range(0, breakables.size()-1)
		var breakable = breakables[idx]
		if !breakable.is_broken:
			breakable.break_down()
			broke_something = true


func try_break_everything():
	var breakables = get_tree().get_nodes_in_group("RepairThings")
	# break everything
	for i in breakables.size():
		var breakable = breakables[i]
		if !breakable.is_broken:
			breakable.break_down()
