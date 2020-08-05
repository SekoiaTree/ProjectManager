extends PopupMenu

export (NodePath) var projectDialog
export (NodePath) var fileDialog

onready var projectmenu = get_node(projectDialog)
onready var fileMenu = get_node(fileDialog)

enum BUTTONS {
	NEW_PROJ,
	OPEN_PROJ,
}

func _on_PopupMenu_index_pressed(index):
	match index:
		BUTTONS.NEW_PROJ:
			projectmenu.popup_centered_clamped(Vector2(100, 100))
		BUTTONS.OPEN_PROJ:
			fileMenu.popup_centered()
