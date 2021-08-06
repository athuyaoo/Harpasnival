extends Node

# Shamelessly stolen from https://www.youtube.com/watch?v=SiFuVJz2H-I

var dialogue = [
	"That's the last one of them! We've won, Maru-kun!",
	"Good job, Clown-chan! You've destroyed all the PILLARS OF SOCIETY!\nNow that we've brought the CARNIVAL to the people, we gamers are free to roam!\nNever again shall GAMERS be OPPRESSED!",
	"Oh no, it appears that my efforts to rid my local communities of oppression have only replaced the old guard with a new tyrannical class of gamers.\n\nThe only way I can live with this guilt is by sharing the blame with this ball.",
	"All of my INTERACTIONS with you have merely been the REFLECTION of your own MISPLACED RESENTMENT.\n\nI am henceforth INANIMATE, as I should always have been.",
	"Oh, dear me."
]

var dialogue_index = 0
var active = true
var finished = false

func _ready():
	load_dialogue()
	
func _physics_process(delta):
	if active:
		if Input.is_action_just_pressed("ui_accept"):
			if finished == true:
				load_dialogue()
			else:
				$Tween.stop_all()
				$Dialogue.percent_visible = 1
				finished = true
	

func load_dialogue():
	if dialogue_index < dialogue.size():
		active = true
		finished = false
		toggle_active(dialogue_index)
		
		$Dialogue.visible = true
		$Dialogue.text = dialogue[dialogue_index]
		var time = 0.02 * len(dialogue[dialogue_index])
		dialogue_index += 1
		
		$Dialogue.percent_visible = 0
		$Tween.interpolate_property(
			$Dialogue, "percent_visible", 0, 1, time, 
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		$Tween.start()
	else:
		$Dialogue.visible = false
		$Clown.modulate = Color(0.7, 0.7, 0.7)
		$Ball1.modulate = Color(0.7, 0.7, 0.7)
		finished = true
		active = false

func toggle_active(dialogue_index):
	$"Speech Bubble".scale.x *= -1
	if dialogue_index % 2 == 0:
		$Clown.modulate = Color(1, 1, 1)
		$Ball1.modulate = Color(0.7, 0.7, 0.7)
	else:
		$Ball1.modulate = Color(1, 1, 1)
		$Clown.modulate = Color(0.7, 0.7, 0.7)

func _on_Tween_tween_completed(object, key):
	finished = true
