extends Node2D

var cursor = "default"
var posCursor
var aGarden = []
var cursorArray = []
export (int) var day = 0
var action

enum{IDLE, MOVE, PLANT, PLANT_BACK, OPEN_INV, SPRAY, CUT, TALK} # State
enum{DEFAULT, PLANTER, ENTRETENIR, ARROSER, COUPER, DORMIR, PARLER, CONVERS, CARNET, DEPLACER} # Action


onready var save_et_load = get_node("saveEtLoad")

onready var nav2D : Navigation2D = $Bateau/WalkArea # Navigation2D est un noeud qui permet le pathfinding depuis une aire de navigation (NavigationPolygon)
onready var Line2D : Line2D = $Bateau/YSort/Line2D # Line2D trace une ligne
onready var Player : AnimatedSprite = $Bateau/YSort/Player
onready var MouseA : Area2D = get_node("Bateau/YSort/gMouseCollider")
onready var menuEntretenir : MarginContainer = get_node("CanvasLayer/Control/MenuInteractions")
onready var Cam : Camera2D = get_node("Bateau/YSort/Player/Camera2D")
onready var PA : Label = get_node("CanvasLayer/PA")
onready var PNJsort : YSort = get_node("Bateau/YSort/PNJ")
onready var transitionJours = get_node("CanvasLayer/ciel transition/ciel")
onready var Plantes = get_node("Bateau/YSort/Plante")

var inventaire
var Encart 

"""
Initialisation du jeu
"""


func _ready():
	setup_game()
	
	if ImportData.is_loading :
		$saveEtLoad._load()

	chargement_jour()

func setup_game():
	$CanvasLayer/Transition.visible = true
	fondu("transition_out")

	cursor_mode("add","default")
	
	#	Création de l'inventaire

	var inv = load("res://Scenes/Systeme/Inventaire_plantes.tscn").instance()
	$CanvasLayer.add_child(inv)
	inventaire = get_node("CanvasLayer/Inventory")
	
	
#	Creation de l'encart

	var encart = load ("res://Scenes/Systeme/Encart.tscn").instance()
	$CanvasLayer.add_child(encart)
	Encart = get_node("CanvasLayer/Encart")
	Encart.hide()

	$Musique.play()

	connectique()

func connectique():
	PNJsort.connect("Engage_Conversation",self,"Engage_Conversation")
	Player.connect("Open_Carnet",self,"Open_Carnet")
	Player.connect("Change_Cursor", self, "cursor_mode")
	PNJsort.connect("Change_Cursor", self, "cursor_mode")
	inventaire.connect("item_selected", self, "_on_Inventory_item_selected")
	inventaire.connect("plant_abort", self, "_on_Inventory_plant_abort")
	Encart.connect("encart_done", self, "encart_done")
	Encart.connect("choix_done", self, "choix_done")

"""
Changement de jours
"""

func a_day_pass():
	day += 1

	if PNJsort.get_dialogue_done() >= PNJsort.get_child_count() && ImportData.jour < ImportData.get_last_day():
		ImportData.jour += 1
		chargement_jour()

	else:
		ImportData.DialJour = 0
		ImportData.ChangDial = 0
		PA.set_PA()

	
	$CanvasLayer/Transition.waitForClick = true
	Plantes.plante_XP_up()
	Plantes.plante_PV_down()

	save_et_load.save()

func chargement_jour(jr = ImportData.jour):

	change_action(DEFAULT)

	$CanvasLayer/Debug/DebugLabel4.text = "JOUR : " + str(ImportData.jour)
	ImportData.DialJour = 0
	ImportData.ChangDial = 0
	$Bateau/WalkArea.reboot()
	PNJsort.new_day()
	
	PA.set_PA()
	
	if jr == 0 :
		var tuto = load("res://Scenes/Systeme/Tuto.tscn").instance()
		$CanvasLayer.add_child(tuto)
		$CanvasLayer/Commande.connect("fin_tuto",self,"fin_tuto")
		$CanvasLayer/Transition.raise()

		Plantes.add_new_plant("HautArbuste",Vector2(-1920,-320),5,4,2)
		Plantes.add_new_plant("Myosotis",Vector2(-2112,-192),0,0,2)
		Plantes.add_new_plant("Fougere",Vector2(-1856,-192),2,2,1)
		Plantes.add_new_plant("OreillesDeLapin",Vector2(-1984,-64),4,2,1)

	if jr == 10:
			Plantes.kill_some_plants()
	
	if jr > 10:
			Plantes.arrose_plrs_plantes(10)

	day = 0


