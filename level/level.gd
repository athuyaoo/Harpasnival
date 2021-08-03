extends Node2D

export var next_scene : PackedScene = null
onready var targets = get_tree().get_nodes_in_group("targets")
var completed = false

func _ready() -> void:
	var hoops = get_tree().get_nodes_in_group("hoops")
	for hoop in hoops:
		$Pedestal.connect("activation_changed", hoop, "_on_Pedestal_activation_changed")
	for target in targets:
		target.connect("target_destroyed", self, "check_win")

func check_win():
	var all_targets_destroyed = true
	for target in targets:
		all_targets_destroyed = all_targets_destroyed and target.is_destroyed
	if not all_targets_destroyed:
		return
	on_all_targets_destroyed()


func on_all_targets_destroyed():
	completed = true
	$LevelWinSound.play()
	print("ALL TARGETS DESTROYED!")
	yield($LevelWinSound, "finished")
	$LevelWinSound.stop()

func on_ball_self_destructed():
	var balls = get_tree().get_nodes_in_group("balls")
	var all_ball_destroyed = true
	for ball in balls:
		all_ball_destroyed = all_ball_destroyed and ball.is_self_destructing
	if all_ball_destroyed and not completed:
		$LevelFailSound.play()
		for target in targets:
			target.is_destroyed = false

func _input(event):
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
