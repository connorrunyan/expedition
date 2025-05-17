extends Node2D

# TODO get into credits: https://godotshaders.com/shader/flaring-star/

@onready var color_rect = $ColorRect

var brightness = 0.1
var ray_brightness = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	brightness += (delta * 0.01)
	ray_brightness += (delta * 0.1)
	color_rect.material.set_shader_parameter("brightness", brightness)
