@tool extends Panel
@onready var t:=$text
var included:=[]
var parent:Control
func _process(delta):
	var s=clamp(t.size.y+12,38,INF)
	if custom_minimum_size.y==s:set_process(false)
	else:custom_minimum_size.y=s
func delete():
	queue_free()
	included.remove_at(get_index())
	parent.save()
func edit():
	parent.category=false
	parent.add_to_menu=self
	parent.get_node("edit").popup_centered()
	parent.get_node("edit/t").text=t.text
	parent.get_node("edit/t").grab_focus()
func completed():
	$complete.hide()
	get_parent().remove_child(self)
	if parent.changelog and parent.changelog[-1].hash == hash(parent.current_date):
		parent.get_node('tabs/changelog/h').get_child(0).get_node('item_list/l').add_child(self)
	else:
		var n=parent.Category.instantiate()
		n.get_node('item_list/p/title').text=parent.current_date
		parent.get_node('tabs/changelog/h').add_child(n)
		n.get_node('item_list/l').add_child(self)
		parent.changelog.append({'title':parent.current_date,'hash':hash(parent.current_date),'content':[]})
	included.remove_at(get_index())
	included=parent.changelog[-1].content
	included.append(t.text)
	parent.save()
