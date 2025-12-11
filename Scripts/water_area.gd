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
		
		# Specific Water Areas
		if self.is_in_group("hasPoison"):
			body.enterPoison()
		
		if self.is_in_group("SpeedUp"):
			body.changeSpeed()
		
		# Corner turning
		if self.is_in_group("Corner"):
			# If turning right
			# Facing forward
			await get_tree().create_timer(4.5).timeout
			if body:
				if get_parent().get_parent().rotation.y == 0:
					body.turn(true, true)
				# Not facing forward
				elif is_equal_approx(get_parent().get_parent().rotation.y, PI):
					body.turn(true, false)
				# If turning left
				# Facing forward
				elif is_equal_approx(get_parent().get_parent().rotation.y, - (PI / 2)):
					body.turn(false, true)
				# Not facing forward
				elif is_equal_approx(get_parent().get_parent().rotation.y, (PI / 2)):
					body.turn(false, false)


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player") or body.is_in_group("Blocks"):
		body.exitWater()
		contactList.erase(body)
		
		# Specific Water Areas
		if self.is_in_group("hasPoison"):
			body.exitPoison()
		
		if self.is_in_group("SpeedUp"):
			body.changeSpeed()
