extends AudioStreamPlayer

func get_track_name(track_path):
	match track_path:
		"res://music/dinotorial.mp3":
			return "dinotorial"
		"res://music/jazz_in_paris.mp3":
			return "jazz_in_paris"
		"res://music/off_to_osaka.mp3":
			return "off_to_osaka"
		"res://music/sneaky_snitch.mp3":
			return "sneaky_snitch"
		"res://music/wip.mp3":
			return "wip"

func start_playing(stream_to_play: AudioStream):
	print(get_track_name(stream_to_play.resource_path))
	stop_playing()
	if OS.has_feature('JavaScript'):
		var track_name = get_track_name(stream_to_play.resource_path)
		JavaScript.eval("if (!" + track_name + ".playing()) {" + track_name + ".play();}")
	else:
		stream = stream_to_play
		play()

func stop_playing():
	if OS.has_feature('JavaScript'):
		JavaScript.eval("Howler.stop();")
	else:
		stop()
