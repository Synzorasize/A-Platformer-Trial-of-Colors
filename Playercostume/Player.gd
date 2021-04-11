extends KinematicBody2D

# color
var color = "red"
signal iamred
signal iamblue
signal iamgreen
var label
onready var coloredItems = get_tree().get_nodes_in_group("coloredItems")
onready var s = $AnimatedSprite
onready var a = $AudioStreamPlayer2D

# restart
signal restart
signal restartcheckpoint
var victory : bool = false

# physics
var speed : int = 200
var jumpForce : int = 400
var gravity : int = 800
 
var vel : Vector2 = Vector2()
var grounded : bool = false

# sound effects
const jump_sound = preload("res://Music/Jump-SoundBible.com-1007297584.wav")
const walk_sound = preload("res://Music/Small Scrape-SoundBible.com-1395491979.wav")
var sound_finished : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if GlobalVariables.checkpoint == 0:
		connect_color_signals()
		set_process(true)
		if GlobalVariables.colorblind_mode:
			label = preload("res://Art/Fonts/Colorblind_Label.tscn").instance()
			add_child(label)
			label = $Colorblind_Label
			label.rect_position = Vector2(-16,0)


func connect_color_signals():
	for check_coloredItems in coloredItems:
		connect("iamred", check_coloredItems, "_on_Player_iamred")
		connect("iamblue", check_coloredItems, "_on_Player_iamblue")
		connect("iamgreen", check_coloredItems, "_on_Player_iamgreen")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if victory == false and is_inside_tree() and GlobalVariables.editor == false:
		vel.x = 0
		if Input.is_action_pressed("ui_left"):
			vel.x -= speed
			if sound_finished and is_on_floor() and not BGmusic.stream_paused:
				a.stream = walk_sound
				a.play()
				sound_finished = false
		if Input.is_action_pressed("ui_right"):
			vel.x += speed
			if sound_finished and is_on_floor() and not BGmusic.stream_paused:
				a.stream = walk_sound
				a.play()
				sound_finished = false
		# applying the velocity
		vel = move_and_slide(vel, Vector2.UP)
		# gravity
		vel.y += gravity * delta
		if Input.is_action_pressed("ui_up") and is_on_floor():
			vel.y -= jumpForce
			a.stream = jump_sound
			a.play()
			sound_finished = false
		if position.y > 450 and not GlobalVariables.checkpoint == 0:
			emit_signal("restartcheckpoint")
		elif position.y > 450 and GlobalVariables.checkpoint == 0:
			if not GlobalVariables.LevelNum == 999:
				GlobalVariables.checkpoint = 0
				get_tree().reload_current_scene()
			else:
				get_parent().restart()
		emit_signal("iam" + color)
		if color == "red":
			#emit_signal("iamred")
			#s.play("Red")
			if GlobalVariables.BGcolors_off == false:
				VisualServer.set_default_clear_color(Color(1,0.5,0.5,1.0))
		elif color == "blue":
			#emit_signal("iamblue")
			#s.play("Blue")
			if GlobalVariables.BGcolors_off == false:
				VisualServer.set_default_clear_color(Color(0.5,0.5,1,1.0))
			#if not get_node_or_null("Colorblind_Label") == null:
			#	label.text = "BLUE"
		elif color == "green":
			#emit_signal("iamgreen")
			#s.play("Green")
			if GlobalVariables.BGcolors_off == false:
				VisualServer.set_default_clear_color(Color(0.5,1,0.5,1.0))
			#if not get_node_or_null("Colorblind_Label") == null:
			#	label.text = "GREEN"
	s.play(color)
	if not get_node_or_null("Colorblind_Label") == null:
		label.text = color

func _on_ExitSprite_body_entered(body):
	if body.name == "Player" and GlobalVariables.editor == false:
		victory = true
		GlobalVariables.checkpoint = 0

func _on_AudioStreamPlayer2D_finished():
	sound_finished = true
