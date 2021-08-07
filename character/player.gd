class_name Player
extends KinematicBody2D

export var speed = 200
export var gravity = 800
export var jump_impulse = 500
export var throwing_speed = 200

export(PackedScene) var ball_scene = preload("res://ball/ball.tscn")

const pickup_sound = preload("res://sfx/pickup.wav")
const placedown_sound = preload("res://sfx/placement.wav")

onready var throw_direction := $Direction/ThrowPosition
onready var detect_hoop_raycast := $Direction/DetectHoop
onready var detect_underneath := $Direction/DetectUnderneath
onready var placed_position := $Direction/PlacePosition
onready var animation_player := $AnimationPlayer as AnimationPlayer
var velocity = Vector2.ZERO
var held_item : Hoop
onready var scene_tree = get_tree()

var collision_point_g: Vector2


func can_throw():
	return scene_tree.get_nodes_in_group("balls").size() == 0 && not is_holding_item()

# Throwing mechanic
func throw():
	var scene_instance : Ball = ball_scene.instance()
	scene_instance.set_name("ball")
	animation_player.play("throw")
	yield(animation_player, "resume")
	get_parent().add_child(scene_instance)
	var ball_impulse = Vector2.RIGHT.rotated(deg2rad(throw_direction.throwing_degrees))
	ball_impulse.x *= $Direction.scale.x
	var ball_velocity = (ball_impulse * throwing_speed)
	scene_instance.set_start_position(global_position)
	scene_instance.global_position = throw_direction.global_position
	scene_instance.linear_velocity = ball_velocity

# State helper functions, to prevent duplication
func get_input_direction():
	return (Input.get_action_strength("move_right")
		- Input.get_action_strength("move_left"))

func apply_gravity(delta:float):
	velocity.y += delta * gravity

func update_direction(horizontal_direction):
	if sign(horizontal_direction) != 0:
		$Direction.scale.x = sign(horizontal_direction)

func move():
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, 0.785398, false)

func pick_up():
	var detected_hoop := detect_hoop_raycast.get_collider() as Hoop
	print(not detected_hoop or not detected_hoop.can_pick_up
			or detected_hoop.is_anything_above() or is_holding_item())
	if (not detected_hoop or not detected_hoop.can_pick_up
			or detected_hoop.is_anything_above() or is_holding_item()):
		return
	if scene_tree.get_nodes_in_group("balls").size() > 0 or $OnGround.get_collider() == null:
		return
	detected_hoop.pick_up()
	held_item = detected_hoop
	detect_hoop_raycast.add_exception(detected_hoop)
	detect_hoop_raycast.set_collision_mask_bit(0, true)
	detect_hoop_raycast.force_raycast_update()
	
	
	detect_underneath.add_exception(detected_hoop)
	detect_underneath.force_raycast_update()
	$PlaceSound.stream = pickup_sound
	$PlaceSound.play()
	call_deferred("update_held_item_position")

func place_down():
	assert(is_holding_item())
	if (held_item.can_place_down() and $OnGround.get_collider() != null):
		held_item.place_down()
		held_item = null
		detect_hoop_raycast.clear_exceptions()
		detect_underneath.clear_exceptions()
		detect_hoop_raycast.set_collision_mask_bit(0, false)

		$PlaceSound.stream = placedown_sound
		$PlaceSound.play()

func update_held_item_position():
	if (!held_item):
		return

	var collision_point = detect_hoop_raycast.get_collision_point()
	var collider = detect_hoop_raycast.get_collider()
	
	if collider is Hoop:
		collision_point += Vector2.DOWN
	var colliding_structure_tilemap_pos = Utils.set_position_to_tile_map(collision_point)
	var detect_hoop_tilemap_pos = Utils.set_position_to_tile_map(detect_hoop_raycast.global_position)

	var is_raycast_in_structure = false

	if (collider is TileMap):
		var tilemap := collider as TileMap
		var tilemap_cell = tilemap.get_cellv(tilemap.world_to_map(detect_hoop_raycast.global_position))
		is_raycast_in_structure = tilemap_cell != TileMap.INVALID_CELL

	is_raycast_in_structure =  is_raycast_in_structure or \
		colliding_structure_tilemap_pos == detect_hoop_tilemap_pos
		
		
	var underneath_point = detect_underneath.get_collision_point()
	var underneath_collider = detect_underneath.get_collider()
	var underneath_tilemap_pos = Utils.set_position_to_tile_map(underneath_point)
	var under_hoop_tilemap_pos = Utils.set_position_to_tile_map(detect_underneath.global_position)

	var is_undercast_in_structure = false

	if (underneath_collider is TileMap):
		var tilemap := underneath_collider as TileMap
		var tilemap_cell = tilemap.get_cellv(tilemap.world_to_map(detect_underneath.global_position))
		is_undercast_in_structure = tilemap_cell != TileMap.INVALID_CELL

	is_undercast_in_structure =  is_undercast_in_structure or \
		underneath_tilemap_pos == under_hoop_tilemap_pos
	var underneath_cannot_place = (underneath_collider == null) or\
		(underneath_collider is Area2D) or\
		is_undercast_in_structure
	var cannot_place = (collider == null) or\
		is_raycast_in_structure or\
		(collider is Area2D)
	
	if cannot_place or $OnGround.get_collider() == null:
		print('cannot_place')
		if underneath_cannot_place:
			print("underneath_cannot_place")
			if $OnGround.get_collider() == null:
				held_item.future_global_position = Utils.set_position_to_tile_map(
					placed_position.global_position) - Vector2.RIGHT * $Direction.scale.x *64
			else:
				held_item.future_global_position = Utils.set_position_to_tile_map(placed_position.global_position)
		else:
			if $OnGround.get_collider() != null:
				held_item.future_global_position = underneath_tilemap_pos + Vector2.UP * 64
	else:

		held_item.future_global_position = colliding_structure_tilemap_pos + Vector2.UP * 64

func is_holding_item():
	return held_item != null
