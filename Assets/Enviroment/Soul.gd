class_name Soul extends Node2D

onready var collect_area = $Collect_Area

var ID = ""

func _ready():
	if !PlayerControll.ring_of_souls:
		visible = false
		collect_area.monitoring = false
		collect_area.monitorable = false

func _on_Area2D_body_entered(body):
	if body.is_in_group(Global.GROUPS.PLAYER):
		for enemy in Global.dead_enemies:
			if typeof(enemy) == TYPE_DICTIONARY and enemy.has("id"):
				if enemy["id"] == ID:
					enemy["soul"] = false
			queue_free()