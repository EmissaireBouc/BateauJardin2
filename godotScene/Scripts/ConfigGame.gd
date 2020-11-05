extends Control


func _ready():
	OS.center_window()
	OS.window_maximized = true
	var encart = load("res://Scenes/Systeme/Encart.tscn").instance()
	add_child(encart)
	encart.connect("encart_done", self, "encart_done")
	encart.connect("choix_done", self, "choix_done")
	encart.chargement_syst_info("Information", "Le jeu ne dispose pas de sauvegarde", "Ok", "")

func choix_done(c):
	$Encart.disconnect("encart_done", self, "encart_done")
	$Encart.disconnect("choix_done", self, "choix_done")
	$Encart.queue_free()
	$Node2D/Bateau/Node2D.play("Apparition")
	$Node2D/Bateau/BateauRotation.play("Boucle")
	$Node2D/Bateau/BateauY.play("Boucle")
	
