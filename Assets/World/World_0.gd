extends Node2D

func _ready():
	if Global.doorName:
		var door_node = find_node(Global.doorName)
		if door_node:
			$Player.global_position = door_node.global_position
