extends Node3D

# Water Areas
var basicAreaScene = preload("res://Scenes/Water_Areas/basic_area.tscn")

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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
