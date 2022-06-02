extends Object
class_name Constants

#--------------------------General--------------------------#
enum ItemType { NOTHING, HEART, AMMO, WEAPON, KEY }
enum Weapon { MAIN, SECOND, MELEE, SPECIAL , NONE }
enum { IDLE, AIR, MOVE, SHOOT, AIM_DOWN_SIGN, CHANGE_WEAPON, RELOAD_AMMO, MELEE_ATTACK }

#---------------------------Player---------------------------#
const MIN_CAMERA_ANGLE = -60
const MAX_CAMERA_ANGLE = 85
const FOV_DEFAULT = 70
const FOV_ADS = 55
const ADS_LERP = 30
const MAX_HEART = 100

const MovingStateDict = {
	IDLE: "IDLE",
	AIR: "AIR",
	MOVE: "MOVE",
}
const EquipStateDict = {
	IDLE: "IDLE",
	SHOOT: "SHOOT",
	AIM_DOWN_SIGN: "AIM_DOWN_SIGN",
	CHANGE_WEAPON: "CHANGE_WEAPON",
	RELOAD_AMMO: "RELOAD_AMMO",
	MELEE_ATTACK: "MELEE_ATTACK", 
}

#---------------------------Enemy---------------------------#

