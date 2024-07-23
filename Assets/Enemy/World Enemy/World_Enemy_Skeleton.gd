class_name World_Skeleton extends World_Enemy

onready var skeleton_enemy_anim = $Skeleton_Animation

const CHANGE_DIRECTION_INTERVAL = 1.0

var random_direction_timer = 0.0
var direction = Vector2.RIGHT
var last_direction = Vector2.ZERO
var attacking = false
var dir = 0

func _ready():
	configure_battle_unit()
	initialize_movement_control()
	randomize()

func configure_battle_unit():
	ID = name
	battle_unit_xp = 10
	battle_unit_max_hp = 5
	battle_unit_damage = 3
	battle_unit_hp = battle_unit_max_hp
	const_speed = 200
	speed = const_speed

func initialize_movement_control():
	$Shoot_Timer.start(rand_range(3.0, 10.0))
	pick_random_direction()

func _physics_process(_delta):
	if hit: 
		attacking = false
		return
	if battle_unit_hp <= 0: return
	update_random_direction_timer(_delta)
	move_enemy(_delta)

func update_random_direction_timer(_delta):
	random_direction_timer += _delta
	if random_direction_timer >= CHANGE_DIRECTION_INTERVAL:
		random_direction_timer = 0.0
		pick_random_direction()

func pick_random_direction():
	if attacking: return
	match randi() % 4:
		0:
			direction = Vector2.UP
			skeleton_enemy_anim.play("up")
			dir = 2
		1:
			direction = Vector2.DOWN
			skeleton_enemy_anim.play("down")
			dir = 0
		2:
			direction = Vector2.LEFT
			skeleton_enemy_anim.play("left")
			$Sprite.flip_h = true
			dir = 3
		3:
			direction = Vector2.RIGHT
			skeleton_enemy_anim.play("left")
			$Sprite.flip_h = false
			dir = 1
			
		_:
			attacking = true

func move_enemy(_delta):
	var _dir = move_and_slide(direction * speed * _delta)