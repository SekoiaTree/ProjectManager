extends Control

enum BUTTONS{
	DELETE,
	MOVE_DOWN,
	MOVE_UP,
}

onready var popup = get_node("PopupMenu")

func _input(event):
	if not (event is InputEventMouseButton) or not (event.button_index == BUTTON_RIGHT):
		return
	
	popup.popup(Rect2(event.global_position, Vector2(1,1)))


func _on_PopupMenu_index_pressed(index):
	var projects = get_tree().get_nodes_in_group("project")
	if not projects:
		print("ERROR: cannot find project.")
	var project = projects[0]
	match index:
		BUTTONS.DELETE:
			project.call("remove_object", get_parent())
