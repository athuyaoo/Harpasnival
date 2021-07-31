class_name Ball
extends RigidBody2D

const ColorType = Constants.ColorType
export(Color, RGB) var blue_ball_color
export(Color, RGB) var red_ball_color
export(Color, RGB) var purple_ball_color
# Uses the tilemap position
var start_position: Vector2
var active = true
var current_color


func set_start_position( player_position: Vector2):
	active = false
	start_position = Utils.set_position_to_tile_map(player_position)


onready var colorDict = {
	ColorType.BLUE: blue_ball_color,
	ColorType.RED: red_ball_color,
	ColorType.PURPLE: purple_ball_color,
}

func set_active():
	active = true

func _physics_process(delta):
	if active:
		return
	if abs(global_position.x - start_position.x) > (64 * 3 + 10):
		queue_free()


func set_color(color):
	if (color == null or colorDict[color] == null):
		return
	$Sprite.modulate = colorDict[color]
	current_color = color

func _on_Ball_body_entered(body):
	queue_free()
