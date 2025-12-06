extends Node3D

# Water Areas
var basicAreaScene = preload("res://Scenes/Water_Areas/basic_area.tscn")

# Types of blocks
@onready var block = preload("res://Scenes/Blocks/block.tscn")

@onready var numAreas = 10 # Change to make more areas spawn
@onready var areaList = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(numAreas):
		
		# Sets up newArea
		var newArea = basicAreaScene.instantiate()
		
		# Adds newArea to the areaList
		areaList.append(newArea)
		
		# Sets up the position of the newArea
		newArea.position = Vector3(25 * (1 * i), 0, 0)
		
		# Makes newArea a child of the scene
		add_child(newArea)
		
	# Temporary Block adding
	var x = -1
	var y = 0
	var z = 0
	for i in range(60):
		if i == 30:
			x = -1
			y = 0
			z = 0
		var newBlock = block.instantiate()
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
