extends CharacterBody2D

var p_bullet = preload("res://bulletProjectile.tscn")
var p_laser = preload("res://laserProjectile.tscn")
var upgrade = preload("res://upgrade.tscn")

const turn_speed = 1.0
@onready var left_tread_anim = $LeftTread/LeftTreadAnimationPlayer
@onready var right_tread_anim = $RightTread/RightTreadAnimationPlayer
@onready var camera = $Camera2D
@onready var left_gun = $LeftGun
@onready var right_gun = $RightGun

const PUSH_FORCE = 300.0
const MIN_PUSH_FORCE = 250.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	var left_tread = 0
	var right_tread = 0
	if Input.is_action_pressed("left"):
		turn_left_wokie(delta)
		left_tread = 2
		right_tread = 1
	elif Input.is_action_pressed("right"):
		turn_right_magat(delta)
		left_tread = 1
		right_tread = 2
	
	if Input.is_action_pressed("forward"):
		velocity = rotation_to_direction(rotation) * -Stats.player_move_speed
		left_tread = 1
		right_tread = 1
	elif Input.is_action_pressed("backward"):
		velocity = rotation_to_direction(rotation) * Stats.player_move_speed
		left_tread = 2
		right_tread = 2
	else:
		velocity = Vector2(0,0)
	
	match left_tread:
		0:
			left_tread_anim.stop(true)
		1:
			left_tread_anim.play("tread_forward")
		2:
			left_tread_anim.play("tread_backward")
	match right_tread:
		0:
			right_tread_anim.stop(true)
		1:
			right_tread_anim.play("tread_forward")
		2:
			right_tread_anim.play("tread_backward")
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is CharacterBody2D:
			var push_force = (PUSH_FORCE * velocity.length() / Stats.player_move_speed) + MIN_PUSH_FORCE
			c.get_collider().velocity = (-c.get_normal() * push_force)
			print("Pushing")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var is_sliding = Input.is_action_pressed("slide")
	
	var mouse_pos:Vector2 = get_canvas_transform().affine_inverse() * get_viewport().get_mouse_position()
	var heading = (global_position - mouse_pos).normalized()
	var target_rotation = atan2(heading.y, heading.x)

	# TODO remove this, just for testing
	if Input.is_action_just_pressed("reload"):
		var u = upgrade.instantiate()
		u.position = mouse_pos
		get_node("/root").add_child(u)


	# rotate gun facing to face mouse
	# TODO add a rotation speed Stat
	left_gun.global_rotation = rotate_toward(left_gun.global_rotation, target_rotation+deg_to_rad(90.0), delta * 100)
	right_gun.global_rotation = rotate_toward(right_gun.global_rotation, target_rotation-deg_to_rad(90.0), delta * 100)
	
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
		var v = Vector2(minf(z, 10.0),minf(z, 10.0))  #TODO make camera zoom a stat? (potential bit)
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

func turn_left_wokie(delta):
	rotate(-(delta * deg_to_rad(Stats.player_turn_radius)))

func turn_right_magat(delta):
	rotate(+(delta * deg_to_rad(Stats.player_turn_radius)))

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
	var b = p_bullet.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	b.global_position = left_gun.global_position
	b.dir = rotation_to_direction(left_gun.global_rotation+deg_to_rad(90.0))
	get_tree().root.add_child(b)

func fire_right():
	var b = p_laser.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	b.global_position = right_gun.global_position
	b.dir = rotation_to_direction(right_gun.global_rotation-deg_to_rad(90.0))
	get_tree().root.add_child(b)

func take_damage(damage: float):
	for i in 99:
		print("Agony.")
	#get_tree().quit()
