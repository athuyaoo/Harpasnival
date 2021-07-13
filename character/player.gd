class_name Player
extends KinematicBody2D

export var speed = 300
export var gravity = 800
export var jump_impulse = 500
export var throwing_speed = 500
export(PackedScene) var ball_scene = preload("res://ball/ball.tscn")

onready var throw_direction = $Direction/ThrowDirection
var throw = 0
var velocity = Vector2.ZERO

# Right now player can throw in any state, move this to states you want it to throw
func _unhandled_input(event):
	if event.is_action_pressed("throw"):
		throw+=1
		throw()

# Throwing mechanic
func throw():
	var scene_instance : RigidBody2D = ball_scene.instance()
	assert(scene_instance != null)
	scene_instance.set_name("ball")
	get_parent().add_child(scene_instance)
	scene_instance.global_position = throw_direction.global_position
	var ball_impulse = Vector2.RIGHT.rotated(deg2rad(throw_direction.throwing_degrees))
	ball_impulse.x *= $Direction.scale.x
	scene_instance.apply_central_impulse(ball_impulse * throwing_speed)

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
	velocity = move_and_slide(velocity, Vector2.UP, false, 4, 0.785398, true)
