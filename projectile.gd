extends Node2D

@onready var sprite = $Sprite2D
var dir = Vector2.DOWN
var speed = 3000.0
var damage = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position += dir.normalized() * speed * delta
	rotate(10.0 * delta)


func _on_area_2d_body_entered(body):
	if body.has_method("takeDamage"):
		body.takeDamage(damage)
