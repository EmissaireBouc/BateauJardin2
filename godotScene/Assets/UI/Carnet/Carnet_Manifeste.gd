extends MarginContainer

export (int) var page
export (int) var nbElement
var Equipage = []
onready var membre : VBoxContainer = get_node("VBoxContainer")
signal BackToMenu

func _ready():
	DictionaryToArray()
	var key
	for i in Equipage.size():
		if membre.get_child_count() < nbElement :
			key = Equipage[i+((nbElement-2)*page)]
			var nvmembre = load ("res://Assets/UI/Carnet/ScMembreEquipage.tscn").instance()
			membre.add_child(nvmembre)
			nvmembre.setup(key, ImportData.equipage_data[key].Prenom,ImportData.equipage_data[key].Aka,ImportData.equipage_data[key].Genre,ImportData.equipage_data[key].Pronom,ImportData.equipage_data[key].Fonction,ImportData.equipage_data[key].Histoire)
			
		else:
			break
	membre.move_child(get_node("VBoxContainer/BasDePage"),nbElement)

func DictionaryToArray():
	for key in ImportData.equipage_data:
		Equipage.push_back(key)




func _on_RetourAuMenu_pressed():
	emit_signal("BackToMenu")
