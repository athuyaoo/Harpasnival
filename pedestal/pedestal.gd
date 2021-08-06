tool
extends Area2D

signal activation_changed(is_activated)

func _on_Pedestal_body_entered(body: PhysicsBody2D) -> void:
	if not body:
		return
	$Sprite.frame = 1
	emit_signal("activation_changed", true)
	$AudioStreamPlayer.play()


func _on_Pedestal_body_exited(body: PhysicsBody2D) -> void:
	if not body:
		return
	$Sprite.frame = 0 # Replace with function body.
	emit_signal("activation_changed", false)

func _process(delta: float) -> void:
	if Engine.editor_hint:
		global_position = Utils.set_position_to_tile_map(global_position)
