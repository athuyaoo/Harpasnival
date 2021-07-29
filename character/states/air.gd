extends PlayerState


func enter(msg := {}) -> void:
	if msg.has("do_jump"):
		player.velocity.y = -player.jump_impulse
		player.jump_sound.play()

func exit():
	player.update_held_item_position()

func physics_update(delta: float) -> void:
	# Movement

	var input_direction_x = player.get_input_direction()
	player.update_direction(input_direction_x)
	player.velocity.x = player.speed * input_direction_x
	player.apply_gravity(delta)
	player.move()

	# State Transitions
	if player.is_on_floor():
		if is_zero_approx(player.velocity.x):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Run")
