class_name Text_Box extends MarginContainer
 
const MAX_WIDTH = 224

signal on_end_dialog()

var dialog_name = ""
var can_continue = false
export(float) var textSpeed = 0.05

onready var label_name = $MarginContainer/VBoxContainer/Name
onready var label_text = $MarginContainer/VBoxContainer/Label
onready var timer = $Timer

var dialog
var phrase_num = 0
var finished = false
var dialog_path = "res://Assets/Dialogs/"
var file = ""
func _ready():
	visible = false

func start_dialog():
	visible = true
	file += dialog_path + dialog_name
	timer.wait_time = textSpeed
	dialog = getDialog()
	nextPhrase()
 
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") and visible:
		if finished:
			nextPhrase()
		else:
			label_text.visible_characters = len(label_text.text)
 
func getDialog():

	if finished: return
	var f = File.new()
	assert(f.file_exists(file), "File path does not exist")
	
	f.open(file, File.READ)
	var json = f.get_as_text()
	
	var output = parse_json(json)
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []
 
func nextPhrase():
	if phrase_num >= len(dialog):
		visible = false
		finished = false
		can_continue = true
		phrase_num = 0
		dialog = []
		dialog_name = ""
		file = ""
		emit_signal("on_end_dialog")
		return
	finished = false
	label_name.text = dialog[phrase_num]["Name"]
	label_text.text = dialog[phrase_num]["Text"]
	label_text.visible_characters = 0
	while label_text.visible_characters < len(label_text.text):
		label_text.visible_characters += 1
		timer.start()
		yield(timer, "timeout")
	
	finished = true
	phrase_num += 1
	return
