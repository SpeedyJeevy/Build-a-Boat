extends CharacterBody3D

@onready var sprint = 1
@onready var CamRotation : Vector2 = Vector2(0.0, 0.0)
@onready var sensitivity = 0.01
@onready var inWater = false
@onready var touchWater = 0
@onready var hit = false

@onready var waterDirection = 0
@onready var waterSpeed = 1

# Going down the list...
@onready var camera = $Node3D

# Area Specific Variables
@onready var poisoned = false

const SPEED = 5.0
const JUMP_VELOCITY = 10

# Handle Inputs
func _input(event):
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Handles sprinting
	if Input.is_action_just_pressed("sprint"):
		sprint = 3
	if Input.is_action_just_released("sprint"):
		sprint = 1
	
	# Handles the camera... Thank you Jus
	if (event is InputEventMouseMotion):
		CamRotation += event.relative * sensitivity
		CamRotation.y = clamp(CamRotation.y, -1.5, 1.5)
		camera.transform.basis = Basis()
		# rot cam on x
		camera.rotate_object_local(Vector3(0,1,0),-CamRotation.x)
		# rot cam on y
		camera.rotate_object_local(Vector3(1,0,0),-CamRotation.y)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# From Jus:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction : Vector3 = (camera.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED * sprint
		velocity.z = direction.z * SPEED * sprint
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	# Water touching logic
	if is_on_floor() and inWater:
		# Do damage
		
		if waterDirection == 0: # Forward
			self.position.x += 0.1 * waterSpeed
		elif waterDirection == -1: # Left
			self.position.z -= 0.1 * waterSpeed
		elif waterDirection == 1: # Right
			self.position.z += 0.1 * waterSpeed
		
	
	move_and_slide()

# General Functions

# Interact with water function
func enterWater():
	touchWater += 1
	inWater = true
func exitWater():
	touchWater -= 1
	if touchWater <= 0:
		inWater = false
func turn(lr: bool, ff: bool): # Where lr true/false = right/left, ff true/false = facing forward/not facing forward
	if lr:
		if ff:
			waterDirection = 1
		else:
			waterDirection = 0
	else:
		if ff:
			waterDirection = -1
		else:
			waterDirection = 0

# Hitting a damaging object function
func hitObject():
	hit = true
func exitObject():
	hit = false

# Poison functions
func enterPoison():
	poisoned = true
func exitPoison():
	poisoned = false
func poisonTick(): # CURRENTLY EMPTY
	pass

# Fast area functions
func changeSpeed():
	if waterSpeed == 1:
		waterSpeed = 7.5
	elif waterSpeed == 7.5:
		waterSpeed = 1
