extends Control

var menu_origin_position := Vector2.ZERO
var menu_origin_size := Vector2.ZERO
var menu_transition_time := 0.2

var current_menu
var menu_stack := []

var level_1_scene := "res://level design/level_1.tscn"

onready var menu_1 = $"Main Menu"
onready var menu_2 = $"Credit Menu"
onready var menu_3 = $"Level Menu"
onready var tween = $Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menu_origin_position = Vector2.ZERO
	menu_origin_size = get_viewport_rect().size
	current_menu = menu_1
	
func move_to_next_menu(next_menu_id : String): 
	var next_menu = get_menu_from_menu_id(next_menu_id)
	tween.interpolate_property(current_menu, "rect_global_position", 
		current_menu.rect_global_position, Vector2(-menu_origin_size.x, 0), 
		menu_transition_time)
	tween.interpolate_property(next_menu, "rect_global_position", 
		next_menu.rect_global_position, menu_origin_position, 
		menu_transition_time)
	tween.start()
	menu_stack.append(current_menu)
	current_menu = next_menu

func move_to_previous_menu():
	var previous_menu = menu_stack.pop_back()
	if previous_menu != null:
		tween.interpolate_property(current_menu, "rect_global_position", 
			current_menu.rect_global_position, Vector2(menu_origin_size.x, 0), 
			menu_transition_time)
		tween.interpolate_property(previous_menu, "rect_global_position", 
			previous_menu.rect_global_position, menu_origin_position, 
			menu_transition_time)
		tween.start()
		current_menu = previous_menu

func get_menu_from_menu_id(menu_id: String) -> Control:
	match menu_id:
		"menu_1":
			return menu_1
		"menu_2":
			return menu_2
		"menu_3":
			return menu_3
		_:
			return menu_1







func _on_LevelSelectButton_pressed() -> void:
	move_to_next_menu("menu_3")


func _on_CreditsButton_pressed() -> void:
	move_to_next_menu("menu_2")


func _on_BackButton_pressed() -> void:
	move_to_previous_menu()


func _on_PlayButton_pressed() -> void:
	SceneChanger.change_scene(load(level_1_scene))
