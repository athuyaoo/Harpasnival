extends Button

var level_path : String

func _on_Level_Button_pressed():
	get_tree().change_scene(level_path)
