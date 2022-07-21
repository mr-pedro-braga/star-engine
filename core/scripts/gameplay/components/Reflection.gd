extends StaticBody2D

@export var original : Node
@export var center : Vector2 = Vector2.ZERO

func _process(_delta):
	position = Vector2(center.x - original.position.x, original.position.y)
	scale = original.get_node("Texture2D").scale / 6
