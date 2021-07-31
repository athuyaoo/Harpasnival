class_name Utils
extends Node


static func set_position_to_tile_map(current_position: Vector2):
	var TILEMAP_SIZE = 64
	var new_position = Vector2.ZERO
	var offset = Vector2.ONE * (TILEMAP_SIZE / 2)
	new_position = ((current_position - offset) / (TILEMAP_SIZE)).round() \
		* (TILEMAP_SIZE) + offset
	return new_position


