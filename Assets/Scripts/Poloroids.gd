extends Control

func _ready():
	var image_sprite_list = [$image1,$image2,$image3,$image4,$image5]
	for i in len(image_sprite_list):
		if not Global.taken_image_keys.has(i+1):
			var sprite = image_sprite_list[i]
			sprite.set_texture(null)

