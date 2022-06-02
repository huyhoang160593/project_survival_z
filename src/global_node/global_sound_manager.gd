extends Node

func _ready() -> void:
	self.pause_mode = Node.PAUSE_MODE_PROCESS

func play_sound(soundStream: AudioStream, volumeDb: float = 0.0) -> void:
	var streamPlayer = AudioStreamPlayer.new()
	streamPlayer.stream = soundStream
	self.add_child(streamPlayer)
	streamPlayer.volume_db = volumeDb
	streamPlayer.play()
	
	yield(streamPlayer,'finished')

	streamPlayer.queue_free()

func play_3D_sound(soundStream: AudioStream, parentNode: Spatial) -> void:
	var streamPlayer = AudioStreamPlayer3D.new()
	streamPlayer.stream = soundStream
	var ownerParentNode = parentNode.get_parent()
	if (ownerParentNode == null):
		return
	ownerParentNode.add_child(streamPlayer)
	streamPlayer.global_transform = parentNode.global_transform
	
	streamPlayer.play()
	yield(streamPlayer,'finished')
	streamPlayer.queue_free()
