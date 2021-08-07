extends CanvasLayer


signal next_level_pressed
signal menu_button_pressed

func level_completed():
	$LevelMenu.on_level_completed()



func _on_NextLevelButton_pressed() -> void:
	emit_signal("next_level_pressed")


func _on_MenuButton_pressed() -> void:
	emit_signal("menu_button_pressed")
