extends MarginContainer

export (int) var page
export (int) var nbElement
var Herbes = []
onready var membre : GridContainer = get_node("VBoxContainer/MarginContainer/Contenu")
signal BackToMenu


func setup():
	if page == 2 || page == 4 || page == 6 || page == 8 :
		$VBoxContainer/Titre.queue_free()

	DictionaryToArray()

	var key

	for i in range(0, nbElement):

		if i+(page*nbElement) < Herbes.size() :
			key = Herbes[i+(page*nbElement)]
			var nvHerbe = load ("res://Assets/UI/Carnet/Scene_Carnet/ScHerbe.tscn").instance()
			$VBoxContainer/MarginContainer/Contenu.add_child(nvHerbe)
			nvHerbe.setup(key, ImportData.plant_data[key].Name,ImportData.plant_data[key].PV,ImportData.plant_data[key].XP,ImportData.plant_data[key].Description)
		else:
			break

func DictionaryToArray():
	for key in ImportData.plant_data:
		if ImportData.plant_data[key].Available <= ImportData.jour :
			Herbes.push_back(key)




func _on_RetourAuMenu_pressed():
	emit_signal("BackToMenu")
