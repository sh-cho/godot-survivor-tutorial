extends AudioStreamPlayer2D
class_name RandomAudioStreamPlayer2DComponent

@export var streams: Array[AudioStream]


func play_random():
	if streams == null || streams.is_empty():
		return

	stream = streams.pick_random()
	play()
