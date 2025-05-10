extends Node2D

const SPEED = 500.0
const turn_speed = 1.0
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
	rotation = lerp_angle(rotation, target_rotation, turn_speed*delta) # TODO rework this to use a constant turn radius 
														# TODO so we don't have it turn faster the farther ur aiming
	
	var target_camera_pos = mouse_pos.lerp(global_position, 0.8)
	camera.global_position = target_camera_pos
	
	if Input.is_action_pressed("forward"):
		position+=rotation_to_direction(rotation) * -SPEED * delta
		left_tread_anim.play("tread_forward")
		right_tread_anim.play("tread_forward")
	elif Input.is_action_pressed("backward"):
		position+=rotation_to_direction(rotation) * SPEED * delta
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

func rotation_to_direction(rotation_radians: float) -> Vector2:
	# Convert rotation from degrees to radians (skip if already in radians)
	#var rotation_radians = deg_to_rad(rotation_degrees)
	
	# Calculate direction vector
	var direction = Vector2(cos(rotation_radians), sin(rotation_radians))
	
	# Normalize the vector (optional, but ensures length = 1)
	direction = direction.normalized()
	
	return direction
