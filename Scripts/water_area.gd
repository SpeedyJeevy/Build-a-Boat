extends Area3D

# List of blocks in the area
@onready var contactList = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") or body.is_in_group("Blocks"):
		body.enterWater()
		contactList.append(body)
		if self.is_in_group("hasPoison"):
			body.enterPoison()


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") or body.is_in_group("Blocks"):
		body.exitWater()
		contactList.erase(body)
		if self.is_in_group("hasPoison"):
			body.exitPoison()
