extends Node2D

const menu_music = preload("res://music/wip.mp3")

func _ready() -> void:
	MusicPlayer.start_playing(menu_music)
