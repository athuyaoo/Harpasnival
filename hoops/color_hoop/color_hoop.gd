extends Area2D

enum HoopColor {BLUE, RED, PURPLE}
# For easy changing or textures and colors
export(Texture) var blue_hoop
export(Texture) var red_hoop
export(Texture) var purple_hoop
export(Color, RGB) var blue_ball_color
export(Color, RGB) var red_ball_color
export(Color, RGB) var purple_ball_color
export(HoopColor) var current_hoop_color

# To easily reference the colors and texture
onready var colorDict = {
	HoopColor.BLUE: blue_ball_color,
	HoopColor.RED: red_ball_color,
	HoopColor.PURPLE: purple_ball_color,
}
onready var textureDict = {
	HoopColor.BLUE: blue_hoop,
	HoopColor.RED: red_hoop,
	HoopColor.PURPLE: purple_hoop,
}

func _ready():
	$Sprite.texture = textureDict[current_hoop_color]

func _on_ColorHoop_body_entered(body: PhysicsBody2D):
	if body.is_in_group("ball"):
		print(colorDict)
		body.set_color(colorDict[current_hoop_color])
