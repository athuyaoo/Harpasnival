extends PlayerState

func enter(msg := {}):
	player.animation_player.play('run')

# Right now player can throw in any state, move this to states you want it to throw
func handle_input(event: InputEvent):
	if event.is_action_pressed("throw") and player.can_throw():
		state_machine.transition_to("Throw")
	if event.is_action_pressed("move_hoop"):
		if player.is_holding_item():
			player.place_down()
		else:
			player.pick_up()

func physics_update(delta: float) -> void:
	# Movement
	var input_direction_x = player.get_input_direction()
	player.update_held_item_position()
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
func exit():
	player.animation_player.stop()
