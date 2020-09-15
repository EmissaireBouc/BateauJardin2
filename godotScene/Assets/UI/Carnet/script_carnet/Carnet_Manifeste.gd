extends MarginContainer

export (int) var page
export (int) var nbElement
var Equipage = []
onready var membre : GridContainer = get_node("VBoxContainer/MarginContainer/Contenu")
signal BackToMenu

func setup():

	if page == 2:
		$VBoxContainer/Titre.queue_free()

	DictionaryToArray()
	var key
	for i in range(0,nbElement):
		if i < Equipage.size() :
			key = Equipage[i+(page*nbElement)]
			var nvmembre = load ("res://Assets/UI/Carnet/Scene_Carnet/ScMembreEquipage.tscn").instance()
			membre.add_child(nvmembre)
			nvmembre.setup(key, ImportData.equipage_data[key].Prenom,ImportData.equipage_data[key].Aka,ImportData.equipage_data[key].Genre,ImportData.equipage_data[key].Pronom,ImportData.equipage_data[key].Fonction,ImportData.equipage_data[key].Histoire)
			
		else:
			break
#	membre.move_child(get_node("VBoxContainer/BasDePage"),membre.get_child_count())

func DictionaryToArray():
	for key in ImportData.equipage_data:
		Equipage.push_back(key)




func _on_RetourAuMenu_pressed():
	emit_signal("BackToMenu")
