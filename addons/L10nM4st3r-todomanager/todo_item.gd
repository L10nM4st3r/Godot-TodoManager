@tool extends Panel
@onready var t:=$text
var included:=[]
func _process(delta):
	var s=clamp(t.size.y+12,38,INF)
	if custom_minimum_size.y==s:set_process(false)
	else:custom_minimum_size.y=s
func delete():
	owner.save()
	queue_free()
	included.remove_at(get_index())
func edit():
	owner.category=false
	owner.add_to_menu=self
	owner.get_node("edit").popup_centered()
	owner.get_node("edit/t").text=t.text
	owner.get_node("edit/t").grab_focus()

func completed():
	$complete.hide()
	# Move the node over
	var parent=owner
	get_parent().remove_child(self)
	
	if parent.changelog and parent.changelog[-1].hash == hash(parent.current_date):
		parent.changelog_list.get_child(parent.CURRENT_CHANGELOG).get_node('item_list/l').add_child(self)
	else:
		var n=parent.Category.instantiate()
		n.get_node('item_list/p/title').text=parent.current_date
		parent.changelog_list.add_child(n)
		n.get_node('item_list/l').add_child(self)
		# Move data
		parent.changelog.append({'title':parent.current_date,'hash':hash(parent.current_date),'content':[]})
	
	owner=parent
	included.remove_at(get_index())
	included=owner.changelog[-1].content
	# Change text to make it past tense
	var new_text=t.text.replace('Add','Added').replace('add','added').replace('Change','Changed').replace('change','changed').replace('Fix','Fixed').replace('fix','fixed')
	included.append(new_text)
	t.text=new_text
	owner.save()
