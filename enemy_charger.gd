extends Enemy

enum State{WALK, CHARGE, WINDUP}

var current_State: State = State.WALK

var chargeDirection
var chargePosition: Vector2

@onready var charge_Shape = $"Detector/Charge Detection"
@onready var WindupTimer = $WindupTimer

@onready var enemy_sprite = $"Enemy Sprite"

var charge_Direction:Vector2 = Vector2(0,0)
var distance_Travelled:Vector2 = Vector2(0,0)

@export var sprite: Node2D
@export var shake_amount: = 10.0
@onready var shake_duration: float  = WindupTimer.wait_time

var current_shake: float = 10.0

func _ready():
	WindupTimer.wait_time = Stats.charge_WindUpTime
	Level = Stats.total_Level + Stats.charge_Level 
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Health <= 0:
		Die()
	
	match current_State:
		State.WALK:
			move_to_point(player.global_position)
			if position.distance_to(player.position) <= Stats.charge_ChargeDistance * (1 + Stats.charge_Level_Up_Charge_Distance*(Level-1)):
				Init_Charge()
		State.WINDUP:
			windUp(delta)
		State.CHARGE:
			charge(delta)
	
	move_and_slide()
	
func windUp(delta):
	current_shake += shake_amount * delta / shake_duration
	if current_shake < 0:
		current_shake = 0
	
	enemy_sprite.position = Vector2(randf_range(-current_shake, current_shake), randf_range(-current_shake, current_shake))
	
func charge(delta):
	velocity = chargeDirection * Stats.charge_chargeVelocity
	
	velocity *= (1 + Stats.charge_Level_Up_Charge_Speed*(Level-1))
	
	distance_Travelled += velocity * delta
	
	if distance_Travelled.length() > Stats.charge_ChargeDistance * (1 + Stats.charge_Level_Up_Charge_Distance*(Level-1)) * 2.1:
		current_State = State.WALK
		distance_Travelled = Vector2.ZERO
		
	
	
func Init_Charge():
	current_State = State.WINDUP
	velocity = Vector2(0,0)
	chargeDirection = global_position.direction_to(player.position)
	WindupTimer.start()
	
func Die():
	queue_free()

#TODO: Put the Damage Value in here, maybe increase it when the goober is charging
func Player_Hit(body):
	if body.has_method("take_damage"):
		body.take_damage(Damage)

func _on_charge_timer_timeout():
	current_State = State.CHARGE
	current_shake = 0

func _on_hurtbox_body_entered(body):
	Player_Hit(body)
