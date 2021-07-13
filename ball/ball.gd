extends RigidBody2D

func set_color(color:Color):
	print(color)
	$Sprite.modulate = color
