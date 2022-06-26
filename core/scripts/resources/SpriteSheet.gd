extends Resource
class_name SpriteSheet

#####################################
#
#	Resource class for spritesheets.
#
#####################################

@export var texture : Texture2D
@export var frame_size : Vector2

func get_frame(coords : Vector2) -> Texture:
	return 
