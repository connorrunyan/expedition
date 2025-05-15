extends CharacterBody2D

var p = preload("res://projectile.tscn")

const turn_speed = 1.0
@onready var left_tread_anim = $LeftTread/LeftTreadAnimationPlayer
@onready var right_tread_anim = $RightTread/RightTreadAnimationPlayer
@onready var camera = $Camera2D
@onready var left_gun = $LeftGun
@onready var right_gun = $RightGun

const PUSH_FORCE = 250.0
const MIN_PUSH_FORCE = 150.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_pressed("forward"):
		velocity = rotation_to_direction(rotation) * -Stats.player_move_speed
		left_tread_anim.play("tread_forward")
		right_tread_anim.play("tread_forward")
	elif Input.is_action_pressed("backward"):
		velocity = rotation_to_direction(rotation) * Stats.player_move_speed
		left_tread_anim.play("tread_backward")
		right_tread_anim.play("tread_backward")
	else:
		left_tread_anim.stop()
		right_tread_anim.stop()
		velocity = Vector2(0,0)
	move_and_slide()
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is CharacterBody2D:
			var push_force = (PUSH_FORCE * velocity.length() / Stats.player_move_speed) + MIN_PUSH_FORCE
			c.get_collider().velocity = (-c.get_normal() * push_force)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var is_sliding = Input.is_action_pressed("slide")
	
	var mouse_pos:Vector2 = get_canvas_transform().affine_inverse() * get_viewport().get_mouse_position()
	var heading = (global_position - mouse_pos).normalized()
	var target_rotation = atan2(heading.y, heading.x)
	var turn_radius = deg_to_rad(Stats.player_turn_radius)
	var slide_mod = 1.0
	if is_sliding:
		slide_mod = 0.1
	rotation = rotate_toward(rotation, target_rotation, delta * Stats.player_turn_radius * slide_mod)

	# rotate gun facing to face mouse
	# TODO add a rotation speed Stat
	left_gun.global_rotation = rotate_toward(left_gun.global_rotation, target_rotation+90.0, delta * 100)
	right_gun.global_rotation = rotate_toward(right_gun.global_rotation, target_rotation-90.0, delta * 100)
	
	# cap gun facing bounds to a certain arc.  turn this into a Stat
	if left_gun.rotation_degrees > 80.0:
		left_gun.rotation_degrees = 80.0
	if left_gun.rotation_degrees < -80.0:
		left_gun.rotation_degrees = -80.0
	if right_gun.rotation_degrees > 80.0:
		right_gun.rotation_degrees = 80.0
	if right_gun.rotation_degrees < -80.0:
		right_gun.rotation_degrees = -80.0
	

	
	var target_camera_pos = mouse_pos.lerp(global_position, 0.8)
	camera.global_position = target_camera_pos
	
	if Input.is_action_just_pressed("zoom_in"):
		var z = camera.zoom.x
		z += 0.05
		var v = Vector2(minf(z, 2.0),minf(z, 2.0))  #TODO make camera zoom a stat? (potential bit)
		camera.zoom = v
	elif Input.is_action_just_pressed("zoom_out"):
		var z = camera.zoom.x
		z -= 0.05
		var v = Vector2(maxf(z, 0.25),maxf(z, 0.25))
		camera.zoom = v
	
	if Input.is_action_just_pressed("fire_left"):
		fire_left()
	
	if Input.is_action_just_pressed("fire_right"):
		fire_right()

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

# TODO speed of the player should prob be added to these?
func fire_left():
	var b = p.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	b.color = Color.YELLOW
	b.global_position = left_gun.global_position
	b.dir = rotation_to_direction(left_gun.global_rotation+deg_to_rad(90.0))
	get_tree().root.add_child(b)

func fire_right():
	var b = p.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	b.color = Color.RED
	b.global_position = right_gun.global_position
	b.dir = rotation_to_direction(right_gun.global_rotation-deg_to_rad(90.0))
	get_tree().root.add_child(b)

func take_damage(damage: float):
	print("Agony.")
	get_tree().quit()
