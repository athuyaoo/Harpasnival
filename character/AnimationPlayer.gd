extends AnimationPlayer

signal resume

func resume():
	emit_signal("resume")
