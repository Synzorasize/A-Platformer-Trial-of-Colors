extends Area2D

var state : bool


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	state = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if state == true:
		$AnimatedSprite.play("OrbOn")
	else:
		$AnimatedSprite.play("OrbOff")


func _on_RedColorOrb_body_shape_entered(_body_id, body, _body_shape, _area_shape):
	if body.name == "Player" and GlobalVariables.editor == false:
		if state == true:
			state = false
			$"../Player".color = "red"
