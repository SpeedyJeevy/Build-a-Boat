extends Node3D

# Types of rocks
@onready var bigRock = preload("res://Scenes/Water_Areas/big_rock.tscn")
@onready var lilRock = preload("res://Scenes/Water_Areas/lil_rock.tscn")

@onready var numLilRocks = 10
@onready var numBigRocks = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(numLilRocks):
		# Sets up newLilRock
		var newLilRock = lilRock.instantiate()
		# Sets up the position of the newLilRock
		newLilRock.position = Vector3(randi_range(-24, 24) + 50, randf_range(-0.5,1.0), randi_range(-24, 24))
		newLilRock.scale = Vector3(randf_range(1, 2), randf_range(1, 2), randf_range(1, 3))
		newLilRock.rotation.x = randi_range(0, 359)
		newLilRock.rotation.y = randi_range(0, 359)
		newLilRock.rotation.z = randi_range(0, 359)
		
		# Makes newLilRock a child of the scene
		add_child(newLilRock)
		
	for i in range(numBigRocks):
		# Sets up newBigRock
		var newBigRock = bigRock.instantiate()
		# Sets up the position of the newBigRock
		newBigRock.position = Vector3(randi_range(-20, 20) + 50, randi_range(-2,2), randi_range(-20, 20))
		newBigRock.scale = Vector3(randf_range(0.5, 2), randf_range(0.5, 1), randf_range(0.5, 2))
		newBigRock.rotation.x = randi_range(0, 359)
		newBigRock.rotation.y = randi_range(0, 359)
		newBigRock.rotation.z = randi_range(0, 359)
		
		# Makes newBigRock a child of the scene
		add_child(newBigRock)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
