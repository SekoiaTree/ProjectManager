extends VBoxContainer

export (PackedScene) var objective

onready var bar = get_node("Container/ProgressBar")
onready var hours = get_node("Container/Label")
onready var workingButton = get_node("Container/TextureButton2")

signal add_object

var number_of_obj = 0
var completed_obj = 0

var projectName = ""
var timeSpent = 0
var isWorking = false

func _ready():
	update_project_name()

func add_object(descr : String):
	var to_add : Node = objective.instance()
	to_add.descr = descr
	to_add.connect("complete", self, "complete_obj")
	to_add.connect("uncomplete", self, "uncomplete_obj")
	add_child(to_add)
	number_of_obj += 1
	update_progress()

func add_object_bool(descr : String, completed : bool):
	var to_add : Node = objective.instance()
	to_add.descr = descr
	to_add.connect("complete", self, "complete_obj")
	to_add.connect("uncomplete", self, "uncomplete_obj")
	to_add.set_complete(completed)
	if completed: complete_obj()
	add_child(to_add)
	number_of_obj += 1
	update_progress()

func remove_object(obj : Node):
	if obj.get("is_completed"):
		completed_obj -= 1
	remove_child(obj)
	number_of_obj -= 1
	update_progress()

func complete_obj():
	completed_obj += 1
	update_progress()

func uncomplete_obj():
	completed_obj -= 1
	update_progress()

func update_progress():
	if number_of_obj == 0:
		bar.value = 100
	else:
		bar.value = float(completed_obj)/number_of_obj*100

func update_time():
	if timeSpent - floor(timeSpent) <= 0.01:
		hours.text = String(timeSpent) + ".0 hours"
	else:
		hours.text = String(timeSpent) + " hours"

func add_time_spent(time : float):
	if isWorking:
		timeSpent += time
	update_time()

func set_time_spent(time : float):
	timeSpent = time
	update_time()

func _on_TextureButton2_toggled(button_pressed):
	isWorking = button_pressed

func update_project_name():
	get_node("Container/ProjectName").text = projectName.capitalize()


func request_to_add():
	emit_signal("add_object")
