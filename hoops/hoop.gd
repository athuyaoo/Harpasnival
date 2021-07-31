tool
class_name Hoop
extends KinematicBody2D


export var can_pick_up = false setget set_can_pick_up
var is_picked_up = false setget set_is_picked_up
var can_detect_ball := false setget set_can_detect_ball

func pick_up():
	if !can_pick_up:
		return
	$CollisionShape2D.set_deferred("disabled", true)
	self.is_picked_up = true
	z_index = 2


func can_place_down():
	$PlaceCheck.force_raycast_update()
	var collider = $PlaceCheck.get_collider()
	var space_state = get_world_2d().direct_space_state
	var current_position_collisions = space_state.intersect_point(global_position, 2, [self])
	var current_position_occupied = not current_position_collisions.empty()
	z_index = 0
	return collider != null and ! current_position_occupied


func place_down():
	assert(is_picked_up and can_place_down())
	$CollisionShape2D.set_deferred("disabled", false)
	self.is_picked_up = false


func set_is_picked_up(value):
	$PickupAura.visible = ! value
	is_picked_up = value


func set_can_pick_up(value):
	$PickupAura.visible = value
	can_pick_up = value

func set_can_detect_ball(value):
	can_detect_ball = value


func _process(_delta):
	if is_picked_up or Engine.editor_hint:
		global_position = Utils.set_position_to_tile_map(global_position)


func _on_BallDetector_area_entered(area):
	var ball = (area.get_parent() as Ball)
	if not ball or not can_detect_ball:
		return

	ball.set_active()
