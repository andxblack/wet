extends CharacterBody3D

# dragged this over and hold CTRL to get this variable. 
# PLayer nodes
@onready var head = $head
@onready var standing_collison_shape = $standing_collison_shape
@onready var crouching_collison_shape = $crouching_collison_shape
@onready var ray_cast_3d = $height

var current_speed = 5.0
@export var walking_speed = 5.0
@export var sprinting_speed = 8.0 
@export var crouching_speed = 3.0
@export var mouse_sens = 0.3

var lerp_speed = 10.0
var direction = Vector3.ZERO
# how much the camera moves down when we crouch.
var crouching_depth = -0.5
const jump_velocity = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# this function is called when the node enters the scene at the start.
func _ready():
	# capture the mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
func _input(event):
	# mouse looking logic
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))	
		# head head is one of the child nodes of the player.
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		# stop it roitation too much up and down.
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89),deg_to_rad(89))
		
	# exit game if escape key pressed.
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			get_tree().quit()

func _physics_process(delta):
	
	# Handle movement state
	
	# Crouching
	if Input.is_action_pressed("crouch"):
		current_speed=crouching_speed
		head.position.y = lerp(head.position.y, 1.8 + crouching_depth, delta*lerp_speed)
		standing_collison_shape.disabled = true
		crouching_collison_shape.disabled = false
		
	elif !ray_cast_3d.is_colliding():
		# standing. Seems that if the player comes out of a crouch quite quickly 
		# if coming out from something??? 
		standing_collison_shape.disabled = false
		crouching_collison_shape.disabled = true
		head.position.y = lerp(head.position.y, 1.8, delta*lerp_speed)
		if Input.is_action_pressed("sprint"):
			# sprinting
			current_speed=sprinting_speed
		else:
			# walking
			current_speed=walking_speed
			
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backwards")
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta*lerp_speed)
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
