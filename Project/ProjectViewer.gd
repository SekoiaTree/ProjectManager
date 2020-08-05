extends Control

export (PackedScene) var projectScene

onready var projectSlot = get_node("View/VBoxContainer")
onready var projectSelector = get_node("View/ProjectSlots")

onready var addTaskDialog = get_node("Dialogs/ConfirmationDialog")
onready var addProjectDialogText = get_node("Dialogs/ConfirmationDialog2/LineEdit")
onready var errorDialog = get_node("Dialogs/ErrorDialog")
onready var fileDialog = get_node("Dialogs/FileDialog")

onready var timer = get_node("ProjectTimer")

var last_focus_time = 0

var is_project_open = false

func _ready():
	pass

func save_project(filename : String):
	if not is_project_open or projectSlot.get_child_count() == 0:
		output_error("Cannot find project to save!")
	var file = File.new()
	var json = {}
	
	json["TODOelements"] = {}
	
	for child in projectSlot.get_child(0).get_children():
		if typeof(child.get("descr")) == TYPE_NIL or typeof(child.get("is_complete")) == TYPE_NIL:
			continue
		json["TODOelements"][child.descr] = child.is_complete
	
	json["timeSpent"] = projectSlot.get_child(0).timeSpent
	
	file.open("user://" + filename.get_basename() + ".todo", File.WRITE)
	file.store_string(to_json(json))
	file.close()

func open_project(filename : String):
	for child in projectSlot.get_children():
		child.queue_free()
	
	var projectNode : Node = projectScene.instance()
	projectSlot.add_child(projectNode)
	
	var file = File.new()
	var json = ""
	
	if file.file_exists("user://" + filename.get_basename() + ".todo"):
		file.open("user://" + filename.get_basename() + ".todo", File.READ)
		json = file.get_as_text()
		json = parse_json(json)
	else:
		json = {}
	
	if typeof(json) != TYPE_DICTIONARY:
		json = {}
	if json.has("TODOelements") and typeof(json.get("TODOelements")) == TYPE_DICTIONARY:
		for todo in json["TODOelements"]:
			projectNode.add_object_bool(todo, json["TODOelements"][todo])
	
	projectNode.projectName = filename.get_basename()
	if json.has("timeSpent"):
		projectNode.set_time_spent(float(json["timeSpent"]))
	else:
		projectNode.set_time_spent(0)
	
	projectNode.update_project_name()
	projectNode.connect("add_object", self, "open_dialog")
	
	is_project_open = true
	
	projectSelector.add_project_slot(filename.get_basename())

func open_dialog():
	addTaskDialog.popup()


func switch_project(name : String):
	if is_project_open and projectSlot.get_child_count() != 0: save_project(projectSlot.get_child(0).projectName)
	open_project(name.get_file().get_basename())

func _confirmed_addition():
	if not is_project_open or projectSlot.get_child_count() == 0:
		return
	projectSlot.get_child(0).call("add_object", addTaskDialog.get_node("LineEdit").text)
	addTaskDialog.get_node("LineEdit").text = ""
	save_project(projectSlot.get_child(0).projectName)


func create_new_project():
	var file = File.new()
	if not file.file_exists("user://" + addProjectDialogText.text.get_basename() + ".todo"):
		open_project(addProjectDialogText.text)
		save_project(addProjectDialogText.text)
		addProjectDialogText.text = ""
	else:
		output_error("Project already exists.")

func output_error(text : String):
	errorDialog.dialog_text = text
	errorDialog.popup_centered_minsize(Vector2(100, 100))


func _on_FileDialog_file_selected(path : String):
	switch_project(path)


func _on_ProjectTimer_timeout():
	if not is_project_open or projectSlot.get_child_count() == 0:
		return
	projectSlot.get_child(0).call("add_time_spent", 0.1)
	timer.start()

func _notification(what):
	if what == NOTIFICATION_WM_FOCUS_OUT:
		focus_out()
	elif what == NOTIFICATION_WM_FOCUS_IN:
		focus_in()
	elif what == NOTIFICATION_WM_QUIT_REQUEST:
		save_project(projectSlot.get_child(0).projectName)

func focus_in():
	get_tree().paused = false
	if not is_project_open or projectSlot.get_child_count() == 0:
		return
	projectSlot.get_child(0).call("add_time_spent", stepify((OS.get_unix_time()-last_focus_time)/3600.0, 0.1))

func focus_out():
	last_focus_time = OS.get_unix_time()
	get_tree().paused = true
