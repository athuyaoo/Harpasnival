extends PlayerState

# Right now player can throw in any state, move this to states you want it to throw
func handle_input(event: InputEvent):
	if event.is_action_pressed("throw"):
		player.throw()

func physics_update(delta: float) -> void:
	# Movement
	var input_direction_x = player.get_input_direction()
	player.update_direction(input_direction_x)
	player.velocity.x = player.speed * input_direction_x
	player.apply_gravity(delta)
	player.move()

	# State Transitions
	if not player.is_on_floor():
		state_machine.transition_to("Air")
	elif Input.is_action_just_pressed("move_up"):
		state_machine.transition_to("Air", {do_jump = true})
	elif is_equal_approx(input_direction_x, 0.0):
		state_machine.transition_to("Idle")
