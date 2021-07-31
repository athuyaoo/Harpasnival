extends Area2D


signal activation_changed(is_activated)

func _on_Pedestal_body_entered(body: Player) -> void:
	if not body:
		return
	$Sprite.frame = 1
	emit_signal("activation_changed", true)


func _on_Pedestal_body_exited(body: Player) -> void:
	if not body:
		return
	$Sprite.frame = 0 # Replace with function body.
	emit_signal("activation_changed", false)
