extends Button

func _on_Jouer_pressed():
	get_tree().change_scene("res://Scenes/Systeme/Scene_Principale.tscn")
	pass # Replace with function body.


#func _on_Options_pressed():
#	get_tree().change_scene("res://Scenes/Systeme/Options.tscn")
#	pass # Replace with function body.

func _on_Quitter_pressed():
	get_tree().quit()
	
func _on_Option_pressed():
		var Option_scene = load("res://Scenes/Systeme/Options.tscn").instance()
		get_parent().get_parent().get_parent().get_parent().add_child(Option_scene)


func _on_Credits_pressed():
	var Credits_scene = load("res://Scenes/Systeme/Credits.tscn").instance()
	get_parent().get_parent().get_parent().get_parent().add_child(Credits_scene)
