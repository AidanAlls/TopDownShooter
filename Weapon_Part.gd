extends Node

class_name Weapon_Part

var level = 0
var name_segment

export var scale_mult_mod = 1
export var projectile_count_mod = 1
export var projectile_life_mod = 1 # how long it's alive/range 
export var projectile_speed_mod = 1
export var projectile_size_mult_mod = 2 # multiplied by 1 in Vector2D
export var projectile_color_mod = Color(1,1,1,1)
export var accuracy_mod = 0.2 # lower is more accurate
export var damage_mod = 1 # per projectile
export var energy_amount_mod = 0 # 'clip size'
export var energy_drain_mod = 0 # how much used per shot
export var energy_cooldown_mod = 0 # how much time before it recharges
export var energy_recharge_mod = 0 # how quickly it recharges
export var use_rate_mod = 1

func ready():
	name_segment = ""