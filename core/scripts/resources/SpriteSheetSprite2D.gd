
@tool
extends Sprite2D
class_name SpriteSheetSprite2D

@export var sprite_sheet_pool : Resource:
	set(v):
		sprite_sheet_pool = v
		update_texture()
@export var current_sheet : String:
	set(v):
		current_sheet = v
		update_texture()
@export var current_frame_coords : Vector2 = Vector2(0,0):
	set(v):
		current_frame_coords = v
		frame_coords = current_frame_coords

func update_texture():
	if sprite_sheet_pool == null:
		return
	var p : SpriteSheetPool = sprite_sheet_pool
	if not p.pool.keys().has(current_sheet):
		return
	var sh := p.pool[current_sheet] as SpriteSheet
	texture = sh.texture
	hframes = texture.get_width()  / sh.frame_size.x
	vframes = texture.get_height() / sh.frame_size.y


