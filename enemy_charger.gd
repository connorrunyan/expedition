extends Enemy

enum State{WALK, CHARGE, WINDUP}

var current_State: State = State.WALK

var chargeDirection
var chargePosition: Vector2

@export var WindUpTime = 2.0

@export var chargeVelocity: float = 1000
@export var ChargeDistance: float = 600
var distance_Travelled: Vector2 = Vector2(0, 0)

@onready var charge_Shape = $"Detector/Charge Detection"
@onready var WindupTimer = $WindupTimer

@onready var enemy_sprite = $"Enemy Sprite"

@export var sprite: Node2D
@export var shake_amount: = 10.0
@onready var shake_duration: float  = WindupTimer.wait_time
var current_shake = 0

var previousState: State = State.WALK

func _ready():
	WindupTimer.wait_time = WindUpTime

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Health <= 0:
		Die()
	
	match current_State:
		State.WALK:
			move_to_point(player.global_position)
			if position.distance_to(player.position) <= ChargeDistance:
				Init_Charge()
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
	
	distance_Travelled += chargeDirection * chargeVelocity * delta
	print(distance_Travelled.length())
	
	if distance_Travelled.length() > ChargeDistance * 2.1:
		current_State = State.WALK
		distance_Travelled = Vector2.ZERO
		
	
	
func Init_Charge():
	current_State = State.WINDUP
	velocity = Vector2(0,0)
	chargeDirection = global_position.direction_to(player.position)
	WindupTimer.start()
	
func Die():
	queue_free()

func Player_Hit(body):
	if body.has_method("take_damage"):
		body.take_damage(Damage)

func _on_charge_timer_timeout():
	print("WOWOWOW")
	current_State = State.CHARGE
	current_shake = 0

func _on_hurtbox_body_entered(body):
	Player_Hit(body)
