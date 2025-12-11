extends Node3D

# Types of rocks
@onready var bigRock = preload("res://Scenes/Water_Areas/Objects/big_rock.tscn")
@onready var lilRock = preload("res://Scenes/Water_Areas/Objects/lil_rock.tscn")

# Specific Events
@onready var acidCloud = preload("res://Scenes/Water_Areas/Objects/acid_cloud.tscn")
@onready var evilCannon = preload("res://Scenes/Water_Areas/Objects/evil_cannon.tscn")

# Number of rocks
@export var numLilRocks = 10
@export var numBigRocks = 3

# Number of specific obstaces
@export var numAcidClouds = 0
@export var numEvilCannons = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var l = (self.get_node("Water").get_node("MeshInstance3D").mesh.get_aabb().size.x / 2) - 2
	var w = (self.get_node("Water").get_node("MeshInstance3D").mesh.get_aabb().size.z / 2) - 2
	loadRocks(l, w)
	loadClouds(l, w)
	loadCannons(l, w)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func loadRocks(l: int, w: int):
	for i in range(numLilRocks):
		# Sets up newLilRock
		var newLilRock = lilRock.instantiate()
		# Sets up the position of the newLilRock
		newLilRock.position = Vector3(randi_range(-l, l), randf_range(-0.5,1.0), randi_range(-w, w))
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
		newBigRock.position = Vector3(randi_range(-l, l), randi_range(-2,2), randi_range(-w, w))
		newBigRock.scale = Vector3(randf_range(0.5, 2), randf_range(0.5, 1), randf_range(0.5, 2))
		newBigRock.rotation.x = randi_range(0, 359)
		newBigRock.rotation.y = randi_range(0, 359)
		newBigRock.rotation.z = randi_range(0, 359)
		
		# Makes newBigRock a child of the scene
		add_child(newBigRock)

func loadClouds(l: int, w: int):
	for i in range(numAcidClouds):
		# Sets up newLilRock
		var newCloud = acidCloud.instantiate()
		# Sets up the position of the newLilRock
		newCloud.position = Vector3(randi_range(-l, l), randf_range(34,37), randi_range(-w, w))
		newCloud.rotation.y = randi_range(0, 359)
		
		# Makes newLilRock a child of the scene
		add_child(newCloud)

func loadCannons(l: int, w: int):
	for i in range(numEvilCannons):
		# Sets up newCannon
		var newCannon = evilCannon.instantiate()
		# Sets up the position of the newCannon
		var side = [w + 2, - (w + 2)].pick_random()
		newCannon.position = Vector3(randi_range(-l, l), randi_range(5, 10), side)
		if side == w + 2:
			newCannon.rotation.y = PI / 2
		else:
			newCannon.rotation.y = - (PI / 2)
		
		# Makes newCannon a child of the scene
		add_child(newCannon)