"""
Gestion du clic gauche :
	_unhandled_input(event) récupère l'input souris DANS la scène active 
	(distingue des inputs qui ont lieu dans le HUD)
	Gère le Clic gauche (par défaut : Marcher)
"""


func _unhandled_input(_event):
	if !Input.is_action_just_pressed("ui_left_mouse"):
		return
	else:
		match action :
			DEFAULT :
				if !menuEntretenir.is_open():
					if cursor == "default":
						change_action(DEPLACER)
						Player.change_state(MOVE)

				else:
					menuEntretenir.close()
					Plantes.clear_Plant_Selected()
#					MouseA.clear_aCollisionNode()
					
			DEPLACER :
				_on_Player_anim_over(MOVE)


"""
Gestion du clic droit :
	- Si une plante est en surbrillance (chevauchée par la souris) : ouvre le menu Entretenir
	- Si L'inventaire des graines n'est pas ouvert : ouvre le menu Graine
	- Sinon : fermeture du menu Graine et du menu Entretenir et retour sur le curseur par défaut
"""


func _input(_event):

	if !Input.is_action_just_pressed("ui_right_mouse"):
		return

	else:
		match action:
			DEFAULT, DEPLACER:
				if Plantes.currentPlantOutlined != "" && !menuEntretenir.is_open():
					if !Plantes.plantSelected:
						if PA.get_PA() > 0:
							Plantes.select_Plant()
							posCursor = get_node("Bateau/YSort/Plante/%s" %Plantes.currentPlantOutlined).get_global_position()
							menuEntretenir.open()
						else:
							_encart("Jade","La journée est finie, le soleil va se coucher. C'est le moment de rejoindre ma cabine.")


func _on_Jardin_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton && Input.is_action_pressed("ui_right_mouse") && Plantes.currentPlantOutlined == ""):
		if PA.get_PA() > 0: 
			match action:
				DEFAULT:
					change_action(PLANTER)
		else:
			_encart("Jade","La journée est finie, le soleil va se coucher. C'est le moment de rejoindre ma cabine.")



"""
Gestion du curseur :
	Fonctionne avec les signaux des areas2D. 
	Lorsque la souris sort ou entre de l'aire du PJ ou d'un PNJ, envoie un signal vers cursor_mode()
	avec en arguments "remove" si la souris sort d'une aire ou "add" si elle entre dans une aire

	
	!! les signaux sont paramétrés depuis la fonction connectique()
	Les différents curseurs : "parler" "dormir" "lire" "default"
"""


func cursor_mode(fonction, newMode):

	if fonction == "remove":
		cursorArray.erase(newMode)
	if fonction == "add":
		cursorArray.push_front(newMode)

	cursor = cursorArray[0]
	var texture = Texture
	texture = load("res://Assets/UI/Curseur/curseur_%s.png" %cursor)
	Input.set_custom_mouse_cursor(texture)


"""
Gestion des actions du joueur :
	- change_action change l'action en cours et le débute : La première action que le PJ doit effectuer
	se réalise ici. 
	- Dès qu'une animation se termine, un signal est émis vers _on_Player_anim_over(). En fonction de l'action en cours
	et de l'animation (state) terminée, l'action suivante se joue.
	- Lorsque la suite d'une action n'est pas conditionnée par la fin d'une animation du PJ mais par autre chose
	(fermerture d'un menu, pression d'un bouton etc.), se référer aux autres signaux présents dans cette section
"""



func Engage_Conversation(pos):
	match action :
		DEFAULT :
			if cursor == "parler":
				posCursor = Vector2(pos.x-400,pos.y)
				change_action(PARLER)
			else :
				PNJsort.talking = false
		_:
			PNJsort.talking = false

func change_action(newaction):
	action = newaction

	match action:
		DEFAULT:
			Player.change_state(IDLE)
		PLANTER:
			posCursor = get_global_mouse_position()
			Player.change_state(MOVE, Vector2(posCursor.x, posCursor.y-25))

		ARROSER:
			Player.change_state(MOVE, Vector2(posCursor.x, posCursor.y-25))
			menuEntretenir.close()

		COUPER:
			Player.change_state(MOVE, Vector2(posCursor.x, posCursor.y-25))
			menuEntretenir.close()
		DORMIR:
			posCursor = $Bateau/Porte.get_position()
			Player.change_state(MOVE, Vector2(posCursor.x + 100, posCursor.y))
		PARLER:
			Player.change_state(MOVE, Vector2(posCursor.x, posCursor.y))
		CONVERS:
			Player.change_state(IDLE)

