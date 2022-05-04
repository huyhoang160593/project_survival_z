extends Spatial

export(int,30,100,10) var damage

func _ready() -> void:
	var error_code = GameEvents.connect('melee_attack_event', self, 'on_melee_attack_event_handle')
	StaticHelper.log_error_code(error_code, self.name)
	error_code = GameEvents.connect('weapon_change_success', self, "_on_weapon_change_success_handle")
	StaticHelper.log_error_code(error_code, self.name)
	

func on_melee_attack_event_handle() -> void:
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play('ATTACK')
		$AnimationPlayer.queue('RETURN')
	if $AnimationPlayer.current_animation == 'ATTACK':
		for body in $Hitbox.get_overlapping_bodies():
			if not body is Enemy:
				continue
			GameEvents.emit_signal('heart_decrease', body, damage)
	GameEvents.emit_signal('attack_finished', self)

func _on_weapon_change_success_handle(weaponNode: Spatial) -> void:
	if weaponNode == self:
		GameEvents.emit_signal('update_ammo_ui', 0, 0)
