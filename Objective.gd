extends Panel

var descr : String = ""

signal complete
signal uncomplete

onready var checkbox = get_node("HBoxContainer3/HBoxContainer/TextureButton2")

var is_complete = false

func _ready():
	checkbox.connect("pressed", self, "update_status")
	$HBoxContainer3/HBoxContainer2/Label.text = descr

func set_descr(new_descr : String):
	$HBoxContainer3/HBoxContainer2/Label.text = new_descr
	descr = new_descr

func update_status():
	if is_complete == checkbox.pressed:
		return
	if checkbox.pressed:
		complete()
	else:
		uncomplete()

func complete():
	emit_signal("complete")

func uncomplete():
	emit_signal("uncomplete")
