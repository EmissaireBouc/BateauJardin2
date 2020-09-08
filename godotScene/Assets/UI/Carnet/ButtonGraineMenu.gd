extends Button


func _ready():
	$AnimationPlayer.play("apparition")
	
	
#	print(get_tree())
	


func _on_Button_tree_entered():
#	var carnet = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_node("Control")
#	print(get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_name())
#	print(get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_node("Control"))
#	self.connect("button_down",carnet,"_on_button_down")
	pass
	
#func _on_button_pressed():
#	print("pretty")
