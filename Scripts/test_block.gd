extends RigidBody3D

# Health - Hits the object can take
# Endurance - Makes the block sturdier (in case I wanna have upgrades of sorts or health restore stuff)
# Luck - Chance to not take damage (maybe create fun blocks with high luck but can only take 1 hit if unlucky)
@onready var health = 5.0
@onready var endurance = 1
@onready var luck = 0

@onready var hit = false
@onready var inWater = false
@onready var touchWater = 0
@onready var waterFlowVel = Vector3(4.0, 0.0, 0.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Kill the block when it dies
	dies()
		
	# Water touching logic
	if inWater:
		linear_velocity = waterFlowVel
	
	# Block touching logic
	if hit:
		health -= (1 / endurance)
		

# Interact with water function
func enterWater():
	touchWater += 1
	inWater = true
func exitWater():
	touchWater -= 1
	if touchWater <= 0:
		inWater = false
		linear_velocity = Vector3.ZERO

# Hitting a damaging object function
func hitObject():
	hit = true
func exitObject():
	hit = false

func dies():
	if health <= 0:
		queue_free()
