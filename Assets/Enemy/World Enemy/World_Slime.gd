extends "res://Assets/Enemy/World Enemy/World_Enemy.gd"

onready var obj = get_tree().current_scene.get_node("Player")
var wakeup = false

var direction = Vector2(-20, 20)
var velocity = Vector2(20,20)

func _ready():
	battle_unit_xp = 10
	battle_unit_max_hp = 5
	battle_unit_hp = battle_unit_max_hp
	battle_unit_damage = 5
	battle_unit_type = "slime"
	const_speed = 10
	speed = const_speed
	randomize()
	direction.x = rand_range(-20, 20)
	direction.y = rand_range(-20, 20)
	$Sprite.visible = false


func _physics_process(delta):
	if not wakeup:
		set_physics_process(false)
	else:
		set_physics_process(true)
		if not hit:
			var dir = (obj.global_position - global_position).normalized()
			move_and_collide(dir * speed * delta)
		knockback = knockback.move_toward(Vector2.ZERO, speed * delta)
		knockback = move_and_slide(knockback / 1.1)


func _on_Timer_timeout():
	hit = false
	timer.stop()
	$Enemy_Animation.play("slime_anim")



func _on_DetectArea_body_entered(body):
	if body.is_in_group(Global.GROUPS.PLAYER) and not wakeup:
		$Sprite.visible = true
		$Enemy_Animation.play("slime_wakeup_anim")
		yield($Enemy_Animation,"animation_finished")
		wakeup = true
		$Enemy_Animation.play("slime_anim")
