extends Node2D

const SPEED = 500.0

@onready var left_tread_anim = $LeftTread/LeftTreadAnimationPlayer
@onready var right_tread_anim = $RightTread/RightTreadAnimationPlayer

@onready var camera = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_pos:Vector2 = get_canvas_transform().affine_inverse() * get_viewport().get_mouse_position()
	var heading = (position - mouse_pos).normalized()
	var target_rotation = atan2(heading.y, heading.x)
	rotation = lerp_angle(rotation, target_rotation, 0.1)
	
	if Input.is_action_pressed("forward"):
		position+=heading * -SPEED * delta
		left_tread_anim.play("tread_forward")
		right_tread_anim.play("tread_forward")
	elif Input.is_action_pressed("backward"):
		position+=heading * SPEED * delta
		left_tread_anim.play("tread_backward")
		right_tread_anim.play("tread_backward")
	else:
		left_tread_anim.stop()
		right_tread_anim.stop()
	
	if Input.is_action_just_pressed("zoom_in"):
		print("zoin")
		var z = camera.zoom.x
		z += 0.05
		var v = Vector2(minf(z, 2.0),minf(z, 2.0))
		camera.zoom = v
	elif Input.is_action_just_pressed("zoom_out"):
		print("zoiut")
		var z = camera.zoom.x
		z -= 0.05
		var v = Vector2(maxf(z, 0.25),maxf(z, 0.25))
		camera.zoom = v

func _input(event):
	pass
