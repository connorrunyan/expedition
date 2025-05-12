extends Enemy

enum State{WALK, CHARGE, WINDUP}

var current_State: State = State.WALK

var chargeDirection
var chargePosition: Vector2

@export var chargeTime = 2

@export var chargeVelocity: float = 500


@onready var charge_timer = $ChargeTimer
@onready var charge_duration = $ChargeDuration

@onready var enemy_sprite = $"Enemy Sprite"

@export var sprite: Node2D
@export var shake_amount: = 10.0
@onready var shake_duration: float  = charge_timer.wait_time
var current_shake = 0

var previousState: State = State.WALK

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Health <= 0:
		Die()
	
	match current_State:
		State.WALK:
			move_to_point(player.global_position)
		State.WINDUP:
			windUp(delta)
		State.CHARGE:
			charge(delta)
	
	if current_State != previousState:
		print(current_State)
		previousState = current_State
	
	move_and_slide()
	
func windUp(delta):
	current_shake += shake_amount * delta / shake_duration
	if current_shake < 0:
		current_shake = 0
	
	enemy_sprite.position = Vector2(randf_range(-current_shake, current_shake), randf_range(-current_shake, current_shake))
	
func charge(delta):
	velocity = chargeDirection * chargeVelocity
	
	
func Init_Charge():
	current_State = State.WINDUP
	charge_timer.start()
	velocity = Vector2(0,0)
	chargeDirection = global_position.direction_to(player.position)

func calcChargePosition():
	#for if we wanna indicate where they will go
	var displacement = chargeDirection * chargeVelocity * chargeTime
	
	chargePosition = displacement + position
	
func Die():
	queue_free()

func _Player_Entered_Radius(area):
	if current_State == State.WALK:
		Init_Charge()

func Player_Hit(body):
	if body.get_parent().has_method("take_damage"):
		print("HOW COULD YOU")
		body.get_parent().take_damage(Damage)

func _on_charge_timer_timeout():
	current_State = State.CHARGE
	current_shake = 0
	charge_duration.start()

func _on_charge_duration_timeout():
	current_State = State.WALK
	print("Walking")
