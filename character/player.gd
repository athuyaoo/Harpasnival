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

# Sounds
onready var jump_sound := $SoundJump
onready var pickup_sound := $SoundPickup
onready var place_sound := $SoundPlace
onready var throw_sound := $SoundThrow

# Throwing mechanic
func throw():
	if scene_tree.get_nodes_in_group("balls").size() > 0:
		return
	var scene_instance : RigidBody2D = ball_scene.instance()
	scene_instance.set_name("ball")
	animation_player.play("throw")
	throw_sound.play()
	yield(animation_player, "resume")

	get_parent().add_child(scene_instance)
	scene_instance.global_position = throw_direction.global_position
	var ball_impulse = Vector2.RIGHT.rotated(deg2rad(throw_direction.throwing_degrees))
	ball_impulse.x *= $Direction.scale.x
	scene_instance.linear_velocity = (ball_impulse * throwing_speed)

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
	var detected_hoop = detect_hoop_raycast.get_collider()
	if (detected_hoop == null or not detected_hoop is Hoop or !detected_hoop.can_pick_up or held_item != null):
		return
	detected_hoop.pick_up()
	held_item = detected_hoop
	pickup_sound.play()

func place_down():
	assert(held_item != null)
	if (held_item.can_place_down()):
		held_item.place_down()
		held_item = null
		place_sound.play()

func update_held_item_position():
	if (!held_item):
		return

	var collision_point = detect_hoop_raycast.get_collision_point()
	var colliding_structure_tilemap_pos = Utils.set_position_to_tile_map(collision_point)

	print(colliding_structure_tilemap_pos + Vector2.UP * 64)
	var is_raycast_in_structure = colliding_structure_tilemap_pos == \
			Utils.set_position_to_tile_map(detect_hoop_raycast.global_position)

	var cannot_place = (detect_hoop_raycast == null) or is_raycast_in_structure


	if cannot_place:
		held_item.global_position = placed_position.global_position
	else:
		held_item.global_position = colliding_structure_tilemap_pos + Vector2.UP * 64

func is_holding_item():
	return held_item != null
