extends Node3D

# Space Areas

@onready var endingAreaScene = null

@onready var spaceAreaScene = preload("res://Scenes/Space/basic_space.tscn")

# Functions for calling each scene
@onready var possibleAreas = [spaceAreaScene]

# Smaller one used for testing specific areas
#@onready var possibleAreas = []


@onready var numAreas = 100 # Change to make more areas spawn
@onready var areaList = [] # List of procedurally generated areas
@onready var totalSpaceX = 0 # Displacement between areas on the X
@onready var totalSpaceY = 0 # Displacement between areas on the Y
@onready var totalSpaceZ = 0 # Displacement between areas on the Z
@onready var direction = 0 # 0 = forward, -1 = left, 1 = right

@onready var player = $Player
@onready var ships = $ShipParts
@onready var blockZone = $BlockPlacementZone
@onready var parentArea = $ParentArea

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	createMap()
	
	# connect player signals
	player.placeBlock.connect(placeBlock)
	player.previewBlock.connect(previewBlock)
	player.unpreviewBlock.connect(unpreviewBlock)
	player.scrollBlock.connect(scrollBlock)

func placeBlock(location : Vector3, id : String):
	blockZone.placeBlock(location, id)

func previewBlock(location : Vector3, id : String):
	blockZone.previewBlock(location, id)

func unpreviewBlock():
	blockZone.deletePreviewBlock()

func scrollBlock(up: bool):
	blockZone.scrollBlock(up)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func loadArea(areaType: PackedScene):
	# Sets up newArea
	var newArea = areaType.instantiate()
	
	# Adds newArea to the areaList
	areaList.append(newArea)
	
	# Sets up the position of the newArea
	var areaSpacingY = 0
	var areaSpacing = 0
	var rotationError = 0
	
	# For normally rotated
	if newArea.rotation.z == 0:
		areaSpacing = newArea.get_node("FlowArea").get_node("CollisionShape3D").shape.size.y
	# For rotated areas, base off of world_1
	
	# Transforms in either x or z:
	if direction == 0:
		areaSpacingY += (areaSpacing / 2) + 100.5 + totalSpaceY
		totalSpaceY += areaSpacing
	
	# Finally sets the position and updates the space for the next area
	newArea.position = Vector3(0, areaSpacingY, 0)
	
	# Makes newArea a child of the scene
	parentArea.add_child(newArea)

func createMap():
	for child in parentArea.get_children():
		child.queue_free()
	
	for i in range(numAreas):
		var nextArea = possibleAreas.pick_random()
		loadArea(nextArea)
	
	#loadArea(endingAreaScene)

func launch():
	Globals.launched = true
	PhysicsServer3D.area_set_param(get_viewport().find_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY, 0)
	
	# Player
	if player.abilitiesOn:
		$"Player/Abilities".activateAbilities()
		$"Player/Abilities".visible = true
	#$LaunchAnimation.play("Launch")
	
	# Unfreezes blocks when the water shows up
	await get_tree().create_timer(0.5).timeout
	for ship in ships.get_children():
		ship.freeze = false

func unlaunch(win: bool): # If we won then win = true
	# Map
	#$LaunchAnimation.play("Launch", -1, -100, true)
	Globals.launched = false
	PhysicsServer3D.area_set_param(get_viewport().find_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY, 9.8)

	# Make a button/menu for customizing the number of areas and areas that can exist
	totalSpaceX = 0 # Displacement between areas on the X
	totalSpaceY = 0 # Displacement between areas on the Y
	totalSpaceZ = 0 # Displacement between areas on the Z
	direction = 0 # 0 = forward, -1 = left, 1 = right
	
	createMap()
	
	# Player
	var amountWon = int(numAreas * 1.2)
	if win:
		amountWon += 100
	player.adjMoney(true, amountWon)
	player.health = player.maxHealth
	player.updateHealth()
	player.position = Vector3(-20, 0, 0)
	$"Player/Settings/LaunchButton".show()
	player.getPlayerBlocks()
	
	# Boat
	for ship in ships.get_children():
		ship.queue_free()
