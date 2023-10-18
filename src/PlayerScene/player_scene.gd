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

@onready var animation_tree: AnimationTree = $AnimationTree

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
	if body.has_method("enemy") or body.has_method("skeleton"):
		enemy_inattack_range = true


func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy") or body.has_method("skeleton"):
		enemy_inattack_range = false

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
