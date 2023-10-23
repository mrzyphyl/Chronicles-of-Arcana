extends CharacterBody2D


var speed = 300
var player_chase = false
var player = null

var health = 80
var check_inattack_zone = false

var can_takedamage = true

func _process(delta):
	deal_damage()
	update_health()
	
	if player_chase:
		position += (player.position - position)/speed
		$AnimatedSprite2D.play("default")
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else :
			$AnimatedSprite2D.flip_h = false
	else :
		$AnimatedSprite2D.play("idle_front")

func _on_detection_body_entered(body):
	player = body
	player_chase = true


func _on_detection_body_exited(body):
	player = null
	player_chase = false

func skeleton():
	pass


func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		check_inattack_zone = true


func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		check_inattack_zone = false

func deal_damage():
	if check_inattack_zone and Global.player_current_attack == true:
		if can_takedamage == true:
			health = health - 20
			$take_damage_cooldown.start()
			can_takedamage = false
			print("Vampire health ", health)
			if health <=0:
				queue_free()

func update_health():
	var healthbar = $healthbar
	healthbar.value = health

func _on_take_damage_cooldown_timeout():
	can_takedamage = true
