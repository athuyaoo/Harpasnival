tool
extends Area2D

const TargetColor = Constants.ColorType
export(Texture) var blue_target
export(Texture) var red_target
export(Texture) var purple_target
export(TargetColor) var current_target_color = TargetColor.BLUE setget set_target_color

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

func _on_Target_body_entered(body: PhysicsBody2D):
	if body is Ball:
		if body.current_color == current_target_color:
			print(get_tree().get_nodes_in_group("target").size())
			if get_tree().get_nodes_in_group("target").size() == 1:
				print("WIN")
			queue_free()
		body.queue_free()

func _process(_delta):
	if Engine.editor_hint:
		global_position = Utils.set_position_to_tile_map(global_position)
