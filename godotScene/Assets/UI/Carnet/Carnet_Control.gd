extends Control

var page

func _ready():
	setup_sommaire()


func setup_manifeste():
	page = load ("res://Assets/UI/Carnet/ScPageEquipage.tscn").instance()
	add_child(page)
	page.connect("BackToMenu",self, "_on_BackToMenu_pressed")
	$Container.raise()

func setup_sommaire():
	page = load ("res://Assets/UI/Carnet/ScPageSommaire.tscn").instance()
	add_child(page)
	page.connect("button_pressed", self, "_on_button_pressed")
	$Container.raise()


func _on_button_pressed(element, nvllepage):
	if nvllepage == "equipage":
		setup_manifeste()
	else:
		pass


func _on_BackToMenu_pressed():
	setup_sommaire()


func _on_RetourMenu_pressed():
	page.queue_free()
	setup_sommaire()
