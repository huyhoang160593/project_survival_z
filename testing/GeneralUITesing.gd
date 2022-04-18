extends Control

onready var ammoText = $AmmoText as Label

func _ready() -> void:
	var error_code = GameEvents.connect('update_ammo_value', self,"on_ammo_value_update")
	if error_code != 0:
		print_debug("ERROR connect signal in ", self.name)

func on_ammo_value_update(ammo:int, remainAmmo:int) -> void:
	if (ammo == 0 and remainAmmo == 0):
		ammoText.text = "No Ammo"
	else:
		ammoText.text = "%d / %d" % [ammo, remainAmmo]
	
