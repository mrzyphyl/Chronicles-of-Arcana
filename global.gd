extends Node

var current_scene = "world_scene"#open_world
var transition_scene = false

var player_current_attack = false

var player_exit_dungeon_posx = 583
var player_exit_dungeon_posy = 609
var player_start_posx = 580
var player_start_posy = 315

var game_first_loading = true

func finish_changedscene():
	if transition_scene == true:
		transition_scene = false
		if current_scene == "world_scene":
			current_scene = "open_world"
		elif current_scene == "open_world":
			current_scene = "world_scene"
		elif current_scene == "dungeon_scene":
			current_scene = "world_scene"
		else:
			current_scene = "world_scene"
	
