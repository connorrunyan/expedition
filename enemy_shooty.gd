extends Enemy

@onready var navMesh = get_tree().get_first_node_in_group("NavMesh")
@onready var navigation_agent_2d = $NavigationAgent2D
@onready var explosion_Hurtbox = $Explosion/ExplosionRadius

@onready var health: float = Stats.explode_MaxHealth

var shootTimer = 0.0
var shootTimerDuration = 2
const PROJECTILE = preload("res://projectile.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	_on_nav_timer_timeout()
	
	Level = Stats.total_Level + Stats.shooty_Level

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Health <= 0:
		Die()
		
	Navigate(player.global_position)
	
	shootTimer += delta
	
	if shootTimer >= shootTimerDuration:
		shoot()

	move_and_slide()

func shoot():
	var b = PROJECTILE.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	b.global_position = global_position
	b.dir = position.direction_to(player.position)
	get_tree().root.add_child(b)
	shootTimer = 0.0

func Navigate(Point):
	var direction = Vector2()
	
	navigation_agent_2d.set_target_position(Point)
	direction = navigation_agent_2d.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = direction * movement_speed
	velocity *= (1 + Stats.explode_Level_Up_Walk_Speed*(Level-1))

func Die():
	queue_free()
	
func _Player_Entered_Radius(area):
	print("Player entered Radius")
	Die()

func _on_nav_timer_timeout():
	navigation_agent_2d.set_target_position(player.global_position)
