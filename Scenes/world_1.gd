extends Node3D

# Water Areas
var basicAreaScene = preload("res://Scenes/Water_Areas/basic_area.tscn")
var longAreaScene = preload("res://Scenes/Water_Areas/long_area.tscn")

# Types of blocks
@onready var block = preload("res://Scenes/Blocks/block.tscn")
@onready var stoneBlock = preload("res://Scenes/Blocks/stone_block.tscn")
@onready var concGreen = preload("res://Scenes/Blocks/green_concrete.tscn")

@onready var numAreas = 10 # Change to make more areas spawn
@onready var areaList = []
@onready var areaSpacing = 0
@onready var totalSpace = 0
@onready var nextArea = 1 # Ensures the first level is a basic level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(numAreas):
		if nextArea < 50:
			loadBasic()
		elif nextArea < 100:
			loadLong()
		nextArea = randi_range(1,100)
		
		
	# TEMPORARY BUILDING BLOCKS ADDING
	var x = -1
	var y = 0
	var z = 0
	for i in range(60):
		var newBlock
		if i < 20:
			newBlock = block.instantiate()
		elif i < 40:
			newBlock = stoneBlock.instantiate()
		else:
			newBlock = concGreen.instantiate()
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
	newArea.position = Vector3(((areaSpacing / 2) + 25) + totalSpace, 0, 0)
	totalSpace += areaSpacing
	
	# Makes newArea a child of the scene
	add_child(newArea)

func loadLong():
	# Sets up newArea
	var newArea = longAreaScene.instantiate()
	
	# Adds newArea to the areaList
	areaList.append(newArea)
	
	# Sets up the position of the newArea
	areaSpacing = newArea.get_node("Water").get_node("MeshInstance3D").mesh.get_aabb().size.x
	newArea.position = Vector3(((areaSpacing / 2) + 25) + totalSpace, 0, 0)
	totalSpace += areaSpacing
	
	# Makes newArea a child of the scene
	add_child(newArea)

# EQUATION: ((width / 2) + 25) 
