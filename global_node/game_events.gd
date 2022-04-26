extends Node

signal update_ammo_ui(ammo, remainAmmo)
signal update_heart_ui(currentHeartValue)

signal gun_shot_event(rayCast)
signal melee_attack_event
signal attack_finished
signal gun_out_ammo(reloadTime)
signal gun_add_ammo(gunNode)
signal reload_finished(gunNode)
signal weapon_change_success(gunNode)

signal heart_decrease(targetNode, amount)

signal pick_up_item(type, playerNode, weaponInstance, weaponType)
