extends Node2D

var sound_spawn = preload("res://upgrade_sound_spawn.tscn")

@onready var panel: Panel = $Panel
@onready var timer: Timer = $Panel/VBoxContainer/HBoxContainer2/DespawnTimerLabel/Timer
@onready var timerLabel = $Panel/VBoxContainer/HBoxContainer2/DespawnTimerLabel
@onready var rarityColorRect = $Panel/VBoxContainer/RarityColorRect
@onready var upsideLabel = $Panel/VBoxContainer/HBoxContainer/UpsideLabel
@onready var downsideLabel = $Panel/VBoxContainer/HBoxContainer/DownsideLabel

var rng = RandomNumberGenerator.new()

var mouse_hovered = false
var upside: upgrade_data
var downside: upgrade_data

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	setup(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timerLabel.text = ("%02.1f" % timer.time_left) + " "
	
	if mouse_hovered:
		panel.self_modulate = Color.WHITE
	else:
		panel.self_modulate = Color.BLACK
	
	if Input.is_action_just_pressed("interact") && mouse_hovered:
		apply_upgrade()

# TODO can make enum. for now 0 = random, 1 = normal, 2= blue 3= purp, 4= gold
func setup(rarity: int):
	# select random rarity, if needed
	if rarity == 0:
		var r = rng.randi_range(0, 100)
		if r == 100:
			rarity = 4
		elif r >= 85:
			rarity = 3
		elif r>= 50:
			rarity = 2
		else:
			rarity = 1
	
	# apply rarity to color rect
	match rarity:
		1:
			rarityColorRect.color = Color.WHITE_SMOKE
			select_upside(normal_upsides)
			select_downside(normal_downsides)
		2:
			rarityColorRect.color = Color.ROYAL_BLUE
			select_upside(rare_upsides)
			select_downside(rare_downsides)
		3:
			rarityColorRect.color = Color.REBECCA_PURPLE
			select_upside(legendary_upsides)
			select_downside(legendary_downsides)
		4:
			rarityColorRect.color = Color.GOLDENROD
			select_upside(exotic_upsides)
			select_downside(exotic_downsides)
	
	upsideLabel.text = upside.description % upside.magnitude
	downsideLabel.text = downside.description % downside.magnitude
	
	
func apply_upgrade():
	print("applying upgrade!!!!!!!!!")
	Stats[upside.stat] = Stats[upside.stat] + upside.magnitude
	Stats[downside.stat] = Stats[downside.stat] + downside.magnitude
	var s = sound_spawn.instantiate()
	get_node("/root").add_child(s)
	await get_tree().process_frame 
	queue_free()

func select_upside(list: Array):
	var idx = rng.randi_range(0, list.size()-1)
	upside = list.get(idx)

func select_downside(list: Array):
	var idx = rng.randi_range(0, list.size()-1)
	downside = list.get(idx)

# when time runs out, despawn the upgrade
func _on_timer_timeout():
	queue_free()

func _on_panel_mouse_entered():
	mouse_hovered = true

func _on_panel_mouse_exited():
	mouse_hovered = false
	

var normal_upsides = [
	upgrade_data.new("+%d\nPlayer HP", "player_hp_current", 1),
	upgrade_data.new("+%d\nPlayer Bullet Damage", "player_bullet_damage", 1),
	upgrade_data.new("+%d\nPlayer Turn Radius", "player_turn_radius", 1),
	upgrade_data.new("+%d\nPlayer Move Speed", "player_move_speed", 20),
	upgrade_data.new("+%d\nPlayer Health", "player_hp_current", 10),
	upgrade_data.new("+%d\nPlayer Turn Speed", "player_turn_radius", 5),
	upgrade_data.new("+%d\nExplosion Wind Up", "explode_Timer", 0.2),
	upgrade_data.new("+%d\nExplosionsion Detection Radius", "explode_detection_radius", +30),
	]
	
var normal_downsides = [
	upgrade_data.new("%d\nPlayer Bullet Damage", "player_bullet_damage", -1),
	upgrade_data.new("%d\nPlayer Turn Radius", "player_turn_radius", -1),
	upgrade_data.new("%d\nPlayer Move Speed", "player_move_speed", -20),
	upgrade_data.new("+%d\nExploder Move Speed", "explode_movement_speed", 10),
	upgrade_data.new("+%d\nCharger Move Speed", "charge_movement_speed", 10),
	upgrade_data.new("+%d\nSpike Strip Move Speed", "spike_movement_speed", 10),
	upgrade_data.new("+%d\nExploder Level", "explode_Level", 1),
	upgrade_data.new("+%d\nCharger Level", "charge_Level", 1),
	upgrade_data.new("+%d\nSpike Strip Level", "spike_Level", 1),
	upgrade_data.new("+%d\nShooter Level", "shooty_Level", 1),
	upgrade_data.new("%d\nPlayer Move Speed", "player_move_speed", -100),
	upgrade_data.new("+%d\nExploder Damage", "explode_Damage", 1),
	upgrade_data.new("+%d\nCharger WindUp Time", "charge_WindUpTime", 1),
	upgrade_data.new("+%d\nCharger Charge Velocity", "charge_chargeVelocity", 100),
	upgrade_data.new("+%d\nCharger Charge Distance", "charge_ChargeDistance", 100),
	upgrade_data.new("+%d\nSpike Strip Charge Distance", "spike_ChargeDistance", 100),
	upgrade_data.new("+%d\nCharger Charge Damage", "charge_Damage", 2),
	upgrade_data.new("+%d\nSpike Strip WindUp Time", "spike_WindUpTime", 1),
	upgrade_data.new("+%d\nSpike Strip Charge Velocity", "spike_chargeVelocity", 100),
	upgrade_data.new("+%d\nShooty movement speed", "shooty_movement_speed", 100),
	upgrade_data.new("+%d\nShooty Damage", "shooty_Damage", 1),
	upgrade_data.new("+%d\nShooty Projectile Speed", "shooty_projectile_speed", 100),
	]
	
var rare_upsides = [
	upgrade_data.new("+%d\nPlayer HP", "player_hp_current", 3),
	upgrade_data.new("+%d\nPlayer Bullet Damage", "player_bullet_damage", 3),
	upgrade_data.new("+%d\nPlayer Turn Radius", "player_turn_radius", 3),
	upgrade_data.new("+%d\nPlayer Move Speed", "player_move_speed", 50),
	upgrade_data.new("%d\nExploder Damage", "explode_Damage", -1),
	upgrade_data.new("+%d\nExplosion Wind Up", "explode_Timer", 0.5),
	upgrade_data.new("%d\nCharger Charge Velocity", "charge_chargeVelocity", -300),
	upgrade_data.new("%d\nExploder Damage", "explode_Damage", -1),
	upgrade_data.new("%d\nCharger Charge Damage", "charge_Damage", -1),
	]
	
var rare_downsides = [
	upgrade_data.new("%d\nPlayer Bullet Damage", "player_bullet_damage", -2),
	upgrade_data.new("%d\nPlayer Turn Radius", "player_turn_radius", -2),
	upgrade_data.new("%d\nPlayer Move Speed", "player_move_speed", -30),
	upgrade_data.new("+%d\nExploder Level", "explode_Level", 2),
	upgrade_data.new("+%d\nCharger Level", "charge_Level", 2),
	upgrade_data.new("+%d\nSpike Strip Level", "spike_Level", 2),
	upgrade_data.new("+%d\nShooter Level", "shooty_Level", 2),
	]
	
var legendary_upsides = [
	upgrade_data.new("+%d\nPlayer HP", "player_hp_current", 10),
	upgrade_data.new("+%d\nPlayer Bullet Damage", "player_bullet_damage", 10),
	upgrade_data.new("+%d\nPlayer Turn Radius", "player_turn_radius", 10),
	upgrade_data.new("+%d\nPlayer Move Speed", "player_move_speed", 150),
	]
	
var legendary_downsides = [
	upgrade_data.new("%d\nPlayer Bullet Damage", "player_bullet_damage", -10),
	upgrade_data.new("%d\nPlayer Turn Radius", "player_turn_radius", -6),
	upgrade_data.new("%d\nPlayer Move Speed", "player_move_speed", -70),
	]
	
var exotic_upsides = [
	upgrade_data.new("+%d\nPlayer HP", "player_hp_current", 50),
	upgrade_data.new("+%d\nPlayer Bullet Damage", "player_bullet_damage", 50),
	upgrade_data.new("+%d\nPlayer Turn Radius", "player_turn_radius", 50),
	upgrade_data.new("+%d\nPlayer Move Speed", "player_move_speed", 500),
	]
	
var exotic_downsides = [
	upgrade_data.new("%d\nPlayer Bullet Damage", "player_bullet_damage", -15),
	upgrade_data.new("%d\nPlayer Turn Radius", "player_turn_radius", -15),
	upgrade_data.new("%d\nPlayer Move Speed", "player_move_speed", -200),
	]
