extends StaticBody2D
class_name Tile

onready var c = $CollisionShape2D
export (String) var color : String = "white"

func _on_Player_iamblue():
	c = $CollisionShape2D
	if not c.disabled and color == "blue":
		c.disabled = true
	elif c.disabled and is_visible() and not color == "blue":
		c.disabled = false

func _on_Player_iamred():
	c = $CollisionShape2D
	if not c.disabled and color == "red":
		c.disabled = true
	elif c.disabled and is_visible() and not color == "red":
		c.disabled = false


func _on_Player_iamgreen():
	c = $CollisionShape2D
	if not c.disabled and color == "green":
		c.disabled = true
	elif c.disabled and is_visible() and not color == "green":
		c.disabled = false
