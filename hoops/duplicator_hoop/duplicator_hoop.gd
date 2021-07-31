tool
extends Hoop

const DirectionAngle = Constants.DirectionAngle
var active = true

export (DirectionAngle) var first_direction = DirectionAngle.RIGHT \
	setget set_first_direction
export (DirectionAngle) var second_direction = DirectionAngle.UPPER_LEFT \
	setget set_second_direction
export(PackedScene) var ball_scene = preload("res://ball/ball.tscn")



func set_first_direction(value):
	$FirstArrow.rotation_degrees = value
	first_direction = value

func set_second_direction(value):
	$SecondArrow.rotation_degrees = value
	second_direction = value

func throw_extra(velocity: Vector2, color):

	var scene_instance : Ball = ball_scene.instance()
	assert(scene_instance != null)
	scene_instance.set_name("extra_ball")
	get_parent().call_deferred("add_child", scene_instance)

	scene_instance.set_color(color)
	scene_instance.global_position = global_position
	scene_instance.linear_velocity = velocity


	active = false
	yield(get_tree().create_timer(0.1),"timeout")
	active = true



func _on_BallDetector_area_entered(area):
	if not active:
		return
	._on_BallDetector_area_entered(area)
	var ball = (area.get_parent() as Ball)
	if ball and can_detect_ball:
		var ball_velocity = Vector2.RIGHT * 200
		ball.linear_velocity = ball_velocity.rotated(deg2rad(first_direction))
		throw_extra(ball_velocity.rotated(deg2rad(second_direction)), ball.current_color)
