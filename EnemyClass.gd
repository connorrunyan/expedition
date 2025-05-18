extends CharacterBody2D
class_name Enemy

@onready var player = get_tree().get_first_node_in_group("Player")

@export var movement_speed: float = 100.0
@export var Damage: float = 2
@export var MaxHealth: float = 10
@export var Health: float = MaxHealth
@export var Level: float = 1

var rng = RandomNumberGenerator.new()

const UPGRADE = preload("res://upgrade.tscn")
#TODO: Think about what stuff every enemy needs.
#TODO: Write a pathfinding function.
#TODO: Extend this into the little explody guy

func takeDamage(damage: float):
	Health = Health - Damage

func Die():
	drop_Chance()
	queue_free()

func drop_Chance():
	var chance = rng.randi_range(1, 100)
	
	print(chance)
	
	if chance + Stats.player_Luck >= 50:
		Stats.player_Luck = 0
		drop_Loot()
	else:
		Stats.player_Luck += 2

func drop_Loot():
	var u = UPGRADE.instantiate()
	u.position = position
	get_node("/root").add_child(u)

func move_to_point(point: Vector2):
	var direction = global_position.direction_to(point)
	
	velocity = direction * movement_speed
	#velocity *= (1 + Level_Up_Walk_Speed*(Level-1))
