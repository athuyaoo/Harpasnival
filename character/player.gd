class_name Player
extends KinematicBody2D

export var speed = 200
export var gravity = 800
export var jump_impulse = 500
export var throwing_speed = 200

export(PackedScene) var ball_scene = preload("res://ball/ball.tscn")

onready var throw_direction := $Direction/ThrowPosition
onready var detect_hoop_raycast := $Direction/DetectHoop
onready var placed_position := $Direction/PlacePosition
onready var animation_player := $AnimationPlayer as AnimationPlayer
var velocity = Vector2.ZERO
var held_item : Hoop
onready var scene_tree = get_tree()

var collision_point_g: Vector2

# Throwing mechanic
func throw():
	if scene_tree.get_nodes_in_group("balls").size() > 0:
		return
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
	print(detected_hoop)
	if (not detected_hoop or !detected_hoop.can_pick_up or held_item != null):
		return
	detected_hoop.pick_up()
	held_item = detected_hoop
	detect_hoop_raycast.add_exception(detected_hoop)
	detect_hoop_raycast.set_collision_mask_bit(0, true)
	detect_hoop_raycast.force_raycast_update()
	update_held_item_position()

func place_down():
	assert(held_item != null)
	if (held_item.can_place_down()):
		held_item.place_down()
		held_item = null
		detect_hoop_raycast.clear_exceptions()
		detect_hoop_raycast.set_collision_mask_bit(0, false)

func update_held_item_position():
	if (!held_item):
		return


	var collision_point = detect_hoop_raycast.get_collision_point()

	var collider = detect_hoop_raycast.get_collider()
	var colliding_structure_tilemap_pos = Utils.set_position_to_tile_map(collision_point)
	var detect_hoop_tilemap_pos = Utils.set_position_to_tile_map(detect_hoop_raycast.global_position)

	var is_raycast_in_structure = false
	if (collider is TileMap):
		var tilemap := collider as TileMap
		is_raycast_in_structure = (
			tilemap.get_cellv(tilemap.world_to_map(detect_hoop_raycast.global_position))
		) != TileMap.INVALID_CELL
	is_raycast_in_structure =  is_raycast_in_structure or \
		colliding_structure_tilemap_pos == detect_hoop_tilemap_pos

	var cannot_place = (collider == null) or is_raycast_in_structure

	if cannot_place:
		held_item.global_position = Utils.set_position_to_tile_map(placed_position.global_position)
	else:
		held_item.global_position = colliding_structure_tilemap_pos + Vector2.UP * 64

func is_holding_item():
	return held_item != null
