extends Node2D

func _ready():
	pass

func _process(delta):
	change_scene()


func _on_dungeon_exit_body_entered(body):
	if body.has_method("player"):
		Global.transition_scene = true


func _on_dungeon_exit_body_exited(body):
	if body.has_method("player"):
		Global.transition_scene = false

func change_scene():
	if Global.transition_scene == true:
		if Global.current_scene == "world_scene":
			get_tree().change_scene_to_file("res://src/OpenWorld/open_world.tscn")
			Global.finish_changedscene()
		
