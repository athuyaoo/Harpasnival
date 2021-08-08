extends Node2D

# Modified from https://github.com/benbishopnz/godot-credits
export var next_level_scene : PackedScene = null
const main_menu_path = "res://level/main menu.tscn"

const section_time := 1.2
const line_time := 0.6
const base_speed := 100
const title_color := Color.gold

var scroll_speed := base_speed

onready var line := $CreditsContainer/Line
var started := false
var finished := false

var section
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []

var credits = [
	[
		"Made by the NUS Games Development Group"
	],[
		"Thuya Oo",
		"Prototyping",
		"UI Design",
		"Programming Lead"
	],[
		"Cheng Geng",
		"Story Direction",
		"Character Design",
		"Character Animation",
		"Ending Art"
	],[
		"Abner",
		"Art Direction",
		"Colour Rebalancing",
		"Tilemap Repainting"
	],[
		"Hagu-nyan",
		"Game Design",
		"Level Design",
		"Title Art",
		"Minor Art Assets",
		"Minor Programming Assets",
	],[
		"Fonts used",
		"Delius Regular, HVD Comic Serif Pro"
	],[
		"Music used",
		"(Title Screen) Currently untitled song by",
		"Hagu-nyan's Cozy Corner",
		"",
		"(Main Game) Off to Osaka by Kevin MacLeod",
		"",
		"(Main Game) Jazz in Paris by",
		"Media Rights Productions",
		"",
		"(Ending) Sneaky Snitch by Kevin MacLeod",
		"",
		"(Credit Roll) Dinotorial by Cheng Geng",
		"arranged by Hagu-nyan"
	],[
		"Tilemaps and Background",
		"Kenney Game Assets",
		"Fantasy Skybox FREE"
	],[""],
	[
		"Thank you for playing!"
	]
]


func _process(delta):
	var scroll_speed = base_speed * delta
	
	if section_next:
		section_timer += delta
		if section_timer >= section_time:
			section_timer -= section_time
			
			if credits.size() > 0:
				started = true
				section = credits.pop_front()
				curr_line = 0
				add_line()
	
	else:
		line_timer += delta
		if line_timer >= line_time:
			line_timer -= line_time
			add_line()
	
	if lines.size() > 0:
		for l in lines:
			l.rect_position.y -= scroll_speed
			if l.rect_position.y < -l.get_line_height():
				lines.erase(l)
				l.queue_free()
	elif started:
		finish()


func finish():
	if not finished:
		finished = true
		# NOTE: This is called when the credits finish
		# - Hook up your code to return to the relevant scene here, eg...
		#get_tree().change_scene("res://scenes/MainMenu.tscn")
		$"Ending UI".appear()

func add_line():
	var new_line = line.duplicate()
	new_line.text = section.pop_front()
	lines.append(new_line)
	if curr_line == 0:
		new_line.add_color_override("font_color", title_color)
	$CreditsContainer.add_child(new_line)
	
	if section.size() > 0:
		curr_line += 1
		section_next = false
	else:
		section_next = true

func _on_Ending_UI_menu_button_pressed():
	SceneChanger.change_scene(load(main_menu_path)) 


func _on_Ending_UI_next_level_pressed():
	SceneChanger.change_scene(next_level_scene) 
