extends Control

var show_panel = false
@onready var panel = $VBoxContainer/Panel
@onready var player_bullet_dmg_label = $VBoxContainer/Panel/VBoxContainer/PlayerBulletDamageLabel
@onready var player_laser_dmg_label = $VBoxContainer/Panel/VBoxContainer/PlayerLaserDamageLabel
@onready var player_turn_radius_label = $VBoxContainer/Panel/VBoxContainer/PlayerTurnRadiusLabel
@onready var player_move_speed_label = $VBoxContainer/Panel/VBoxContainer/PlayerMoveSpeedLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("tab"):
		show_panel = !show_panel
		panel.visible = show_panel
	update_text()

func _on_button_pressed():
	show_panel = !show_panel
	panel.visible = show_panel

func update_text():
	player_bullet_dmg_label.text = "Player Bullet Damage : " + str(Stats.player_bullet_damage)
	player_laser_dmg_label.text = "Player Laser Damage : " + str(Stats.player_laser_damage)
	player_turn_radius_label.text = "Player Turn Radius : " + str(Stats.player_turn_radius)
	player_move_speed_label.text = "Player Move Speed : " + str(Stats.player_move_speed)
