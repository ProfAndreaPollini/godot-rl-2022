extends MarginContainer

var texture: Texture = null setget set_texture

func set_texture(_texture):
	texture = _texture
	$NinePatchRect.texture = _texture
