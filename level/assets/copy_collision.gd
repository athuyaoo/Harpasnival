extends TileMap

# Copies the first collision shape of the first tile onto the others
func _ready():
	var shape = tile_set.tile_get_shape(tile_set.get_tiles_ids()[0], 0)
	
	for ts in tile_set.get_tiles_ids():           # for every textures in tileset.
		if tile_set.tile_get_shapes(ts).empty():  # if texture didn't have any collision shapes.
			var c = tile_set.tile_get_texture(ts).get_width()  / int(cell_size.x)  # colums
			var r = tile_set.tile_get_texture(ts).get_height() / int(cell_size.y)  # rows
			for i in range(c * r):
				tile_set.tile_add_shape(ts, shape, Transform2D(), false, Vector2(i % c, i / c))
			tile_set.tile_set_shape(ts, ts, shape)
