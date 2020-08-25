extends GridContainer


func _ready():
	make_equipage_menu()


func make_equipage_menu():
	for key in ImportData.equipage_data:
		var member = key + " " + ImportData.equipage_data[key].Prenom 
		create_button_graine(member)
			
func create_button_graine(member):
	var button = load ("res://Assets/UI/Carnet/ButtonGraineMenu.tscn").instance()
	add_child(button)
	button.text = member
