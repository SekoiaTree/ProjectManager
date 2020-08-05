extends Panel

var descr : String = ""

signal complete
signal uncomplete

onready var checkbox = get_node("HBoxContainer3/HBoxContainer/TextureButton2")

var is_complete = false

func _ready():
	$HBoxContainer3/HBoxContainer2/Label.text = descr

func set_descr(new_descr : String):
	$HBoxContainer3/HBoxContainer2/Label.text = new_descr
	descr = new_descr

func toggled(toggle):
	if is_complete == toggle:
		return
	
	if toggle:
		complete()
	else:
		uncomplete()

func complete():
	is_complete = true
	emit_signal("complete")

func uncomplete():
	is_complete = false
	emit_signal("uncomplete")

func set_complete(cm : bool):
	is_complete = cm
	$HBoxContainer3/HBoxContainer/TextureButton2.pressed = cm
