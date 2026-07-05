extends Node3D

# Stuff
@export var numLilRocks = 25

# Types of rocks
@onready var lilRock = preload("res://Scenes/Space/lil_space_rock.tscn")

# The direction the rocket flows follows flowDir
@onready var flowDir = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var l = self.get_node("FlowArea").get_node("CollisionShape3D").shape.size.x - 2
	var w = self.get_node("FlowArea").get_node("CollisionShape3D").shape.size.z - 2
	var h = self.get_node("FlowArea").get_node("CollisionShape3D").shape.size.y - 2
	loadRocks(l, w, h)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.launched:
		for body in $FlowArea.get_overlapping_bodies():
			if body.is_in_group("player") or body.is_in_group("Ship"):
				body.fly(flowDir)
				if body.is_in_group("player"):
					body.position.y += 0.25

func loadRocks(l: int, w: int, h: int):
	for i in range(numLilRocks):
		# Sets up newLilRock
		var newLilRock = lilRock.instantiate()
		# Sets up the position of the newLilRock
		newLilRock.position = Vector3(randi_range(-l, l), randf_range(-h, h), randi_range(-w, w))
		newLilRock.scale = Vector3(randf_range(1, 2), randf_range(1, 2), randf_range(1, 3))
		newLilRock.rotation.x = randi_range(0, 359)
		newLilRock.rotation.y = randi_range(0, 359)
		newLilRock.rotation.z = randi_range(0, 359)
		
		# Makes newLilRock a child of the scene
		add_child(newLilRock)
