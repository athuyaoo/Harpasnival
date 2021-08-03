tool
class_name Target
extends Area2D

signal target_destroyed

const TargetColor = Constants.ColorType
export(Texture) var blue_target
export(Texture) var red_target
export(Texture) var purple_target
export(TargetColor) var current_target_color = TargetColor.BLUE setget set_target_color
export(PackedScene) var explosion_vfx = preload("res://vfx/Simple Explosion.tscn")

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
		spawn_explosion_vfx(ball.get_color(ball.current_color))
		set_destroyed(true)
		emit_signal("target_destroyed")
	ball.self_destruct()

# I'm sorry Thuya for violating abstraction principles 
# but we're in a rush. please don't scream at me
func spawn_explosion_vfx(color:Color):
	var particleEffect = explosion_vfx.instance()
	particleEffect.get_node("CPUParticles2D").set_emitting(true)
	particleEffect.get_node("CPUParticles2D").color = color
	particleEffect.set_position(get_position())
	get_tree().get_root().add_child(particleEffect)
	
func _process(_delta):
	if Engine.editor_hint:
		global_position = Utils.set_position_to_tile_map(global_position)
