extends Spatial


export(String, FILE) var levelZeroPath: String

const MIN_LEVEL = 0
export(int, 1, 10, 1) var MAX_LEVEL

var currentLevel = 0
onready var changeLevelButton = $UI/Control/VBoxContainer/HBoxContainer/ChangeLevelButton
onready var animationPlayer = $stall/AnimationPlayer
onready var spotLightTimer = $stall/SpotLight/SpotLightTimer

func _ready() -> void:
	randomize()

func gotoLevel(level: int) -> void:
	var levelPath = "res://maps/level_%d.tscn" % level
	SceneChanger.goto_scene(levelPath)

func _on_StartButton_pressed() -> void:
	if levelZeroPath.length() == 0:
		printerr("level Zero not set path yet, please goto godot and set the path")
		return
	SceneChanger.goto_scene(levelZeroPath)

func _on_QuitButton_pressed() -> void:
	get_tree().quit()


func _on_Previous_pressed() -> void:
	currentLevel = clamp(currentLevel - 1 , MIN_LEVEL, MAX_LEVEL)
	changeLevelButton.text = str(currentLevel)


func _on_Next_pressed() -> void:
	currentLevel = clamp(currentLevel + 1 , MIN_LEVEL, MAX_LEVEL)
	changeLevelButton.text = str(currentLevel)
	



func _on_ChangeLevelButton_pressed() -> void:
	gotoLevel(currentLevel)


func _on_SpotLightTimer_timeout() -> void:
	var randomType = randi() % 3
	match randomType:
		0:
			return
		1:
			animationPlayer.play('BlinkingLight')
		2:
			animationPlayer.play_backwards('BlinkingLight')
	spotLightTimer.start()
