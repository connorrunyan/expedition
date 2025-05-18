extends Node2D

@onready var sprite = $Sprite2D
var dir = Vector2.DOWN
var speed = 2000.0

var Projectile_Duration = 20.0
var Projectile_Timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position += dir.normalized() * Stats.shooty_projectile_speed * delta
	rotate(10.0 * delta)
	
	Projectile_Timer += delta
	if Projectile_Timer >= Projectile_Duration:
		queue_free()

func _on_area_2d_body_entered(body):
	if body.has_method("take_damage") && body.is_in_group("Player"):
		body.take_damage(Stats.shooty_Damage)
