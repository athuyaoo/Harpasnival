tool
extends Hoop

const DirectionAngle = Constants.DirectionAngle
const ArrowDirectionScene = preload("res://hoops/direction_hoop/arrow_direction.tscn")
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
	var disabled_directions = $DisabledDirections
	for direction in available_directions:
		var arrow_direction_node = ArrowDirectionScene.instance()
		arrow_direction_node.rotation_degrees = direction
		disabled_directions.add_child(arrow_direction_node, true)


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
	if get_tree().get_nodes_in_group("balls").size() > 0:
		return
	if event is InputEventMouseButton and event.is_pressed():
		$DirectionSound.play()
		var new_index = (selected_direction_index + 1) % available_directions.size()
		set_selected_direction_index(new_index)


func _on_BallDetector_area_entered(area):
	._on_BallDetector_area_entered(area)
	var ball = (area.get_parent() as Ball)
	if ball and can_detect_ball:
		ball.new_velocity = (200 * Vector2.RIGHT.rotated(
			deg2rad(available_directions[selected_direction_index])))
