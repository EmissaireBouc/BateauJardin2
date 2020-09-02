extends Button

func _on_Jouer_pressed():
	get_tree().change_scene("res://Scenes/Systeme/Scene_Principale.tscn")
	


func _on_Options_pressed():
	get_tree().change_scene("res://Scenes/Options.tscn")
	


func _on_Quitter_pressed():
	get_tree().quit()
	
