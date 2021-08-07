extends Button

var level_path : String

func _on_Level_Button_pressed():
	SceneChanger.change_scene(load(level_path))
