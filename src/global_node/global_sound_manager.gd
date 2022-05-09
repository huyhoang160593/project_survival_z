extends Node

func play_sound(soundStream: AudioStream) -> void:
	var streamPlayer = AudioStreamPlayer.new()
	streamPlayer.stream = soundStream

	self.add_child(streamPlayer)

	streamPlayer.play()

	yield(streamPlayer,'finished')

	streamPlayer.queue_free()

func play_3D_sound(soundStream: AudioStream, parentNode: Node) -> void:
	var streamPlayer = AudioStreamPlayer3D.new()
	streamPlayer.stream = soundStream
	
	parentNode.add_child(streamPlayer)
	
	streamPlayer.play()
	yield(streamPlayer,'finished')
	streamPlayer.queue_free()
