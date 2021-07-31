tool
extends Hoop

const DirectionAngle = Constants.DirectionAngle

export(Array, DirectionAngle) var available_directions = [
	DirectionAngle.LOWER_RIGHT,
	DirectionAngle.RIGHT,
	DirectionAngle.UPPER_RIGHT,
	DirectionAngle.LOWER_LEFT,
	DirectionAngle.LEFT,
	DirectionAngle.UPPER_LEFT
] setget set_available_directions

var selected_direction_index = 0 setget set_selected_direction_index

func _ready():
	set_selected_direction_index(selected_direction_index)


func set_available_directions(value:Array):
	var array_size = value.size()
	if array_size < 1 or value.size() > 6:
		return
	set_selected_direction_index(selected_direction_index)
	available_directions = value

func set_selected_direction_index(value):
	$ArrowDirection.rotation_degrees = available_directions[value]
	selected_direction_index = value


func _on_DirectionChanger_input_event(viewport, event:InputEvent, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		var new_index = (selected_direction_index + 1) % available_directions.size()
		set_selected_direction_index(new_index)


func _on_BallDetector_area_entered(area):
	._on_BallDetector_area_entered(area)
	var body = area.get_parent()
	if body is Ball:
		body.set_linear_velocity(200 * Vector2.RIGHT.rotated(
			deg2rad(available_directions[selected_direction_index])))
