class_name Ball
extends RigidBody2D

signal self_destructed

const ColorType = Constants.ColorType
export(Color, RGB) var blue_ball_color
export(Color, RGB) var red_ball_color
export(Color, RGB) var purple_ball_color
# Uses the tilemap position
var start_position: Vector2
var active = true
var current_color
var is_self_destructing = false

const Level := preload("res://level/level.gd")


func set_start_position( player_position: Vector2):
	active = false
	start_position = Utils.set_position_to_tile_map(player_position)


func get_color(color_type):
	match (color_type):
		ColorType.BLUE:
			return blue_ball_color
		ColorType.RED:
			return red_ball_color
		ColorType.RED:
			return purple_ball_color
	return null



func _ready() -> void:
	var level = get_parent() as Level
	if level == null:
		return
	connect("self_destructed", level, "on_ball_self_destructed",  [], CONNECT_DEFERRED)


func set_active():
	active = true

func self_destruct():
	is_self_destructing = true
	emit_signal("self_destructed")
	queue_free()

func _physics_process(delta):
	if active:
		return
	if abs(global_position.x - start_position.x) > (64 * 3 + 5):
		self_destruct()


func set_color(color):
	if (color == null or get_color(color) == null):
		return
	$Sprite.modulate = get_color(color)
	current_color = color

func _on_Ball_body_entered(body):
	self_destruct()
