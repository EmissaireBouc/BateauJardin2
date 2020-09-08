extends HBoxContainer

signal button_pressed

var retourne

onready var equipage : GridContainer = get_node("PageGauche/VBoxContainer/CorpsTexte/GridContainer")
onready var graine : GridContainer = get_node("PageGauche/VBoxContainer/CorpsTexte2/GridContainer")

func _ready():
	make_equipage_menu()
	make_graine_menu()


func make_equipage_menu():
	for key in ImportData.equipage_data:
		var membre_id = key + " " + ImportData.equipage_data[key].Prenom 
		equipage.add_child(setup_button(membre_id))

func make_graine_menu():
	for key in ImportData.plant_data:
		if ImportData.plant_data[key].Available == 1:
			graine.add_child(setup_button(key))

func setup_button(m):
	var button = load ("res://Assets/UI/Carnet/ScButtonGraineMenu.tscn").instance()
	button.text = m
	button.connect("pressed", self, "_on_button_pressed", [button.text])
	return button


func _on_button_pressed(btnPressed):
	if ImportData.plant_data.has(btnPressed):
		retourne = "plante"
	else:
		retourne = "equipage"
		
	emit_signal("button_pressed", btnPressed, retourne)
	queue_free()
