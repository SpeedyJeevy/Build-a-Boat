extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_water_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/world_1.tscn")
	Globals.path = "/root/World1/"
	Globals.spaceWater = false



func _on_space_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Space/space.tscn")
	Globals.path = "/root/Space/"
