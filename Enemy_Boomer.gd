extends Enemy

enum State{ATTACK, WINDUP, KABOOM}

var current_State: State = State.ATTACK

@onready var explosion_duration = $ExplosionDuration
@onready var explosion_sprite = $Explosion/ExplosionSprite
@onready var explosion = $Explosion
@onready var navMesh = get_tree().get_first_node_in_group("NavMesh")
@onready var navigation_agent_2d = $NavigationAgent2D
@onready var explosion_Hurtbox = $Explosion/ExplosionRadius

@onready var explode_Health: float = Stats.explode_MaxHealth

var target_color:Color = Color(1,0,0,1)

var explode_timer = 0.0
var explode_wind_up = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_nav_timer_timeout()
	
	Level = Stats.total_Level + Stats.explode_Level
	
	explosion_sprite.scale = Vector2(explosion_sprite.scale.x * Stats.explode_Radius*(1 + Stats.explode_Level_Up_Radius_Increase*(Level-1))/Stats.explode_Radius, explosion_sprite.scale.y * Stats.explode_Radius*(1 + Stats.explode_Level_Up_Radius_Increase*(Level-1))/Stats.explode_Radius)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Health <= 0 && current_State != State.KABOOM:
		Die()
	if current_State == State.ATTACK:
		Navigate(player.global_position)
		if position.distance_to(player.position) <= Stats.explode_detection_radius * (1 + Stats.explode_Level_Up_Radius_Increase*(Level-1)):
			Die()
	elif current_State == State.WINDUP:
		Explode(delta)
	move_and_slide()

func Navigate(Point):
	var direction = Vector2()
	
	navigation_agent_2d.set_target_position(Point)
	direction = navigation_agent_2d.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = direction * movement_speed
	velocity *= (1 + Stats.explode_Level_Up_Walk_Speed*(Level-1))

func Die():
	current_State = State.WINDUP
	var t: Tween = create_tween()
	t.tween_property(self, "modulate", Color.RED, Stats.explode_Timer * 0.9)
	velocity = Vector2(0,0)
	
	
func Explode(delta):
	#modulate = lerp(modulate, target_color, delta*10)
	velocity = lerp(velocity, Vector2(0,0), 0.01)
	explode_wind_up += delta
	if explode_wind_up >= Stats.explode_Timer:
		Kaboom()
	
func _Player_Entered_Radius(area):
	Die()

func Kaboom():
	explosion_duration.start()
	explosion_sprite.visible = true
	explosion.monitoring = true
	current_State = State.KABOOM
	#This is where we'd put some an animation for the sprite.

#TODO: Put the Damage Value in here
func Player_Hit(body):
	if body.has_method("take_damage"):
		body.take_damage(Damage)

func _on_explosion_duration_timeout():
	queue_free()

func _on_nav_timer_timeout():
	navigation_agent_2d.set_target_position(player.global_position)
