extends VBoxContainer

export (PackedScene) var objective

onready var bar = get_node("Container/ProgressBar")

var number_of_obj = 0
var completed_obj = 0

func _ready():
	add_object("yo")

func add_object(descr : String):
	var to_add : Node = objective.instance()
	to_add.descr = descr
	to_add.connect("complete", self, "complete_obj")
	to_add.connect("uncomplete", self, "uncomplete_obj")
	add_child(to_add)
	number_of_obj += 1

func complete_obj():
	completed_obj += 1

func uncomplete_obj():
	completed_obj -= 1

func update_progress():
	bar.value = float(completed_obj)/number_of_obj*100
