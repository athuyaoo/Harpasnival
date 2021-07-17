class_name Player
extends KinematicBody2D

export var speed = 300
export var gravity = 800
export var jump_impulse = 500
export var throwing_speed = 200

export(PackedScene) var ball_scene = preload("res://ball/ball.tscn")

onready var throw_direction = $Direction/ThrowPosition
onready var place_position = $Direction/PlacePosition
onready var detect_hoop_raycast = $Direction/DetectHoop
var velocity = Vector2.ZERO
var held_item : Hoop
onready var scene_tree = get_tree()


# Throwing mechanic
func throw():
	if scene_tree.get_nodes_in_group("balls").size() > 0:
		return
	var scene_instance : RigidBody2D = ball_scene.instance()

	scene_instance.set_name("ball")
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
	var detected_hoop : Hoop = detect_hoop_raycast.get_collider()
	if (detected_hoop == null or !detected_hoop.can_pick_up or held_item != null):
		return
	detected_hoop.pick_up()
	held_item = detected_hoop

func place_down():
	assert(held_item != null)
	if (held_item.can_place_down()):
		held_item.place_down()
		held_item = null

func update_held_item_position():
	if (!held_item):
		return
	held_item.global_position = place_position.global_position

func is_holding_item():
	return held_item != null
