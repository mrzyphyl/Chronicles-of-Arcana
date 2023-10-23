extends CharacterBody2D

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_isalive = true

var attack_inpr = false

const max_speed = 150
const accel = 70
const friction = 400

var input : Vector2 = Vector2.ZERO

var chest_e1 = false
var chest_e2 = false
var chest_e3 = false
var chest_e4 = false

var chest_h1 = false
var chest_h2 = false
var chest_h3 = false
var chest_h4 = false
var chest_h5 = false
var chest_h6 = false

var potion = preload("res://src/PotionFallingScene/potion.tscn")


@onready var animation_tree: AnimationTree = $AnimationTree

func drop_potion():
	var potion_instance = potion.instantiate()
	potion_instance.global_position = $Marker2D.global_position
	get_parent().add_child(potion_instance)

func _ready():
	animation_tree.active = true

func _process(delta):
	update_animation_parameters()

func _physics_process(delta):
	player_movement(delta)
	current_camera()
	enemy_attack()
	update_health()
	
	if health <= 0:
		player_isalive = false #go back to main_scene
		health = 0
		print("You have been killed")
		$AnimationPlayer.play("Down")
		self.queue_free()
		#get_tree().change_scene_to_file("res://src/MainScrene/main_scene.tscn")

	if chest_e1 == true:
		if Input.is_action_just_pressed("ui_accept"):
			DialogueManager.show_example_dialogue_balloon(load("res://questions/easyquestion_1.dialogue"), "eq1")
			drop_potion()
			return
	
	if chest_e2 == true:
		if Input.is_action_just_pressed("ui_accept"):
			DialogueManager.show_example_dialogue_balloon(load("res://questions/easyquestion_2.dialogue"), "eq2")
			drop_potion()
			return
	
	if chest_e3 == true:
		if Input.is_action_just_pressed("ui_accept"):
			DialogueManager.show_example_dialogue_balloon(load("res://questions/easyquestion_3.dialogue"), "eq3")
			drop_potion()
			return
	
	if chest_e4 == true:
		if Input.is_action_just_pressed("ui_accept"):
			DialogueManager.show_example_dialogue_balloon(load("res://questions/easyquestion_4.dialogue"), "eq4")
			drop_potion()
			return
	
	if chest_h1 == true:
		if Input.is_action_just_pressed("ui_accept"):
			DialogueManager.show_example_dialogue_balloon(load("res://questions/hardquestion_1.dialogue"), "hq1")
			drop_potion()
			return
	
	if chest_h2 == true:
		if Input.is_action_just_pressed("ui_accept"):
			DialogueManager.show_example_dialogue_balloon(load("res://questions/hardquestion_2.dialogue"), "hq2")
			drop_potion()
			return
	
	if chest_h3 == true:
		if Input.is_action_just_pressed("ui_accept"):
			DialogueManager.show_example_dialogue_balloon(load("res://questions/hardquestion_3.dialogue"), "hq3")
			drop_potion()
			return
	
	if chest_h4 == true:
		if Input.is_action_just_pressed("ui_accept"):
			DialogueManager.show_example_dialogue_balloon(load("res://questions/hardquestion_4.dialogue"), "hq4")
			drop_potion()
			return
	
	if chest_h5 == true:
		if Input.is_action_just_pressed("ui_accept"):
			DialogueManager.show_example_dialogue_balloon(load("res://questions/hardquestion_5.dialogue"), "hq5")
			drop_potion()
			return
	
	if chest_h6 == true:
		if Input.is_action_just_pressed("ui_accept"):
			DialogueManager.show_example_dialogue_balloon(load("res://questions/hardquestion_6.dialogue"), "hq6")
			drop_potion()
			return

func get_input():
	input.x = int(Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D)) - int(Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A))
	input.y = int(Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S)) - int(Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W))
	return input.normalized()

func player_movement(delta):
	input = get_input()
	
	if input == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() *  (friction * delta)
		else:
			velocity = Vector2.ZERO
	else: 
		velocity += (input * accel * friction)
		velocity = velocity.limit_length(max_speed)
	
	move_and_slide()
		

func update_animation_parameters():
	if(velocity == Vector2.ZERO):
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
		
	if(Input.is_action_just_pressed("attack")):
		animation_tree["parameters/conditions/attack"] = true
		Global.player_current_attack = true
		attack_inpr = true
	else:
		animation_tree["parameters/conditions/attack"] = false
	
	if(input != Vector2.ZERO):
		animation_tree["parameters/Idle/blend_position"] = input
		animation_tree["parameters/Attack/blend_position"] = input
		animation_tree["parameters/Walk/blend_position"] = input
	


func player():
	pass
	
func current_camera():
	if Global.current_scene == "world_scene":
		$Camera2D.enabled = true
	elif Global.current_scene == "open_world" and "dungeon_sence":
		$Camera2D.enabled = false
		$Camera2D2.enabled = true


func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy") or body.has_method("skeleton") or body.has_method("boss"):
		enemy_inattack_range = true

	if body.has_method("cheste1"):
		chest_e1 = true

	if body.has_method("cheste2"):
		chest_e2 = true

	if body.has_method("cheste3"):
		chest_e3 = true

	if body.has_method("cheste4"):
		chest_e4 = true

	if body.has_method("chesth1"):
		chest_h1 = true

	if body.has_method("chesth2"):
		chest_h2 = true

	if body.has_method("chesth3"):
		chest_h3 = true

	if body.has_method("chesth4"):
		chest_h4 = true

	if body.has_method("chesth5"):
		chest_h5 = true

	if body.has_method("chesth6"):
		chest_h6 = true




func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy") or body.has_method("skeleton") or body.has_method("boss"):
		enemy_inattack_range = false

	if body.has_method("cheste1"):
		chest_e1 = false
	
	if body.has_method("cheste2"):
		chest_e2 = false

	if body.has_method("cheste3"):
		chest_e3 = false

	if body.has_method("cheste4"):
		chest_e4 = false

	if body.has_method("chesth1"):
		chest_h1 = false

	if body.has_method("chesth2"):
		chest_h2 = false

	if body.has_method("chesth3"):
		chest_h3 = false

	if body.has_method("chesth4"):
		chest_h4 = false

	if body.has_method("chesth5"):
		chest_h5 = false

	if body.has_method("chesth6"):
		chest_h6 = false


func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 10
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)

func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true


func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	Global.player_current_attack = false
	attack_inpr = false

func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_regen_timer_timeout():
	if health < 100:
		health = health + 20
		if health > 100:
			health = 100
	if health <= 0:
		health = 0


func _on_area_2d_body_entered(body):
	get_tree().change_scene_to_file("res://src/OpenWorld/open_world.tscn")


func _on_area_2d_2_body_entered(body):
	get_tree().change_scene_to_file("res://src/BossBattleScene/bossbattleScene.tscn")
