extends CharacterBody2D

const max_speed = 120
const accel = 40
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
	elif Global.current_scene == "open_world":
		$Camera2D.enabled = false
		$Camera2D2.enabled = true
