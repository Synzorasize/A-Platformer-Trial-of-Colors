extends AudioStreamPlayer


#var song = preload("res://Synzorasize - Tranquility.wav")


# Called when the node enters the scene tree for the first time.
#func _ready():
	#set_stream(song)
	#set_autoplay(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	


func _on_BGmusic_finished():
	play()
