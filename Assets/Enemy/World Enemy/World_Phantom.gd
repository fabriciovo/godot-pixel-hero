extends Node2D

export(NodePath) onready var point = get_node(point) as Node2D

var smoke = preload("res://Assets/Animations/smoke.tscn")
var damageText = preload("res://Assets/UI/FloatText.tscn")
var projectile = preload("res://Assets/Enemy/World Enemy/enemy_projectile.tscn")
var points
var ID = name

var battle_unit_xp = 100
var battle_unit_max_hp = 50
var battle_unit_damage = 10
var battle_unit_hp = battle_unit_max_hp
var teleport_pos = Vector2.ZERO

func _ready():
	add_to_group(Global.GROUPS.ENEMY)
	points = point.get_children()
	global_position = get_random_pos()
	$Change_Position_Timer.start(3)

func Destroy():
	$Sprite.visible = false
	var temp_smoke = smoke.instance()
	add_child(temp_smoke)
	SoundController.play_effect(SoundController.EFFECTS.enemy_die)
	yield(temp_smoke.get_node("AnimationPlayer"),"animation_finished")
	Global.dead_enemies.push_front(ID)
	queue_free()

func damage(damageValue):
	SoundController.play_effect(SoundController.EFFECTS.enemy_hit)
	var text = damageText.instance()
	text.set_text(str(damageValue))
	add_child(text)
	battle_unit_hp -= damageValue
	$Animation_Player.play("damage_anim")
	yield($Animation_Player, "animation_finished")
	if battle_unit_hp <= 0:
		Destroy()

func change_postion():
	$Animation_Player.play("hide")
	yield($Animation_Player, "animation_finished")
	global_position = get_random_pos()
	$Animation_Player.play("show")
	yield($Animation_Player, "animation_finished")
	attack_player()
	$Change_Position_Timer.start(3)

func attack_player():
	if battle_unit_hp > 20:
		var _temp_projectile = projectile.instance()
		_temp_projectile.global_position = global_position
		get_tree().get_current_scene().add_child(_temp_projectile)
	else:
		pass


func _on_Change_Position_Timer_timeout():
	change_postion()

func get_random_pos():
	var _size = points.size()
	var random_index = randi() % _size
	return points[random_index].position


func _on_Damage_Area_area_entered(area):
	if area.is_in_group(Global.GROUPS.SWORD):
		damage(PlayerControll.atk)

