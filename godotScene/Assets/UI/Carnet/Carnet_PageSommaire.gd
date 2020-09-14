extends HBoxContainer

signal button_pressed

onready var equipage : GridContainer = get_node("PageDroite/VBoxContainer/CorpsTexte/GridContainer")
onready var graine : GridContainer = get_node("PageGauche/VBoxContainer/CorpsTexte2/GridContainer")

func _ready():
	make_equipage_menu()
	make_graine_menu()


func make_equipage_menu():
	var i = 0.0
	for key in ImportData.equipage_data:
		i += 1
		var membre_id = key + " " + ImportData.equipage_data[key].Prenom 
		equipage.add_child(setup_button_equipage(membre_id, ceil(i/4)))
		

func make_graine_menu():
	var i = 0.0
	for key in ImportData.plant_data:
		if ImportData.plant_data[key].Available == 1:
			i += 1
			graine.add_child(setup_button_herbe(key, 2+ceil(i/6)))

func setup_button_herbe(m, p):
	var button = load ("res://Assets/UI/Carnet/ScButtonMenu.tscn").instance()
	button.text = m
	button.PageToLoad = p
	button.connect("pressed", self, "_on_button_pressed", [button.text, button.PageToLoad])
	return button
	
func setup_button_equipage(m, p):
	var button = load ("res://Assets/UI/Carnet/ScButtonMenuEquipage.tscn").instance()
	button.nomPersonnage = m
	button.PageToLoad = p
	button.connect("pressed", self, "_on_button_pressed", [button.nomPersonnage, button.PageToLoad])
	return button


func _on_button_pressed(btnPressed, numeroPage):
	emit_signal("button_pressed", numeroPage)
	queue_free()
