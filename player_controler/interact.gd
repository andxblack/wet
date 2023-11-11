extends Node3D

# get a reference to the raycast along crosshair.. 
@onready var point_at = get_node("../head/pointing_at")

signal pointing_at_something(poo)

# this script will handle interactions with the world. 
# want to be able to switch lights on/off 

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Interaction is ready to go")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# do stuff if the plater is pointing at something that can interact. 
	if point_at.is_colliding():
	
		# get the reference to 
		var thing = point_at.get_collider()
		
		if thing.has_method("interact_with"):
			# print("colliding")
			# here we need to send a singal which the HUD subscribes to to change the crosshairs. 
			pointing_at_something.emit(true)
			
			# if we have pressed the interact button then call the method on the object. 
			if Input.is_action_just_pressed("interact"):
				thing.interact_with()
		else: 
			pointing_at_something.emit(false)
	else: 
		pointing_at_something.emit(false)
		# print("not colliding")
