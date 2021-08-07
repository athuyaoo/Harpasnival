extends Control

var is_level_completed

func _ready():
	visible = false
	
func appear():
	$AnimationPlayer.play("slide_in")
