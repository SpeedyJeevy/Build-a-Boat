extends Node3D

# Water Areas
var basicAreaScene = preload("res://Scenes/Water_Areas/basic_area.tscn")
var longAreaScene = preload("res://Scenes/Water_Areas/long_area.tscn")
var poisonAreaScene = preload("res://Scenes/Water_Areas/poison_area.tscn")
var dropAreaScene = preload("res://Scenes/Water_Areas/drop_area.tscn")
var inclineAreaScene = preload("res://Scenes/Water_Areas/incline_area.tscn")
var acidRainAreaScene = preload("res://Scenes/Water_Areas/acid_rain_area.tscn")

# Functions for calling each scene
@onready var possibleAreas = [loadBasic, loadLong, loadPoison, loadDrop, loadIncline, loadAcidRain]

# Types of blocks
@onready var block = preload("res://Scenes/Blocks/block.tscn")
@onready var stoneBlock = preload("res://Scenes/Blocks/stone_block.tscn")
@onready var luckyBlock = preload("res://Scenes/Blocks/lucky_block.tscn")
@onready var obsidian = preload("res://Scenes/Blocks/obsidian.tscn")

@onready var numAreas = 10 # Change to make more areas spawn
@onready var areaList = [] # List of procedurally generated areas
@onready var areaSpacing = 0
@onready var totalSpaceX = 0 # Displacement between areas on the X
@onready var totalSpaceY = 0 # Displacement between areas on the Y
@onready var totalSpaceZ = 0 # Displacement between areas on the Z
@onready var forward = true
@onready var left = false
@onready var right = false   # These three will help indicate direction (when I add corner pieces, no turning left/right 2x without turning the other way first 
@onready var nextArea = 1 # Ensures the first level is a basic level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(numAreas):
		var nextArea = possibleAreas.pick_random()
		nextArea.call()
		
		
	# TEMPORARY BUILDING BLOCKS ADDING
	var x = -1
	var y = 0
	var z = 0
	for i in range(60):
		var newBlock
		newBlock = obsidian.instantiate()
#		if i < 20:
#			newBlock = block.instantiate()
#		elif i < 40:
#			newBlock = stoneBlock.instantiate()
#		else:
#			newBlock = luckyBlock.instantiate()
		if i == 30:
			x = -1
			y = 0
			z = 0
		if i % 3 == 0:
			x += 1
		else:
			if z == 1:
				z = 2
			elif z == 2:
				z = 0
			else:
				z = 1
			
		newBlock.position = Vector3(25 + x, 6.75 - y, 0 + z)
		
		add_child(newBlock)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func loadBasic():
	# Sets up newArea
	var newArea = basicAreaScene.instantiate()
	
	# Adds newArea to the areaList
	areaList.append(newArea)
	
	# Sets up the position of the newArea
	areaSpacing = newArea.get_node("Water").get_node("MeshInstance3D").mesh.get_aabb().size.x
	newArea.position = Vector3(((areaSpacing / 2) + 25) + totalSpaceX, totalSpaceY, 0)
	totalSpaceX += areaSpacing
	
	# Makes newArea a child of the scene
	add_child(newArea)

func loadLong():
	# Sets up newArea
	var newArea = longAreaScene.instantiate()
	
	# Adds newArea to the areaList
	areaList.append(newArea)
	
	# Sets up the position of the newArea
	areaSpacing = newArea.get_node("Water").get_node("MeshInstance3D").mesh.get_aabb().size.x
	newArea.position = Vector3(((areaSpacing / 2) + 25) + totalSpaceX, totalSpaceY, 0)
	totalSpaceX += areaSpacing
	
	# Makes newArea a child of the scene
	add_child(newArea)

func loadPoison():
	# Sets up newArea
	var newArea = poisonAreaScene.instantiate()
	
	# Adds newArea to the areaList
	areaList.append(newArea)
	
	# Sets up the position of the newArea
	areaSpacing = newArea.get_node("Water").get_node("MeshInstance3D").mesh.get_aabb().size.x
	newArea.position = Vector3(((areaSpacing / 2) + 25) + totalSpaceX, totalSpaceY, 0)
	totalSpaceX += areaSpacing
	
	# Makes newArea a child of the scene
	add_child(newArea)

func loadDrop():
	# Sets up newArea
	var newArea = dropAreaScene.instantiate()
	
	# Adds newArea to the areaList
	areaList.append(newArea)
	
	# Sets up the position of the newArea
	areaSpacing = newArea.get_node("Water").get_node("MeshInstance3D").mesh.get_aabb().size.x
	totalSpaceY -= 35
	newArea.position = Vector3(((areaSpacing / 2) + 25) + totalSpaceX, totalSpaceY, 0)
	totalSpaceX += areaSpacing
	
	# Makes newArea a child of the scene
	add_child(newArea)

func loadIncline():
	# Sets up newArea
	var newArea = inclineAreaScene.instantiate()
	
	# Adds newArea to the areaList
	areaList.append(newArea)
	
	# Sets up the position of the newArea
	areaSpacing = 137.37
	totalSpaceY += 50
	
	newArea.position = Vector3(((areaSpacing / 2) + 25) + totalSpaceX, totalSpaceY - 25, 0)
	totalSpaceX += areaSpacing
	
	# Makes newArea a child of the scene
	add_child(newArea)

func loadAcidRain():
	# Sets up newArea
	var newArea = acidRainAreaScene.instantiate()
	
	# Adds newArea to the areaList
	areaList.append(newArea)
	
	# Sets up the position of the newArea
	areaSpacing = newArea.get_node("Water").get_node("MeshInstance3D").mesh.get_aabb().size.x
	newArea.position = Vector3(((areaSpacing / 2) + 25) + totalSpaceX, totalSpaceY, 0)
	totalSpaceX += areaSpacing
	
	# Makes newArea a child of the scene
	add_child(newArea)
