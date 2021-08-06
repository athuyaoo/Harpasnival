extends Node

onready var scene_tree = get_tree()

func change_scene(scene: PackedScene):
	scene_tree.paused = true
	if not scene or not scene.can_instance():
		return
	$AnimationPlayer.play("fade")
	yield($AnimationPlayer, "animation_finished")

	scene_tree.change_scene_to(scene)
	yield(scene_tree, "idle_frame")
	$AnimationPlayer.play_backwards("fade")
	scene_tree.paused = false
