extends Control

onready var ammoLabel = $AmmoText as Label
onready var heartLabel = $HeartText as Label

func _ready() -> void:
	var error_code = GameEvents.connect('update_ammo_ui', self,"on_ammo_value_update")
	StaticHelper.log_error_code(error_code, self.name)
	error_code = GameEvents.connect('update_heart_ui', self, 'on_heart_value_update')
	StaticHelper.log_error_code(error_code, self.name)

func on_ammo_value_update(ammo:int, remainAmmo:int) -> void:
	if (ammo == 0 and remainAmmo == 0):
		ammoLabel.text = "No Ammo"
	else:
		ammoLabel.text = "%d / %d" % [ammo, remainAmmo]

func on_heart_value_update(currentHeartValue: int) -> void:
	heartLabel.text = "Heart: %d" % [currentHeartValue]
