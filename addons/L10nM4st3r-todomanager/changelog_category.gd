@tool extends ScrollContainer
func _ready():owner=get_node('../../../../')
func add_item():
	owner.category = true
	owner.add_to_menu = self
	owner.get_node("edit").popup_centered()
	owner.get_node("edit/t").text=''
	owner.get_node("edit/t").grab_focus()

func edit_title():
	owner.add_to_menu = self
	owner.get_node("edit_title").popup_centered()
	owner.get_node("edit_title/t").text=$item_list/p/h/title.text
	owner.get_node("edit_title/t").grab_focus()

func move_left():
	if get_index()==0:return
	var current=owner.CURRENT_CHANGELOG==get_index()
	get_parent().move_child(self,get_index()-1)
	var v=owner.changelog[get_index()]
	owner.changelog.remove_at(get_index()+1)
	owner.changelog.insert(get_index(),v)
	if current:owner.CURRENT_CHANGELOG=get_index()

func move_right():
	if get_parent().get_child_count() == get_index()+1:return
	var current=owner.CURRENT_CHANGELOG==get_index()
	get_parent().move_child(self,get_index()+1)
	var v=owner.changelog[get_index()]
	owner.changelog.remove_at(get_index())
	owner.changelog.insert(get_index(),v)
	if current:owner.CURRENT_CHANGELOG=get_index()
