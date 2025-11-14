extends CharacterBody3D

@export var gravity: float = 9
@export var movement_speed = 10
@export var mouse_sensitivity = .01
@export var jump_force: float = 10

@onready var revolver = $Head/revolver
@onready var head = $Head
@onready var ray: RayCast3D = $Head/RayCast3D

var current_grav_mult := 1.0
var current_head_pitch := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().get_root().grab_focus()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	ray.enabled = true
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)  # left/right (yaw)
		current_head_pitch -= event.relative.y * mouse_sensitivity     # up/down (pitch)
		current_head_pitch = clamp(current_head_pitch, deg_to_rad(-89), deg_to_rad(89))
		head.rotation.x = current_head_pitch
		
func _physics_process(delta):
	if not is_on_floor():
		current_grav_mult += .35
		velocity.y -= gravity * delta * current_grav_mult
	else:
		current_grav_mult = 0
		
	var dir = Input.get_vector("move-left", "move-right", "move-back", "move-forward")
	var forward = -transform.basis.z
	var right = transform.basis.x
	var direction = (forward * dir.y + right * dir.x).normalized()

	if direction != Vector3.ZERO:
		velocity.z = direction.z * movement_speed
		velocity.x = direction.x * movement_speed
	else:
		# Stop movement slowly when no input
		velocity.x = lerp(velocity.x, 0.0, 0.2)
		velocity.z = lerp(velocity.z, 0.0, 0.2)
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
	
	var current_vel = velocity * 1.1
	if move_and_slide():
		var collision: KinematicCollision3D = get_last_slide_collision()
		var collider = collision.get_collider()
		
		if collider is RigidBody3D:
			# prevent sliding with the collider (works good enough)
			velocity.x = 0
			velocity.z = 0
			collider.apply_central_impulse(current_vel)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("use"):
		if not ray.is_colliding():
			return
			
		var collider = ray.get_collider()
		var position: Vector3 = ray.get_collision_point()
		if collider.is_in_group(Group.FIELD):
			var field := collider as Crop_Field
			field.digg(position) #todo: add crop
