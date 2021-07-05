extends Area2D

onready var UI = $"../CanvasLayer/UI"
onready var Player = $"../Player"
export (PackedScene) var saved_scene : PackedScene = PackedScene.new()
export (String) var color : String

# Called when the node enters the scene tree for the first time.
func _ready():
	Player.connect("restartcheckpoint", self, "_on_Player_restartcheckpoint")
	connect("body_shape_entered", UI, "_on_Checkpoint_body_shape_entered")
	if color == "red":
		modulate = Color(1,0.682,0.682,1)
		Player.color = color
	elif color == "blue":
		modulate = Color(0.682,0.682,1,1)
		Player.color = color
	elif color == "green":
		modulate = Color(0.682,1,0.682,1)
		Player.color = color
	else:
		modulate = Color(1,1,1,1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Checkpoint_body_shape_entered(_body_id, body, _body_shape, _area_shape):
	if body == Player and not GlobalVariables.editor:
		if not GlobalVariables.checkpoint == 1:
			GlobalVariables.checkpoint = 1
			color = Player.color
			if color == "red":
				modulate = Color(1,0.682,0.682,1)
			elif color == "blue":
				modulate = Color(0.682,0.682,1,1)
			elif color == "green":
				modulate = Color(0.682,1,0.682,1)
			saved_scene.pack(get_parent())

func _on_Player_restartcheckpoint():
	get_tree().change_scene_to(saved_scene.duplicate())
	if GlobalVariables.speedrun:
		UI.Timer.start()
