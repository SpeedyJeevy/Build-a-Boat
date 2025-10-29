extends RigidBody3D

@onready var sitting = false
@onready var player = null
@onready var inWater = false
@onready var waterFlowVel = Vector3(1.0, 0.0, 0.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ChairArea.body_entered.connect(_on_body_entered)
	$ChairArea.body_exited.connect(_on_body_exited)

# Player near chair
func _on_body_entered(body):
	if body.is_in_group("player"):  # Make sure your player is in the "Player" group
		player = body

func _on_body_exited(body):
	if body == player:
		player = null
		sitting = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player and Input.is_action_just_pressed("right_click"):
		sitting = !sitting
	
	if sitting and player:
		player.global_position = self.global_position + Vector3(0, 1.25, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Water touching logic
	if inWater:
		linear_velocity = waterFlowVel

# Interact with water function
func enterWater():
	inWater = true
func exitWater():
	inWater = false
	linear_velocity = Vector3.ZERO
