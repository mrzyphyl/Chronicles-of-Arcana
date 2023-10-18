extends Node2D


func _on_quit_btn_pressed():
	get_tree().quit()


func _on_play_btn_pressed():
	get_tree().change_scene_to_file("res://src/WorldScene/world_scene.tscn")


func _on_controls_pressed():
	get_tree().change_scene_to_file("res://src/Controller/ui/OnScreenKeyboard.tscn")
