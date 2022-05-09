extends Spatial

enum Action { START, FINISHED }

onready var blockWalls = $BlockWalls
onready var keys = $Keys

var key_count:= -1

var format_message := "Số chìa khoá cần tìm trong khu vực chỉ định: %d."

func _ready() -> void:
	var keysNodeCount = keys.get_child_count()
	if keysNodeCount == 0:
		printerr("There is no key provide to this objective")
	key_count = keysNodeCount
	var error_code = GameEvents.connect('pick_up_key', self, 'on_pickup_key')
	StaticHelper.log_error_code(error_code, self.name)

func on_pickup_key(keyNode: Spatial):
	key_count -= 1
	if key_count == 0:
		GameEvents.emit_signal('update_custom_pause_message', '')
		GameEvents.emit_signal('pick_up_response', keyNode, true)
		wall_action(Action.FINISHED)
		return

	var formatted_message = format_message % key_count
	GameEvents.emit_signal('update_custom_pause_message', formatted_message)
	GameEvents.emit_signal('pick_up_response', keyNode, true)

func _on_ActiveArea_body_exited(body: Node) -> void:
	if not body is Player:
		return
	if key_count <= 0:
		printerr("Objective canceled, there is no key provide in the map")
		wall_action(Action.FINISHED)
	if blockWalls.get_child_count() == 0:
		printerr("Please add wall to prevent player from escaped")
		return
	$BackgroundMusic.play()
	wall_action(Action.START)
	var formatted_message = format_message % key_count
	GameEvents.emit_signal('update_custom_pause_message', formatted_message)

	$ActiveArea.queue_free()

func wall_action(actionType: int) -> void:
	for wall in blockWalls.get_children():
		wall = wall as ShieldWall
		if actionType == Action.START:
			wall.active_collistion()
		elif actionType == Action.FINISHED:
			wall.on_wall_break()
