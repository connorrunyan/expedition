extends Node

#progress stats
var progress_current = 0
var progress_normal_rate = 250 # per sec out of 10000
var progress_blocked_rate = 1 # per sec out of 10000
var repairs_needed = 0
var repair_rate = 10.0
var repair_distance = 1000.0

#Player Stats
var player_hp_current = 100.0
var player_hp_max = 100.0
var player_shield_current = 100.0
var player_shield_max = 100.0
var player_heat_current = 100.0
var player_heat_threshold = 100.0

var player_turn_radius = 90.0
var player_move_speed = 1000.0

var player_bullet_damage = 5.0
var player_laser_damage = 5.0

#Enemy Stats
var total_Level = 1
#Exploder Stats
var explode_Level = 20
var explode_movement_speed: float = 100.0
var explode_Damage: float = 2
var explode_MaxHealth: float = 10
var explode_detection_radius = 250
var explode_Radius: float = 300
var explode_Timer: float = 1.2

var explode_Level_Up_Walk_Speed: float = 0.05
var explode_Level_Up_Damage: float = 0.05
var explode_Level_Up_Radius_Increase: float = 0.05
#Charger Stats
var charge_Level = 0
var charge_movement_speed: float = 100.0
var charge_Damage: float = 2
var charge_MaxHealth: float = 10
var charge_WindUpTime = 2.0
var charge_chargeVelocity: float = 1000
var charge_ChargeDistance: float = 800

var charge_Level_Up_Charge_Speed: float = 0.05
var charge_Level_Up_Charge_Distance: float = 0.05
var charge_Level_Up_Walk_Speed: float = 0.05
var charge_Level_Up_Damage: float = 0.05
#SpikeStrip Stats
var spike_Level = 0
var spike_movement_speed: float = 100.0
var spike_Damage: float = 2
var spike_MaxHealth: float = 10
var spike_WindUpTime = 2.0
var spike_chargeVelocity: float = 1000
var spike_ChargeDistance: float = 800
var spike_drop_duration = 0.1

var spike_Spike_Duration = 5
var spike_Spike_Damage = 2


var spike_Level_Up_Charge_Speed: float = 0.05
var spike_Level_Up_Charge_Distance: float = 0.05
var spike_Level_Up_Walk_Speed: float = 0.05
var spike_Level_Up_Damage: float = 0.05
#Shooty Stats
var shooty_Level = 0
var shooty_movement_speed: float = 100.0
var shooty_Damage: float = 2
var shooty_MaxHealth: float = 10
var shooty_projectile_speed:float = 2000
