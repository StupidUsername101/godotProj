extends Node3D

@export var player_head: Node3D

@export var bullet_velocity_mult = 50

@onready var animation_player = $AnimationPlayer
@onready var bullet_spawn_point = $BulletSpawnPoint
const BulletScene = preload("res://scenes/bullet.tscn")

func shoot() -> void:
	if !player_head:
		return
		
	if animation_player.is_playing():
		return
		
	var bullet: RigidBody3D = BulletScene.instantiate()
	get_tree().root.add_child(bullet)
	bullet.global_transform = bullet_spawn_point.global_transform
	
	animation_player.play("Fire")
	
	var forward_dir: Vector3 = -player_head.global_transform.basis.z
	
	bullet.apply_central_impulse(forward_dir*bullet_velocity_mult)