func _on_Player_anim_over(state):
	match action:
		DEFAULT:
			match state :
				MOVE:
					Player.change_state(IDLE)
					change_action(DEFAULT)

		DEPLACER :
			match state :
				MOVE:
					Player.change_state(IDLE)
					change_action(DEFAULT)

		PLANTER:
			match state:
				MOVE : 
					inventaire.open()
					Player.change_state(OPEN_INV)
				PLANT:
					PA.PA_down(1)
					var Plante = inventaire.get_selected_item()
					Plantes.add_new_plant(Plante , posCursor + Vector2(0,30) , ImportData.plant_data[Plante].PV , ImportData.plant_data[Plante].XP , ImportData.plant_data[Plante].LVL)
					change_action(DEFAULT)
		ARROSER:
			match state:
				MOVE:
					Player.change_state(SPRAY)
				SPRAY:
					PA.PA_down(1)
					Plantes.plante_PV_up(Plantes.currentPlantOutlined)
					change_action(DEFAULT)
		COUPER:
			match state :
				MOVE:
					Player.change_state(CUT)
				CUT:
					PA.PA_down(1)
					Plantes.plante_Remove(Plantes.currentPlantOutlined)
					change_action(DEFAULT)
		DORMIR:
			match state :
				MOVE:
					fondu("transition_in")
					change_action(DEFAULT)
					
		PARLER:
			match state :
				MOVE:
					change_action(CONVERS)
					$Bateau/YSort/PNJ.lancer_dialogue()


func _on_Inventory_item_selected():
	match action:
		PLANTER:
			Player.change_state(PLANT)

func _on_Inventory_plant_abort():
	change_action(DEFAULT)


func _on_Button_Cut_pressed():
	if PA.get_PA() > 0 :
		change_action(COUPER)
	else:
		menuEntretenir.close()

func _on_Button_Spray_pressed():
	if PA.get_PA() > 0 :
		if Plantes.plantSelected:
			if Plantes.return_select_plant().pv > 0:
				change_action(ARROSER)
			else:
				_encart("Jade", "Cette plante est fanée, il n'y a rien à faire sinon l'arracher...")
				menuEntretenir.close()
				Plantes.clear_Plant_Selected()
	else:
		menuEntretenir.close()

func _on_PNJ_Fin_Conversation():

	change_action(DEFAULT)
	if ImportData.jour >= ImportData.get_last_day() && PNJsort.get_dialogue_done() == PNJsort.get_child_count():
		_info_systeme("fin", "[center]Ce message marque la fin du prototype de Bateau fol ! \n \n Vous pouvez toutefois continuer à embellir le jardin si vous le souhaitez. \n Merci d'avoir joué ![/center][right][img=<64>]res://Assets/UI/Logo/Logo_Gama_128x128.png[/img][/right]", ["Ok", "Quitter"])



"""
Gestion de l'action Dormir :
	Lors clic sur porte de la cabine : 
	Player marche vers la porte -> animation entre dans la cabine -> transition_in -> actualisation du bateau
	-> texte : Un_Jour_Passe -> transition_out -> animation sort de la cabine
"""



func _on_Porte_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton && Input.is_action_pressed("ui_left_mouse")):

		if ImportData.jour == 0 :

			if PNJsort.get_dialogue_done() != PNJsort.get_child_count():
				_encart("Jade", "Je n'ai pas encore parlé à tout le monde.")

			else:
				change_action(DORMIR)

		elif ImportData.jour >= 5 && ImportData.jour <= 9 :
			if PA.get_PA() <= 3:
				change_action(DORMIR)
			else:
				if ImportData.jour == 5:
					_encart("Jade", "J'ai presque rien fait aujourd’hui, je vais travailler encore un peu.")
				if ImportData.jour == 6:
					_encart("Jade", "Je vais continuer un peu, j'ai pas fait grand chose aujourd'hui.")
				if ImportData.jour == 7:
					_encart("Jade", "J'ai déjà raté une demi journée, je vais travailler encore un peu avant de me coucher.")
				if ImportData.jour == 8:
					_encart("Jade", "J'ai pas fait grand chose aujourd'hui, je vais continuer encore un peu.")
				if ImportData.jour == 9:
					_encart("Jade", "En ce moment je suis pas efficace, je peux pas finir ma journée comme ça.")
				change_action(DEFAULT)

		else : 

			if PNJsort.get_dialogue_done() != PNJsort.get_child_count() :
				_info_systeme("Jade", "Je n'ai pas parlé à tout le monde. Se coucher ?", ["Oui","Non"], "Bottom")
			else :
				_info_systeme("Jade", "Le jour est en train de tomber. Se coucher ?", ["Oui","Non"], "Bottom")

