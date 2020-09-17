extends Control

var numeroPage = 0
var page
signal Close_Carnet

func _ready():
	setup_sommaire()
	$OuvertureCarnet.play()

func _on_button_pressed(n):
	numeroPage = n
	load_page()

func _on_BackToMenu_pressed():
	setup_sommaire()
	$FermetureCarnet.play()


func _on_RetourMenu_pressed():
	numeroPage = 0
	load_page()

func _on_PageSuivante_pressed():
	if numeroPage < 6 :
		$PageTourne.play()
		numeroPage += 1
		load_page()

func _on_PagePrecedente_pressed():
	if numeroPage > 0:
		$PageTourne.play()
		numeroPage -= 1
		load_page()

func _on_Croix_pressed():
	$AnimationPlayer.play("Disparition")
	$FermetureCarnet.play()
	

func load_page():
	
	page.queue_free()
	if numeroPage == 0 :
		$Container/PagePrecedente.visible = false
	else :
		$Container/PagePrecedente.visible = true
	
	if numeroPage == 6 :
		$Container/PageSuivante.visible = false
	else :
		$Container/PageSuivante.visible = true
	
	if numeroPage == 0 :
		setup_sommaire()
	if numeroPage == 1 :
		setup_manifeste(0,1)
	if numeroPage == 2 : 
		setup_manifeste(2,3)
	if numeroPage == 3 : 
		setup_herbier(0,1)
	if numeroPage == 4 : 
		setup_herbier(2,3)
	if numeroPage == 5 : 
		setup_herbier(4,5)
	if numeroPage == 6 : 
		setup_herbier(6,7)


func setup_herbier(p1,p2):
	page = load ("res://Assets/UI/Carnet/Scene_Carnet/ScPageEquipage2.tscn").instance()
	page.setup_pages(p1,p2)
	add_child(page)
	$Container.raise()

func setup_manifeste(p1,p2):
	page = load ("res://Assets/UI/Carnet/Scene_Carnet/ScPageEquipage.tscn").instance()
	add_child(page)
	page.setup_pages(p1,p2)
	$Container.raise()

func setup_sommaire():
	page = load ("res://Assets/UI/Carnet/Scene_Carnet/ScPageSommaire.tscn").instance()
	add_child(page)
	page.connect("button_pressed", self, "_on_button_pressed")
	$Container.raise()


func _on_FermetureCarnet_finished():
	emit_signal("Close_Carnet")
	queue_free()
