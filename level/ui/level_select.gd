extends Control

export (PackedScene) var base_button
export (int) var total_levels = 12
export (NodePath) var grid

func _ready():
	grid = get_node(grid)
	
	if !total_levels <= 4:
		column_size()
	
	for i in range(0, total_levels):
		generate_buttons(i+1)
	
func generate_buttons(name: int):
	var bb = base_button.instance()
	bb.set_name(str(name))
	bb.set_text(str(name))
	bb.level_path = "res://level design/Level " + str(name) + ".tscn"
	grid.add_child(bb)
	
func column_size():
	grid.columns = total_levels/3 + (total_levels % 3)
