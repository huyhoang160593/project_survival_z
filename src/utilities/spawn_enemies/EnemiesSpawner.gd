extends Spatial

var pusherScene: PackedScene = preload('res://src/charaters/general_enemy/the_pusher/ThePusher.tscn')
var healerScene: PackedScene = preload('res://src/charaters/general_enemy/the_healer/TheHealer.tscn')
var gunnerScene: PackedScene = preload('res://src/charaters/general_enemy/the_gunner/TheGunner.tscn')

enum EnemyType {PUSHER, HEALER, GUNNER}
export(Array, EnemyType) var customListEnemies

onready var spawnerPositions = $SpawnerPositions
onready var activeArea = $ActiveArea

func _ready() -> void:
	randomize()

func _on_ActiveArea_body_entered(body: Node) -> void:
	if not body is Player:
		return
	if (spawnerPositions.get_child_count() == 0):
		print("There is no position to spawn enemies, please add more nodes Position3D to SpawnerPositions node")
		return
	if (spawnerPositions.get_child_count() == 1):
		var positionNode = spawnerPositions.get_child(0) as Position3D
		for enemyType in customListEnemies:
			_spawn_ememy_instance(enemyType, positionNode)
	else:
		for enemyType in customListEnemies:
			var positionIndex:int = randi() % spawnerPositions.get_child_count()
			var positionNode = spawnerPositions.get_child(positionIndex) as Position3D
			_spawn_ememy_instance(enemyType, positionNode)
	activeArea.queue_free()

func _spawn_ememy_instance(enemyType: int, positionNode: Position3D) -> void:
	var enemiesInstance = null
	if enemyType == EnemyType.PUSHER:
		enemiesInstance = pusherScene.instance()
	elif enemyType == EnemyType.HEALER:
		enemiesInstance = healerScene.instance()
	elif enemyType == EnemyType.GUNNER:
		enemiesInstance = gunnerScene.instance()
	positionNode.add_child(enemiesInstance)
