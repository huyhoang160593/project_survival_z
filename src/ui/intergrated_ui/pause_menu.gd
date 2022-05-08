extends Control

var is_paused = false setget set_is_pause

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.visible = is_paused
	
	$CustomMessage.text = ''
	var error_code = GameEvents.connect('update_custom_pause_message', self, "_on_update_message")
	StaticHelper.log_error_code(error_code, self.name)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_cancel'):
		self.is_paused = !is_paused

func set_is_pause(value: bool) -> void:
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if value == false else Input.MOUSE_MODE_VISIBLE)

func _on_update_message(message: String) -> void:
	$CustomMessage.text = message

func _on_ResumeBtn_pressed() -> void:
	self.is_paused = false

func _on_QuitBtn_pressed() -> void:
	get_tree().paused = false
	SceneChanger.goto_scene('res://src/ui/separate_ui/main_menu.tscn')
