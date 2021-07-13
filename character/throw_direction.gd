tool
extends Position2D

export(float, 0, 360, -0.1) var throwing_degrees = 360 setget set_throwing_degrees

func set_throwing_degrees(degrees):
	throwing_degrees = degrees
	update()

func _draw():
	if Engine.editor_hint:
		# Negative because that's typically how angles work in math (counter-clockwise)
		var b =  Vector2.RIGHT.rotated(deg2rad(throwing_degrees)) * 30
		draw_line(Vector2.ZERO, b, Color.blue, 2)

