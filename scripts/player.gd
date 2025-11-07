extends Node3D
@export var movement_speed = .1
@export var mouse_sensitivity = .01

@onready var revolver = $Head/revolver
@onready var head = $Head

var current_head_pitch := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)  # left/right (yaw)
		current_head_pitch -= event.relative.y * mouse_sensitivity     # up/down (pitch)
		current_head_pitch = clamp(current_head_pitch, deg_to_rad(-89), deg_to_rad(89))
		head.rotation.x = current_head_pitch

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("move-forward"):
		self.translate(movement_speed * Vector3.FORWARD)
	if Input.is_action_pressed("move-back"):
		self.translate(movement_speed * -Vector3.FORWARD)
	if Input.is_action_pressed("move-left"):
		self.translate(movement_speed * Vector3.LEFT)
	if Input.is_action_pressed("move-right"):
		self.translate(movement_speed * -Vector3.LEFT)
	if Input.is_action_just_pressed("use-righthand-item"):
		revolver.shoot()
