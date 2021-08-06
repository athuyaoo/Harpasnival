extends Control

var is_level_completed
export(NodePath) onready var game_label = get_node_or_null(game_label)
export(NodePath) onready var next_level_container = get_node_or_null(next_level_container)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and not is_level_completed:
		toggle_pause()

func toggle_pause():
	var will_pause = not get_tree().paused

	$AnimationPlayer.play("slide_in" if will_pause else "slide_out")
	if not will_pause: 
		yield($AnimationPlayer, "animation_finished")
	get_tree().paused = will_pause
	
	
func on_level_completed():
	is_level_completed = true
	game_label.text = "Level Completed!"
	next_level_container.visible = true
	$AnimationPlayer.play("slide_in")
	get_tree().paused = true
