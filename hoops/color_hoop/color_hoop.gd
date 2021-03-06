tool
extends Hoop

# For easy changing or textures and colors
export (Texture) var blue_hoop = preload("res://hoops/color_hoop/blue_hoop.png")
export (Texture) var red_hoop = preload("res://hoops/color_hoop/red_hoop.png")
export (Texture) var purple_hoop = preload("res://hoops/color_hoop/purple_hoop.png")

const ColorType = Constants.ColorType
export (ColorType) var hoop_color = ColorType.BLUE setget set_hoop_color

func get_texture(color):
	var textureDict = {
		ColorType.BLUE: blue_hoop,
		ColorType.RED: red_hoop,
		ColorType.PURPLE: purple_hoop,
	}

	return textureDict[color]

func set_hoop_color(color):
	$Sprite.texture = get_texture(color)
	hoop_color = color


func _on_BallDetector_area_entered(area):
	var body = area.get_parent()
	var ball = (area.get_parent() as Ball)
	if not ball:
		return
	if can_detect_ball:
		ball.set_color(hoop_color)
		$HoopSound.play()
	else:
		ball.self_destruct()

