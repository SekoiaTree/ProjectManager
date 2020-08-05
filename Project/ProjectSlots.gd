extends PanelContainer

export (PackedScene) var slot

export (Texture) var right
export (Texture) var right_hover
export (Texture) var left
export (Texture) var left_hover

onready var tween = get_node("Tween")
onready var button = get_node("VBoxContainer/HBoxContainer/TextureButton")
onready var vbox = get_node("VBoxContainer")
onready var projectviewer = get_node("../..")

var projectNames := Array()

func _ready():
	pass # Replace with function body.

func add_project_slot(name : String):
	if projectNames.has(name): return
	var slotNode : Node = slot.instance()
	
	vbox.add_child(slotNode)
	slotNode.get_node("PanelContainer/Label").set("text", name)
	projectNames.append(name)
	slotNode.connect("clicked", self, "slot_pressed")
	focus_slot(name)

func _on_TextureButton_toggled(button_pressed):
	if button_pressed:
		tween.interpolate_property(self, "size_flags_stretch_ratio", null, 0, 0.1)
		button.texture_normal = left
		button.texture_pressed = left
		button.texture_hover = left_hover
	else:
		tween.interpolate_property(self, "size_flags_stretch_ratio", null, 0.5, 0.1)
		button.texture_normal = right
		button.texture_pressed = right
		button.texture_hover = right_hover
	
	tween.start()


func slot_pressed(slotName : String):
	focus_slot(slotName)
	projectviewer.switch_project(slotName)

func focus_slot(slotName : String):
	for child in vbox.get_children():
		if child.has_node("PanelContainer/Label"):
			if child.get_node("PanelContainer/Label").text != slotName: child.unfocus()
			else: child.focus()
