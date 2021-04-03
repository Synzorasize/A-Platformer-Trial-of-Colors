extends Area2D

onready var Timer = $"../CanvasLayer/UI/VBoxContainer/HBoxContainer/SpeedrunTimer"
onready var Player = $"../Player"
#var saved_scene = PackedScene.new()

var color

# Called when the node enters the scene tree for the first time.
func _ready():
	#saved_scene = $".".get_children()
	#saved_scene.erase(self)
	#saved_scene.erase(Player)
	#saved_scene.erase($"../CanvasLayer/")
	modulate = Color(1,1,1,1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Checkpoint_body_shape_entered(_body_id, body, _body_shape, _area_shape):
	if body == Player:
		if GlobalVariables.LevelNum == 10 and not GlobalVariables.checkpoint == 1:
			GlobalVariables.checkpoint = 1
			color = Player.color
			if color == "red":
				modulate = Color(1,0,0,1)
			elif color == "blue":
				modulate = Color(0,0,1,1)
			elif color == "green":
				modulate = Color(0,1,0,1)
		#saved_scene = get_tree()
		#saved_scene.pack(get_tree().get_current_scene())

func _on_Player_restartcheckpoint():
	#get_tree().change_scene_to(saved_scene)
	if GlobalVariables.checkpoint == 1:
		Player.position = position
		Player.color = color
		$"../GreenColorOrb".state = true
	if GlobalVariables.speedrun == true:
		Timer.start()
