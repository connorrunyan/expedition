extends Node2D

var intro_popup = preload("res://IntroPopup.tscn")
var repair_popup = preload("res://RepairPopup.tscn")
var final_popup = preload("res://EndgamePopup.tscn")
var death_popup = preload("res://DeathPopup.tscn")
var victory_popup = preload("res://VictoryPopup.tscn")

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

var triggered_bonus_spawns_1 = false
var triggered_bonus_spawns_2 = false
var triggered_bonus_spawns_3 = false
var triggered_bonus_spawns_4 = false

var rng = RandomNumberGenerator.new()

const e_SPIKE_STRIP = preload("res://EnemySpikeStrip.tscn")
const e_EXPLODER = preload("res://EnemyExploder.tscn")
const e_CHARGER = preload("res://EnemyCharger.tscn")
const e_SHOOTY = preload("res://EnemyShooty.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
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
	
	if progress >= 10000 && triggered_final_rush && Stats.repairs_needed < 5 && !triggered_bonus_spawns_1:
		triggered_bonus_spawns_1 = true
		spawn_more_broken()
	
	if progress >= 10000 && triggered_final_rush && Stats.repairs_needed < 4 && !triggered_bonus_spawns_2:
		triggered_bonus_spawns_2 = true
		spawn_more_broken()
		
	if progress >= 10000 && triggered_final_rush && Stats.repairs_needed < 3 && !triggered_bonus_spawns_3:
		triggered_bonus_spawns_3 = true
		spawn_more_broken()
		
	if progress >= 10000 && triggered_final_rush && Stats.repairs_needed < 2 && !triggered_bonus_spawns_4:
		triggered_bonus_spawns_4 = true
		spawn_more_broken()
	
	if progress >= 10000 && triggered_final_rush && !triggered_last_ost && (Stats.repairs_needed <= 1):
		triggered_last_ost = true
		MusicMan.finale_started()
	
	if progress >= 10000 && Stats.repairs_needed == 0:
		var color = Color.WHITE
		color.a = fade
		textureRect.color = color
		fade += 0.1 * delta
		if fade >= 1:
			clear_enemies()
			var pu = victory_popup.instantiate()
			pu.go_title = true
			canvas_layer.add_child(pu)
	
	if Stats.player_hp_current <= 0:
		var color = Color.RED
		color.a = fade
		textureRect.color = color
		fade += 0.1 * delta
		if fade >= 1:
			clear_enemies()
			var pu = death_popup.instantiate()
			pu.go_title = true
			canvas_layer.add_child(pu)
			MusicMan.title()

func Roll_Enemy(Pos: Vector2 ):
	var e
	var Chance =  rng.randi_range(1, 100)
	
	if Chance <= 25:
		e = e_EXPLODER.instantiate()
		e.position = Pos
		get_node("/root").add_child(e)
	elif Chance <= 50:
		e = e_SHOOTY.instantiate()
		e.position = Pos
		get_node("/root").add_child(e)
	elif Chance <= 80:
		e = e_CHARGER.instantiate()
		e.position = Pos
		get_node("/root").add_child(e)
	elif Chance <= 100:
		e = e_SPIKE_STRIP.instantiate()
		e.position = Pos
		get_node("/root").add_child(e)
		

func clear_enemies():
	var en = get_tree().get_nodes_in_group("Enemy")
	for e in en:
		e.queue_free()

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
			Roll_Enemy(breakable.position)
			if Stats.progress_current >= 2500:
				Roll_Enemy(breakable.position + (Vector2.UP * 50.0))
			if Stats.progress_current >= 5000:
				Roll_Enemy(breakable.position + (Vector2.DOWN * 50.0))
			if Stats.progress_current >= 7500:
				Roll_Enemy(breakable.position + (Vector2.LEFT * 50.0))
			if Stats.progress_current >= 10000:
				Roll_Enemy(breakable.position + (Vector2.RIGHT * 50.0))

func spawn_more_broken():
	var breakables = get_tree().get_nodes_in_group("RepairThings")
	for breakable in breakables:
		Roll_Enemy(breakable.position)
		Roll_Enemy(breakable.position + (Vector2.UP * 50.0))
		Roll_Enemy(breakable.position + (Vector2.DOWN * 50.0))
		Roll_Enemy(breakable.position + (Vector2.LEFT * 50.0))
		Roll_Enemy(breakable.position + (Vector2.RIGHT * 50.0))


func try_break_everything():
	var breakables = get_tree().get_nodes_in_group("RepairThings")
	# break everything
	for i in breakables.size():
		var breakable = breakables[i]
		if !breakable.is_broken:
			breakable.break_down()


func _on_background_spawns_timer_timeout():
	print("spawn")
	var p = $PlayerBot.global_position
	var offset = Vector2(rng.randf(), rng.randf()).normalized()
	Roll_Enemy(p + (offset * 3000))
