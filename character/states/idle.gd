extends PlayerState

# Right now player can throw in any state, move this to states you want it to throw
func handle_input(event: InputEvent):
	if event.is_action_pressed("throw"):
		player.throw()

func enter(_msg := {}) -> void:
	player.velocity = Vector2.ZERO

func physics_update(delta: float) -> void:
	# Movement
	player.apply_gravity(delta)
	player.move()

	# State Transitions
	if not player.is_on_floor():
		state_machine.transition_to("Air")
	elif Input.is_action_just_pressed("move_up"):
		state_machine.transition_to("Air", {do_jump = true})
	elif not is_zero_approx(player.get_input_direction()):
		state_machine.transition_to("Run")


