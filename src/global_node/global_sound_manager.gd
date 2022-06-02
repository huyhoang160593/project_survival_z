extends Node

var enemySoundArray: Array = [
	preload('res://assets/sounds/sfx/monster_growl_1.wav'),
	preload('res://assets/sounds/sfx/monster_growl_2.wav'),
	preload('res://assets/sounds/sfx/monster_growl_3.wav'),
	preload('res://assets/sounds/sfx/monster_growl_4.wav'),
	preload('res://assets/sounds/sfx/monster_growl_5.wav'),
]
var enemySoundArraySize = enemySoundArray.size()

func _ready() -> void:
	self.pause_mode = Node.PAUSE_MODE_PROCESS
	randomize()

func play_sound(soundStream: AudioStream, volumeDb: float = 0.0) -> void:
	var streamPlayer = AudioStreamPlayer.new()
	streamPlayer.stream = soundStream
	self.add_child(streamPlayer)
	streamPlayer.volume_db = volumeDb
	streamPlayer.play()
	
	yield(streamPlayer,'finished')

	streamPlayer.queue_free()

func play_3D_sound(soundStream: AudioStream, parentNode: Spatial, unitDb: float = 0.0, unitSize = 1.0) -> void:
	var streamPlayer = AudioStreamPlayer3D.new()
	streamPlayer.stream = soundStream
	var ownerParentNode = parentNode.get_parent()
	if (ownerParentNode == null):
		return
	ownerParentNode.add_child(streamPlayer)
	streamPlayer.global_transform = parentNode.global_transform
	streamPlayer.unit_db = unitDb
	streamPlayer.play()
	yield(streamPlayer,'finished')
	streamPlayer.queue_free()
	
func play_random_enemy_sound(parentNode: Spatial) -> void:
	var enemySoundIndex = randi() % enemySoundArraySize
	play_3D_sound(enemySoundArray[enemySoundIndex], parentNode, 20.0)
