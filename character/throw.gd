extends PlayerState


func enter(_msg := {}) -> void:
	var result = player.throw()
	if result is GDScriptFunctionState:
		yield(result, "completed")
	yield(player.animation_player, "animation_finished")
	state_machine.transition_to("Idle")




