extends Control


func _ready():
	$Transition.animation("transition_out")
	ImportData.jour = 0

func choix_done(c):
	$Encart.disconnect("encart_done", self, "encart_done")
	$Encart.disconnect("choix_done", self, "choix_done")
	$Encart.queue_free()
	$Node2D/Bateau/Node2D.play("Apparition")
	$Node2D/Bateau/BateauRotation.play("Boucle")
	$Node2D/Bateau/BateauY.play("Boucle")

func encart():
	var encart = load("res://Scenes/Systeme/Encart.tscn").instance()
	add_child(encart)
	encart.connect("encart_done", self, "encart_done")
	encart.connect("choix_done", self, "choix_done")
	encart.chargement_syst_info("Information", "[center]Bienvenue sur la démo du Bateau Fol ! \n\n Quelques bugs embusqués peuvent encore surgir... \n [color=#ffffff]Le jeu sauvegarde au début de chaque nouvelle journée[/color][/center][right][img=<64>]res://Assets/UI/Logo/Logo_Gama_128x128.png[/img][/right]", ["Ok"])

func _on_Transition_transition_over(t):
	encart()

