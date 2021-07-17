class_name Ball
extends RigidBody2D

const ColorType = Constants.ColorType
export(Color, RGB) var blue_ball_color
export(Color, RGB) var red_ball_color
export(Color, RGB) var purple_ball_color

var current_color

onready var colorDict = {
	ColorType.BLUE: blue_ball_color,
	ColorType.RED: red_ball_color,
	ColorType.PURPLE: purple_ball_color,
}

func set_color(color):
	if (color == null or colorDict[color] == null):
		return
	$Sprite.modulate = colorDict[color]
	current_color = color

func _on_Ball_body_entered(body):
	queue_free()
