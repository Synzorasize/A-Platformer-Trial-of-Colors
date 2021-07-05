extends Button
class_name ColorButton

export (String) var color : String = "white"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("colorButton")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
