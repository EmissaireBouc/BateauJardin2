extends GridContainer



func _ready():
	make_graine_menu()


func make_graine_menu():
	for key in ImportData.plant_data:
		if ImportData.plant_data[key].Available == 1:
			create_button_graine(key)
			
func create_button_graine(graine_name):
	var button = load ("res://Assets/UI/Carnet/ButtonGraineMenu.tscn").instance()
	add_child(button)
	button.text = graine_name
	
