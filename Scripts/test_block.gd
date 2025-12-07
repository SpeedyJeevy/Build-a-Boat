extends RigidBody3D

# Health - Hits the object can take
# Endurance - Makes the block sturdier (in case I wanna have upgrades of sorts or health restore stuff)
# Luck - Chance to not take damage (maybe create fun blocks with high luck but can only take 1 hit if unlucky)
@export var health = 5.0
@export var endurance = 1.0
@export var luck = 1

@onready var hit = false
@onready var inWater = false
@onready var touchWater = 0
@onready var waterFlowVel = Vector3(6.0, 0.0, 0.0)

# Area Specific Variables
@onready var poisoned = false

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
		# Luck logic:
		if randf_range(0, 100) > luck:
			health -= (1.0 / endurance)
			print("Damage taken, new health = ", health)
		else:
			print("Lucky break")
	
	if int(delta) % 60 == 0:
		# Poison logic
		if poisoned:
			poisonTick()

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
	print("Hit: Health before = ", health)
func exitObject():
	hit = false

func dies():
	if health <= 0:
		queue_free()

# Poison functions
func enterPoison():
	poisoned = true
func exitPoison():
	poisoned = false
func poisonTick():
	if randf_range(0, 100) > luck:
			health /= 1.0025
			print("Poisoned, new health = ", health)
