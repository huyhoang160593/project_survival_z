extends Node

signal update_ammo_ui(ammo, remainAmmo)
signal update_heart_ui(currentHeartValue)

signal gun_shot_event(rayCast, gunNode, gunOwner)
signal melee_attack_event
signal attack_finished(gunNode)
signal gun_out_ammo(reloadTime)
signal gun_add_ammo(gunNode, itemNode)
signal reload_finished(gunNode)
signal weapon_change_success(gunNode)

signal gunner_cheating(gunNode)

signal heart_decrease(targetNode, amount)

signal pick_up_item(itemNode, type, playerNode, weaponInstance, weaponType)
signal pick_up_response(itemNode, isSuccess)

signal pick_up_key(keyNode)
signal update_custom_pause_message(message)

signal push_charater(pushVector)

signal level_finished(finishedFlag)
