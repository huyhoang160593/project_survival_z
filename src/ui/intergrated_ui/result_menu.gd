extends Control

export(String, FILE) var mainMenuPath: String
export(String, FILE) var currentLevel: String
export(String, FILE) var nextLevel: String

var is_paused = false setget set_is_pause
var missionFinished = null setget set_mission_finished

var winSound: AudioStream = preload('res://assets/sounds/sfx/win_sound.wav')
var loseSound: AudioStream = preload('res://assets/sounds/sfx/lose_sound.wav')

func _ready() -> void:
	var error_code = GameEvents.connect('level_finished', self, "on_level_finished_handle")
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.visible = is_paused

func on_level_finished_handle(isFinished: bool) -> void:
	self.missionFinished = isFinished
	self.is_paused = true

func set_is_pause(value: bool) -> void:
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if value == false else Input.MOUSE_MODE_VISIBLE)

func set_mission_finished(value: bool) -> void:
	if value:
		GlobalSoundManager.play_sound(winSound)
		$ResultText.text = "Vòng lặp hoàn tất, hãy chuẩn bị cho những thứ thách tiếp theo"
		$HBoxContainer/ResetLeverBtn.visible = false
		$HBoxContainer/NextLoopBtn.visible = true
	else:
		GlobalSoundManager.play_sound(loseSound)
		$ResultText.text = "Hãy thử lại lần nữa nào!"
		$HBoxContainer/ResetLeverBtn.visible = true
		$HBoxContainer/NextLoopBtn.visible = false

func _on_MainMenuBtn_pressed() -> void:
	if (mainMenuPath.length() == 0):
		printerr("Main Menu path not set, check the node")
	get_tree().paused = false
	SceneChanger.goto_scene(mainMenuPath)


func _on_NextLoopBtn_pressed() -> void:
	if (nextLevel.length() == 0):
		printerr("NextLevel path not set, check and set in the inspector")
	get_tree().paused = false
	SceneChanger.goto_scene(nextLevel)


func _on_ResetLeverBtn_pressed() -> void:
	if (currentLevel.length() == 0):
		printerr("CurrentLevel path not set, check and set in the inspector")
	get_tree().paused = false
	SceneChanger.goto_scene(currentLevel)
