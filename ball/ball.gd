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

const Level := preload("res://level design/level.gd")


func set_start_position( player_position: Vector2):
	active = false
	start_position = Utils.set_position_to_tile_map(player_position)


onready var colorDict = {
	ColorType.BLUE: blue_ball_color,
	ColorType.RED: red_ball_color,
	ColorType.PURPLE: purple_ball_color,
}

func _ready() -> void:
	var level = get_parent() as Level
	if level == null:
		return

	connect("self_destructed", level, "on_ball_self_destructed",  [], CONNECT_DEFERRED)
	print(self, "ready!")

func set_active():
	active = true

func self_destruct():
	is_self_destructing = true
	print("self_destruct", self)
	emit_signal("self_destructed")
	queue_free()

func _physics_process(delta):
	if active:
		return
	if abs(global_position.x - start_position.x) > (64 * 3 + 5):
		self_destruct()


func set_color(color):
	if (color == null or colorDict[color] == null):
		return
	$Sprite.modulate = colorDict[color]
	current_color = color

func _on_Ball_body_entered(body):
	self_destruct()
