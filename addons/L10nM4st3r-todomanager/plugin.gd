@tool extends EditorPlugin

var menu:Control

func _enter_tree():
	if!ProjectSettings.has_setting('addons/todo/todo'):
		ProjectSettings.set_setting("addons/todo/todo",[])
		ProjectSettings.add_property_info({"name":"addons/todo/todo","type":TYPE_ARRAY})
		ProjectSettings.set_initial_value("addons/todo/todo",[])

	if!ProjectSettings.has_setting('addons/todo/changelog'):
		ProjectSettings.set_setting("addons/todo/changelog",[])
		ProjectSettings.add_property_info({"name":"addons/todo/changelog","type":TYPE_ARRAY})
		ProjectSettings.set_initial_value("addons/todo/changelog",[])
	ProjectSettings.save()

	menu=preload("res://addons/todomenu/menu.tscn").instantiate()
	add_control_to_bottom_panel(menu,"Todo")

func _exit_tree():
	remove_control_from_bottom_panel(menu)
	menu.queue_free()