func _on_Porte_mouse_entered():
	cursor_mode("add","dormir")
	
func _on_Porte_mouse_exited():
	cursor_mode("remove","dormir")



"""
Gestion de la fonction Fondu
	deux animations à mettre en paramètre : 
		transition_in (fondu au noir)
		transition_out (ouverture).
	Lorsque le fondu est terminée, elle émet le signal 'on_Transition_transition_over' avec en paramètre 
	le nom de l'animation terminée + si c'est le fondu de début de transition de jour ou de fin
"""



func fondu(animName):
	$CanvasLayer/Transition/AnimationPlayer.play(animName)

func _on_Transition_transition_over(t):
	if t == "transition_in_debut":
		a_day_pass()
		transitionJours.start(ImportData.jour, day)
		$CanvasLayer/Transition.transitionCiel = true
		fondu("transition_out")
		
	if t == "transition_in_fin":
		transitionJours.stop()
		$CanvasLayer/Transition.transitionCiel = false
		fondu("transition_out")

	if t == "transition_out":
			start_new_day()

	if t == "transition_out_fin":
		$CanvasLayer/Transition.transitionCiel = false
		fondu("transition_in")

func start_new_day():

	var nbText = 0
	var phrase = "[center]De nouvelles graines sont à votre disposition :[/center]\n\n[center]"
	for key in ImportData.plant_data:
		if ImportData.plant_data[key].Available == ImportData.jour :
			nbText += 1
			var newPath = "[img=<48>]res://Assets/Plante/Icone/icon_%s.png[/img]" %key
			phrase +=  newPath
	if nbText != 0:
		_info_systeme("graines",phrase + "[/center]",["Ok"],"Middle")
	
	if ImportData.jour == 10: 
		_encart("Jade", "J'ai pas réussi à sortir de mon lit depuis deux jours... Il faut que j'aille m'excuser auprès de tout le monde.")



"""
Gestion du Carnet
"""



func Open_Carnet():
	match action : 
		DEFAULT :
			if !menuEntretenir.is_open():
				if cursor == "lire":
					var Carnet = load("res://Assets/UI/Carnet/Scene_Carnet/ScMenuLivre.tscn").instance()
					$CanvasLayer.add_child(Carnet)
					
					Carnet.connect("Close_Carnet", self, "Close_Carnet")
					change_action(CARNET)

func Close_Carnet():
	change_action(DEFAULT)



"""
gestion des encarts
"""



func _encart(nom, sentence):

	$CanvasLayer/Encart.chargement_dialog(nom, sentence)
	change_action(CONVERS)


func _info_systeme(titre, phrase, btn = [], pos = "Middle"):

	$CanvasLayer/Encart.chargement_syst_info(titre, phrase, btn, pos)
	change_action(CONVERS)

func fin_tuto():
	_encart("Jade", "Me voilà à bord du Bonny & Read... Je dois parler à la Capitaine.")
	fondu("transition_out")

func choix_done(c):
	$CanvasLayer/Encart.hide()
	change_action(DEFAULT)

	if c == "ok":
		if ImportData.jour == 7 :
			_encart("Jade", "J'ai pas réussi à me lever ce matin... Va falloir que je rattrape le temps perdu. Ça devrait aller !")
	if c == "Quitter":
		get_tree().change_scene("res://Scenes/Systeme/Ecran_Titre.tscn")
	if c == "Oui" :
		change_action(DORMIR)
	if c == "Non" :
		change_action(DEFAULT)


func encart_done():
	$CanvasLayer/Encart.hide()
	change_action(DEFAULT)


"""
Gestion des fonctions Debug
"""

func debug():
	$CanvasLayer/Debug/DebugLabel2.text = "Animation en cours : " + str(Player.state) + "\nAction en cours : " + str(action) + "\nZoom : x" + str(round(Cam.get_zoom().x*100)/100) + "\nJOUR : " + str(ImportData.jour) + "\nDAY : " + str(day)
func _process(_delta):
	if Input.is_action_just_pressed("Debug"):
		if !$CanvasLayer/Debug.visible:
			$CanvasLayer/Debug.visible = true
		else:
			$CanvasLayer/Debug.visible = false

	debug()
