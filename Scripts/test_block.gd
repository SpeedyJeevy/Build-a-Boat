extends RigidBody3D

@onready var inWater = false
@onready var waterFlowVel = Vector3(1.0, 0.0, 0.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
