extends Area2D

var state : bool
onready var a = $AnimatedSprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	state = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if state:
		a.play("OrbOn")
	else:
		a.play("OrbOff")


func _on_BlueColorOrb_body_shape_entered(_body_id, body, _body_shape, _area_shape):
	if body.name == "Player" and not GlobalVariables.editor:
		if state:
			state = false
			$"../Player".color = "blue"
