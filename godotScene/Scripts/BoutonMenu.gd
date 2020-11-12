extends Button

onready var menu = get_node("/root/Control/MarginContainer/VBoxContainer/Menu")
onready var menu2 = get_node("/root/Control/MarginContainer/VBoxContainer/Menu2")

func _on_Jouer_pressed():
	menu.visible = false
	menu2.visible = true
	var i = 1
	while i <= 3 :
		var file = File.new()
		if file.open("res://saves/saved_game_"+String(i)+".sav",File.READ) != 0:
			print("error opening file")
			return
		var line_data = parse_json(file.get_line())
		if line_data.has("fichier vide") :
			get_node("../../Menu2/nouvellePartie"+String(i)).visible = true
			get_node("../../Menu2/VBoxContainer"+String(i)).visible = false
		else :
			get_node("../../Menu2/nouvellePartie"+String(i)).visible = false
			get_node("../../Menu2/VBoxContainer"+String(i)).visible = true
		i += 1
	#get_tree().change_scene("res://Scenes/Systeme/Scene_Principale.tscn")

func _on_nouvellePartie_pressed(var num_sauvegarde = 0):
	ImportData.is_loading = false
	ImportData.fichier_sauvegarde = num_sauvegarde
	get_tree().change_scene("res://Scenes/Systeme/Scene_Principale.tscn")

func _on_charger_pressed(var num_sauvegarde = 0):
	ImportData.is_loading = true
	ImportData.fichier_sauvegarde = num_sauvegarde
	get_tree().change_scene("res://Scenes/Systeme/Scene_Principale.tscn")

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


func _on_retour_pressed():
	menu.visible = true
	menu2.visible = false


func _on_Effacer_pressed(var num_sauvegarde = 0):
	var file = File.new()
	if file.open("res://saves/saved_game_"+String(num_sauvegarde)+".sav",File.WRITE) != 0:
		print("error opening file")
		return
	var data = {"fichier vide" : "vide" }
	file.store_line(to_json(data))
	file.close()
	get_node("../../VBoxContainer"+String(num_sauvegarde)).visible = false
	get_node("../../nouvellePartie"+String(num_sauvegarde)).visible = true
