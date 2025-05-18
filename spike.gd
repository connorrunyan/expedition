extends Node2D

@export var rotation_speed = 4

var Spike_Timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation += rotation_speed * delta
	
	Spike_Timer += delta
	if Spike_Timer >= Stats.spike_Spike_Duration:
		queue_free()
		

func _on_spike_Stepped(body):
	if body.has_method("take_damage"):
		body.take_damage(Stats.spike_Spike_Damage)
		queue_free()
