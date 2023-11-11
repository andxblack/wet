extends CenterContainer

@onready var crosshair = $crosshair

var target1 = preload("res://player_controler/crosshair001.png")
var target2 = preload("res://player_controler/crosshair004.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_interact_pointing_at_something(poo):
	# change the sprite to whatever..
	if poo:
		crosshair.set_texture(target2)
	else: 
		crosshair.set_texture(target1)
