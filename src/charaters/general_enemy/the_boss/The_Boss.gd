extends Enemy

var heartChangeFlag = false

export(NodePath)onready var heartBar = get_node(heartBar) as ProgressBar 

func _ready() -> void:
	var error_code = GameEvents.connect('heart_decrease',self,"boss_attacked_handle")
	StaticHelper.log_error_code(error_code, self.name)
	modelAnimationPlayer = get_node(modelAnimationPlayer) as AnimationPlayer
	heartBar.max_value = self.MAX_HEART
	heartBar.value = self.current_heart
	modelAnimationPlayer.play("Slam")

func boss_attacked_handle(targetNode: Spatial, _ammount: int) -> void:
	if(targetNode != self):
		return
	heartChangeFlag = true
	
	
func _process(delta: float) -> void:
	heart_bar_handle()

func heart_bar_handle() -> void:
	if not heartChangeFlag:
		return
	if(int(heartBar.value) == self.current_heart):
		heartChangeFlag = false
		return
	heartBar.value = lerp(heartBar.value, self.current_heart, 0.5)


func _on_SightRange_body_entered(body: Node) -> void:
	if body is Player:
		var UIControl = $HeartBar/UIControl
		if(not UIControl.visible):
			UIControl.visible = true
