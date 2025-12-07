extends RigidBody3D

@onready var sitting = false
@onready var player = null

# Health - Hits the object can take
# Endurance - Makes the block sturdier (in case I wanna have upgrades of sorts or health restore stuff)
# Luck - Chance to not take damage (maybe create fun blocks with high luck but can only take 1 hit if unlucky)
@onready var health = 5.0
@onready var endurance = 1
@onready var luck = 0

@onready var hit = false
@onready var inWater = false
@onready var touchWater = 0
@onready var waterFlowVel = Vector3(6.0, 0.0, 0.0)

# Area Specific Variables
@onready var poisoned = false

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
	dies()
	
	if player and Input.is_action_just_pressed("right_click"):
		sitting = !sitting
	
	if sitting and player:
		player.global_position = self.global_position + Vector3(0, 1.25, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
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

# Poison functions
func enterPoison():
	poisoned = true
func exitPoison():
	poisoned = false
func poisonTick():
	if randf_range(0, 100) > luck:
			health -= 1
