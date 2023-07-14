@tool extends Control

@onready var todo_list :VBoxContainer= $tabs/todo/h
@onready var changelog_list :HBoxContainer= $tabs/changelog/h

const TodoItem:=preload("res://addons/todomenu/todo_item.tscn")
const Category:=preload("res://addons/todomenu/changelog_category.tscn")

var changelog:=[]
var todo:=[]
var add_to_menu:Control
var category:=false

@onready var current_date = get_current_date_title()

var CURRENT_CHANGELOG=0

func _ready():
	$tabs.set_tab_title(0,"ToDo List")
	$tabs.set_tab_title(1,"Changelog")
	
	todo=ProjectSettings.get_setting('addons/todo/todo',todo)
	changelog=ProjectSettings.get_setting('addons/todo/changelog',changelog)
	update_category(todo_list,todo)
	update_changelogs()


func save():
	ProjectSettings.set_setting('addons/todo/todo',todo)
	ProjectSettings.set_setting('addons/todo/changelog',changelog)
	ProjectSettings.save()


func update_changelogs():
	for i in changelog_list.get_children():i.queue_free()
	var remove =[]
	var index=0
	
	for i in changelog:
		index+=1
		if i.content.is_empty():
			remove.append(index)
			index-=1
		
		else:
			var cat = Category.instantiate()
			cat.get_node("item_list/p/h/title").text = i.title
			# If title matches tooltip, tooltip shows only the date
			cat.get_node("item_list/p").tooltip_text = (i.tooltip if i.title==i.tooltip else i.title+'\n\n'+i.tooltip)
			# Save the index as the current day (user can reindex categories)
			if i.hash==hash(current_date):CURRENT_CHANGELOG=index-1
			
			changelog_list.add_child(cat)
			update_category( cat.get_node("item_list/l"), i.content )
			changelog_list.move_child(cat,0)
			changelog_list.name = str(i.hash)
	for i in remove:changelog.remove_at(i-1)



func update_category(list_node:BoxContainer,data:Array):
	for i in list_node.get_children():i.queue_free()
	for i in data:
		var item = TodoItem.instantiate()
		if data==todo:item.get_node('complete').show()
		item.included=data
		item.get_node("text").text = i
		item.tooltip_text = i
		list_node.add_child(item)
		item.owner=self



func _on_add_todo():
	category=false
	if is_instance_valid(add_to_menu)and!add_to_menu.is_inside_tree():add_to_menu.queue_free()
	add_to_menu = todo_list
	$edit.popup_centered()
	$edit/t.text=''
	$edit/t.grab_focus()


func _on_add_changelog():
	category=true
	if add_to_menu and!add_to_menu.is_inside_tree():pass
	elif changelog and changelog[-1].hash==hash(current_date):add_to_menu = changelog_list.get_child(CURRENT_CHANGELOG)
	else:
		add_to_menu = Category.instantiate()
		add_to_menu.get_node("item_list/p/h/title").text = current_date
		add_to_menu.get_node("item_list/p").tooltip_text = current_date
		changelog_list.name = str(hash(current_date))
	$edit.popup_centered()
	$edit/t.text=''
	$edit/t.grab_focus()


func _on_edit_confirmed():if add_to_menu:
	if add_to_menu is Panel and'included'in add_to_menu:
		add_to_menu.t.text=$edit/t.text
		add_to_menu.set_process(true)
		add_to_menu.included[add_to_menu.get_index()]=$edit/t.text
		save()
		return
	
	if!add_to_menu.is_inside_tree():changelog_list.add_child(add_to_menu)
	var add = TodoItem.instantiate()
	add.get_child(0).text=$edit/t.text
	
	if category:
		# Add the item to the array
		if changelog and changelog[-1].hash==hash(current_date):
			changelog[add_to_menu.get_index()].content.append($edit/t.text)
		# Create new data, becuse it does not yet exist
		else:
			changelog.append({'title':current_date,'tooltip':current_date,'hash':hash(current_date),'content':[$edit/t.text]})
		add.included=changelog[-1].content
		add_to_menu.get_node("item_list/l").add_child(add)
	
	# Create a ToDo
	else:
		todo.append($edit/t.text)
		add.included=todo
		add.get_node('complete').show()
		add_to_menu.add_child(add)
	add.owner=self
	save()


func get_current_date_title():
	var t:=Time.get_date_dict_from_system()
	return['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][t.month-1] + " - " + str(t.day) +" "+['Mon','Tue','Wed','Thur','Fri','Sat','Sun'][t.weekday-1]+" "+ str(t.year)

func _on_edit_title_confirmed():
	if $edit_title/t.text.is_empty():
		var tooltip = changelog[add_to_menu.get_index()].tooltip
		changelog[add_to_menu.get_index()].title = tooltip
		add_to_menu.get_node("item_list/p/h/title").text = tooltip
		add_to_menu.get_node("item_list/p").tooltip_text = tooltip
	else:
		add_to_menu.get_node("item_list/p/h/title").text = $edit_title/t.text
		add_to_menu.get_node("item_list/p").tooltip_text = $edit_title/t.text+'\n\n'+changelog[add_to_menu.get_index()].tooltip
		changelog[add_to_menu.get_index()].title = $edit_title/t.text
	ProjectSettings.save()
