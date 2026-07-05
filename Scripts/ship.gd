extends RigidBody3D

@onready var hit = false
@onready var touchWater = 0
@onready var direction = 0
@onready var waterFlowMax = 6
@onready var incline = false
@onready var inclineBoost = Vector3(0, 1.5, 0)

@onready var specialCase = false

@onready var shipScript = load("res://Scripts/ship.gd")

@onready var deadLastFrame = false
@onready var deadChildren = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#self.set_script(shipScript)
	#self.add_to_group("Ship")

	print("I was just born")

func _process(delta: float) -> void:
	if deadLastFrame:
		self.reevaluateParts()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	# Water touching logic
	if !Globals.spaceWater:
		
		# Updates mass and inertia dynamically
		var childCount = get_child_count()
		var childLog = log(childCount)
		if childLog > 1:
			mass = childLog
			inertia = Vector3(childCount, childCount, childCount)
		
		if linear_velocity.x > waterFlowMax and !specialCase:
			linear_velocity.x = waterFlowMax
		if abs(linear_velocity.z) > waterFlowMax and !specialCase:
			if direction < 0:
				linear_velocity.z = -waterFlowMax
			else:
				linear_velocity.z = waterFlowMax
	
	if touchWater > 1 and !self.freeze and is_equal_approx(self.linear_velocity.x, 0) and is_equal_approx(self.linear_velocity.y, 0) and is_equal_approx(self.linear_velocity.z, 0):
		print("Almost 0!")
		self.linear_velocity.y = 20
	
	apply_central_force(get_gravity() * mass * delta)
	
	if incline:
		apply_central_force(inclineBoost)
	
	#print("ship linear velocity = ", linear_velocity) # Debugging velocity issues
	
	# Forces that oppose motion
	if self.angular_velocity.x > 2:
		self.angular_velocity.x = 2
	elif self.angular_velocity.x < -2:
		self.angular_velocity.x = -2
	if self.angular_velocity.y > 2:
		self.angular_velocity.y = 2
	elif self.angular_velocity.y < -2:
		self.angular_velocity.y = -2
	if self.angular_velocity.z > 2:
		self.angular_velocity.z = 2
	elif self.angular_velocity.z < -2:
		self.angular_velocity.z = -2
	
	self.angular_damp = self.mass * 50
	#print("Ship angular velocity: " + str(self.angular_velocity))

# Interact with water function
func enterWater():
	touchWater += 1
	print("touched water! new value = ", touchWater)
func exitWater():
	touchWater -= 1
	print("exited water! new value = ", touchWater)
	if touchWater <= 0:
		print("EXITING WATER COMPLETELY")
		set_constant_force(Vector3.ZERO)

# Fast area functions
func changeSpeed(area: bool, up: bool): # True = fastArea, false = crazyArea -- True = speed up, false = slow down
	var change
	if up:
		change = 1
	else:
		change = -1
	
	if area:
		waterFlowMax += change * 30
	else:
		waterFlowMax += change * 12.5
	print("New max velocity:" + str(waterFlowMax))

func on_floor():
	return abs(linear_velocity.y) < 0.1

# Movement adjustment
func move():
	var massAssist = max(1, mass * 0.75)
	var buoyancy = get_gravity() * mass * 2
	if direction == 0: # Forward
		apply_central_force(massAssist * Vector3(400, buoyancy.y, 0))
		#print("Applying force in the direction: " + str(direction))
	elif direction == -2: # Left
		apply_central_force(massAssist * Vector3(0, buoyancy.y, -400))
	elif direction == 2: # Right
		apply_central_force(massAssist * Vector3(0, buoyancy.y, 400))
		#print("Applying force in the direction: " + str(direction))
	elif direction == -1: # Diagonally Left
		apply_central_force(massAssist * Vector3(400, buoyancy.y, -400))
	elif direction == 1: # Diagonally Right
		apply_central_force(massAssist * Vector3(400, buoyancy.y, 400))

func reevaluateParts():
	# Get all remaining blocks (excluding dead one)
	var remaining = []
	var potentialShips = []
	var done = false
	
	for child in self.get_children():
		for deadGuyPos in deadChildren:
			print("Dead guy: " + str(deadGuyPos))
			print("Me: " + str(child.global_position))
			var dist = (child.global_position - deadGuyPos).length()
			if is_equal_approx(dist, 0):
				child.queue_free()
			elif (child.global_position - deadGuyPos).length() < 1.75:
				potentialShips.append(child)
				print("new potential ship!")
			remaining.append(child)
	
	# Returns if only 1 possible ship
	if potentialShips.size() == 1:
		deadChildren.clear()
		deadLastFrame = false
		return
	
	# First checks if there is a block in potentialShips that touches all other potentialShips
	for block in potentialShips:
		var myCount = 0
		for block2 in potentialShips:
			if block != block2 and (block.global_position - block2.global_position).length() < 1.75:
				myCount += 1
		if myCount == potentialShips.size() - 1:
			print("I'm returning because all potential ships are nearby")
			deadChildren.clear()
			deadLastFrame = false
			return
	
	# Keep finding connected groups until no blocks left
	while potentialShips.size() > 0:
		var newShip = self.duplicate()
		for child in newShip.get_children():
			child.queue_free()
		get_parent().add_child(newShip)

		# Start a new group from the first remaining block
		var group = [potentialShips[0]]
		potentialShips.erase(potentialShips[0])

		# Flood fill - find all blocks connected to this group
		var i = 0
		while i < group.size():
			var current = group[i]

			# Check all remaining blocks for adjacency
			var j = remaining.size() - 1
			while j >= 0:  # Iterate backwards so we can remove safely
				var other = remaining[j]
				var dist = (current.global_position - other.global_position).length()
				if dist < 1.75:
					group.append(other)
					if other in potentialShips:
						potentialShips.erase(other)
						if potentialShips.size() == 0:
							done = true
					else:
						remaining.erase(other)

				j -= 1
				if done:
					break
			i += 1
			if done:
				break

		# Add all blocks in this group to the new ship
		if remaining.size() != 0 and !done:
			for block in group:
				block.reparent(newShip)
				print("REPARENTED")
		else:
			print("I kept " + str(group.size()) + " children")
	# FINAL GROUP OF BLOCKS KEEPS CURRENT PARENT
	print("Remaining children count:" + str(get_child_count()))
	deadChildren.clear()
	deadLastFrame = false

func turn(newDir):
	direction = newDir
	if !self.freeze:
		move()

func fly(newDir):
	direction = newDir
	#if !self.freeze:
	var distToCentX = self.global_position.x
	var distToCentZ = self.global_position.z
	self.apply_central_force(Vector3(-distToCentX, 10, -distToCentZ))
