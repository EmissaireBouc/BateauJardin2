extends MarginContainer

export (int) var page
export (int) var nbElement
var Herbes = []
onready var membre : GridContainer = get_node("VBoxContainer/MarginContainer/Contenu")
signal BackToMenu


func setup():
	if page == 2 || page == 4 || page == 6 :
		$VBoxContainer/Titre.queue_free()

	DictionaryToArray()

	var key

	for i in range(0, nbElement):

		if i+(page*nbElement) < Herbes.size() :
			key = Herbes[i+(page*nbElement)]
			var nvHerbe = load ("res://Assets/UI/Carnet/ScHerbe.tscn").instance()
			$VBoxContainer/MarginContainer/Contenu.add_child(nvHerbe)
			nvHerbe.setup(ImportData.plant_data[key].Name,ImportData.plant_data[key].PV,ImportData.plant_data[key].XP,ImportData.plant_data[key].Description)
		else:
			break
#	$VBoxContainer.move_child(get_node("VBoxContainer/BasDePage"),$VBoxContainer.get_child_count())

func DictionaryToArray():
	for key in ImportData.plant_data:
		if ImportData.plant_data[key].Available == 1 :
			Herbes.push_back(key)




func _on_RetourAuMenu_pressed():
	emit_signal("BackToMenu")
