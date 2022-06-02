extends CanvasLayer

var current_scene = null

onready var animationPlayer = $AnimationPlayer

func _ready() -> void:
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1) as Node

func play_transition_animation() -> void:
	get_tree().paused = true
	animationPlayer.play('moonknight_blink')
	yield(animationPlayer,'animation_finished')
	animationPlayer.play_backwards('fade_in')
	get_tree().paused = false

func goto_scene(path: NodePath, withAni = false):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.
	animationPlayer.play('fade_in')
	yield(animationPlayer,'animation_finished')

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:
	call_deferred("_deferred_goto_scene", path, withAni)


func _deferred_goto_scene(path: NodePath, withAni: bool):
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)
	
	# Instance the new scene.
	current_scene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)
	
	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
	
	if(withAni):
		play_transition_animation()
	else:
		animationPlayer.play_backwards('fade_in')
		yield(animationPlayer,'animation_finished')
		get_tree().paused = false
