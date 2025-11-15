extends RigidBody3D

# Health - Hits the object can take
# Endurance - Makes the block sturdier (in case I wanna have upgrades of sorts or health restore stuff)
# Luck - Chance to not take damage (maybe create fun blocks with high luck but can only take 1 hit if unlucky)
@onready var health = 5
@onready var endurance = 1
@onready var luck = 0

@onready var inWater = false
@onready var waterFlowVel = Vector3(2.0, 0.0, 0.0)

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
