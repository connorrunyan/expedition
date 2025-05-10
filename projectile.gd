extends Node2D

@onready var sprite = $Sprite2D
var dir = Vector2.DOWN
var speed = 1000.0
var color = Color.YELLOW

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.self_modulate = color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position += dir.normalized() * speed * delta
