tool
class_name Target
extends Area2D

signal target_destroyed

const TargetColor = Constants.ColorType
export(Texture) var blue_target
export(Texture) var red_target
export(Texture) var purple_target
export(TargetColor) var current_target_color = TargetColor.BLUE setget set_target_color

var is_destroyed = false setget set_destroyed

func get_texture(color):
	var textureDict = {
	TargetColor.BLUE: blue_target,
	TargetColor.RED: red_target,
	TargetColor.PURPLE: purple_target,
	}
	return textureDict[color]


func set_target_color(value):
	$Sprite.texture = get_texture(value)
	current_target_color = value


func set_destroyed(value: bool):
	is_destroyed = value
	visible = not value

func _on_Target_body_entered(ball: Ball):
	if not ball or is_destroyed:
		return
	if ball.current_color == current_target_color:
		ball.self_destruct()
		set_destroyed(true)
		emit_signal("target_destroyed")


func _process(_delta):
	if Engine.editor_hint:
		global_position = Utils.set_position_to_tile_map(global_position)
