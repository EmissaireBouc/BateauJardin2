extends Node2D

var default = load("res://Assets/UI/Curseur/curseur_default.png")
var planter = load("res://Assets/UI/Curseur/curseur_planter.png")
var lire = load("res://Assets/UI/Curseur/curseur_livre.png")
var parler = load("res://Assets/UI/Curseur/curseur_parler.png") 
var dormir = load("res://Assets/UI/Curseur/curseur_dormir.png")

var cursor = "default"
var posCursor
var action

#Tableau des plantes
var aGarden = []

export (int) var day = 0

enum{IDLE, MOVE, PLANT, PLANT_BACK, OPEN_INV, SPRAY, CUT, TALK} #Enum des différentes animations du Player
enum{DEFAULT, PLANTER, ENTRETENIR, ARROSER, COUPER, DORMIR, PARLER, CONVERS, CARNET, DEPLACER} #Enum des différentes actions du Player

onready var nav2D : Navigation2D = $Bateau/WalkArea # Navigation2D est un noeud qui permet le pathfinding depuis une aire de navigation (NavigationPolygon)
onready var Line2D : Line2D = $Bateau/YSort/Line2D # Line2D trace une ligne
onready var Player : AnimatedSprite = $Bateau/YSort/Player
onready var MouseA : Area2D = get_node("Bateau/YSort/gMouseCollider")
onready var menuInventaire : Control = get_node("CanvasLayer/Control/Inventory")
onready var menuEntretenir : MarginContainer = get_node("CanvasLayer/Control/MenuInteractions")
onready var Cam : Camera2D = get_node("Bateau/YSort/Player/Camera2D")
onready var PA : Label = get_node("CanvasLayer/PA")
onready var PNJsort : YSort = get_node("Bateau/YSort/PNJ")
onready var transitionJours = get_node("CanvasLayer/ciel transition/ciel")

"""
Initialisation du jeu
"""


func _ready():
	change_action(DEFAULT)
	fondu("transition_out")
	cursor_mode("default")
#	PA.set_PA(int(ImportData.PAJ[str(ImportData.jour)].PA))
	PA.set_PA(2)
	
	$CanvasLayer/Transition.visible = true
	$Musique.play()

	connectique()

	for i in range (0, $Bateau/YSort/Plante.get_child_count()) :
		aGarden.push_front($Bateau/YSort/Plante.get_child(i))
	print_garden() #Debug 

func connectique():
	PNJsort.connect("Engage_Conversation",self,"Engage_Conversation")
	Player.connect("Open_Carnet",self,"Open_Carnet")
	Player.connect("Change_Cursor", self, "cursor_mode")
	PNJsort.connect("Change_Cursor", self, "cursor_mode")
	PNJsort.connect("Nav2D_Update", self, "Nav_2D_Update")

func _process(_delta):
	debug()

func setup_nav2D_plant():
#	for i in range (aGarden.size()) :
#		Nav_2D_Update(aGarden[i].get_node("Area2D/CollisionPolygon2D").get_global_transform(),aGarden[i].get_node("Area2D/CollisionPolygon2D").get_polygon())
	pass

func Nav_2D_Update(t,p):
	$Bateau/WalkArea.update_navigation_polygon(t,p)



"""
Gestion du clic gauche :
	_unhandled_input(event) récupère l'input souris DANS la scène active 
	(distingue des inputs qui ont lieu dans le HUD)
	Gère le Clic gauche (par défaut : Marcher)
"""



func _unhandled_input(_event):
	if !Input.is_action_pressed("ui_left_mouse"):
		return

	if Input.is_action_pressed("ui_left_mouse"):
		match action :
			DEFAULT :
				if !menuEntretenir.is_open():
					if cursor == "default":
						change_action(DEPLACER)
						Player.change_state(MOVE)
						create_ui_destination(get_global_mouse_position(),"DESTINATION")
				else:
					menuEntretenir.close()
					MouseA.clear_aCollisionNode()
					destroy_ui_destination()



"""
Gestion du clic droit :
	- Si une plante est en surbrillance (chevauchée par la souris) : ouvre le menu Entretenir
	- Si L'inventaire des graines n'est pas ouvert : ouvre le menu Graine
	- Sinon : fermeture du menu Graine et du menu Entretenir et retour sur le curseur par défaut
"""



func _input(_event):

	if !Input.is_action_pressed("ui_right_mouse"):
		return

	if Input.is_action_pressed("ui_right_mouse"):
		match action:
			DEFAULT:
				if MouseA.overlapPlant :
					if PA.get_PA() > 0:
						posCursor = get_node("Bateau/YSort/Plante/%s" %MouseA.areaName).get_global_position()
						menuEntretenir.open()
					else:
						_encart("Jade","Je suis fatiguée maintenant, je dois me reposer")

			PLANTER:
				change_action(DEFAULT)
				menuInventaire.close()
				if MouseA.overlapPlant :
					posCursor = get_node("Bateau/YSort/Plante/%s" %MouseA.areaName).get_global_position()
					menuEntretenir.open()

func _on_Jardin_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton && Input.is_action_pressed("ui_right_mouse") && !MouseA.overlapPlant):
		if PA.get_PA() > 0: 
			match action:
				DEFAULT:
					change_action(PLANTER)
					create_ui_destination(get_global_mouse_position(),"PLANTATION")
		else:
			_encart("Jade","Je suis fatiguée maintenant, je dois me reposer")

func _encart(nom, sentence, dicTxt = {}):
	var encart = load ("res://Scenes/Systeme/Encart.tscn").instance()
	$CanvasLayer.add_child(encart)
	$CanvasLayer/Encart.chargement_dialog(nom, sentence, dicTxt)



"""
Gestion du curseur :
	Fonctionne avec les signaux des areas2D. 
	Lorsque la souris sort ou entre de l'aire du PJ ou d'un PNJ, envoie un signal vers cursor_mode()
	avec en argument le nouveau curseur à afficher
	
	!! les signaux sont paramétrés depuis la fonction connectique()
"""


func cursor_mode(newMode):

	cursor = newMode

	if (newMode == "default"):
		Input.set_custom_mouse_cursor(default)
		MouseA.visible = false

	if (newMode == "planter"):
		Input.set_custom_mouse_cursor(planter)

	if (newMode == "lire"):
		match action:
			DEFAULT :
				Input.set_custom_mouse_cursor(lire)

	if (newMode == "parler"):
		match action:
			DEFAULT :
				Input.set_custom_mouse_cursor(parler)

	if (newMode == "dormir"):
		match action:
			DEFAULT :
				Input.set_custom_mouse_cursor(dormir)


"""
Gestion des actions du joueur :
	- change_action change l'action en cours et le débute : La première action que le PJ doit effectuer
	se réalise ici. 
	- Dès qu'une animation se termine, un signal est émis vers _on_Player_anim_over(). En fonction de l'action en cours
	et de l'animation (state) terminée, l'action suivante se joue.
	- Lorsque la suite d'une action n'est pas conditionnée par la fin d'une animation du PJ mais par autre chose
	(fermerture d'un menu, pression d'un bouton etc.), se référer aux autres signaux présents dans cette section
"""



func Engage_Conversation():
	match action :
		DEFAULT :
			change_action(PARLER)

func change_action(newaction):
	action = newaction

	match action:
		DEFAULT:
			Player.change_state(IDLE)
		PLANTER:
			cursor_mode("planter")
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
			posCursor = get_global_mouse_position()
			Player.change_state(MOVE, Vector2(posCursor.x-400, posCursor.y))
		CONVERS:
			Player.change_state(IDLE)

func _on_Player_anim_over(state):
	match action:
		DEFAULT:
			match state :
				MOVE:
					Player.change_state(IDLE)
					change_action(DEFAULT)
					destroy_ui_destination()
		DEPLACER :
			match state :
				MOVE:
					Player.change_state(IDLE)
					change_action(DEFAULT)
					destroy_ui_destination()
		PLANTER:
			match state:
				MOVE : 
					menuInventaire.open()
					Player.change_state(OPEN_INV)
				PLANT:
					PA.PA_down(1)
					var planteName = menuInventaire.get_selected_item()
					var plante = load ("res://Assets/Plante/Scene/%s" %planteName + ".tscn").instance()
					$Bateau/YSort/Plante.add_child(plante)
					plante.setup(planteName)
					aGarden.push_front(plante)
					plante.position = posCursor + Vector2(0,30)
#					Nav_2D_Update(plante.get_node("Area2D/CollisionPolygon2D").get_global_transform(),plante.get_node("Area2D/CollisionPolygon2D").get_polygon())
					cursor_mode("default")
					print_garden() #debug
					change_action(DEFAULT)
		ARROSER:
			match state:
				MOVE:
					Player.change_state(SPRAY)
				SPRAY:
					PA.PA_down(1)
					plante_PV_up(MouseA.areaName)
					change_action(DEFAULT)
		COUPER:
			match state :
				MOVE:
					Player.change_state(CUT)
				CUT:
					PA.PA_down(1)
					plante_Remove(MouseA.areaName)
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
			destroy_ui_destination()
			menuInventaire.close()
			Player.change_state(PLANT)

func _on_Inventory_plant_abort():
	destroy_ui_destination()
	change_action(DEFAULT)

func _on_Button_Cut_pressed():
	if PA.get_PA() > 0 :
		change_action(COUPER)
	else:
		menuEntretenir.close()

func _on_Button_Spray_pressed():
	if PA.get_PA() > 0 :
		change_action(ARROSER)
	else:
		menuEntretenir.close()

func _on_PNJ_Fin_Conversation():
	change_action(DEFAULT)




"""
Gestion des actions Entretenir :
	plante_PV_up(plant) : Augmente les pv de 5 et coûte 1PA
	plante_Remove(plant) : Retire une plante du tableau (Manque l'animation de 
	destruction) et coûte 1PA
"""



func plante_PV_up(plant):
	get_node("Bateau/YSort/Plante/%s" %plant).hydrat()
	MouseA.clear_aCollisionNode()

func plante_Remove(plant):
	for i in range(aGarden.size()):
		if aGarden[i] == get_node("Bateau/YSort/Plante/%s" %plant):
			aGarden.remove(i)
			get_node("Bateau/YSort/Plante/%s" %plant).queue_free()
			break
	print_garden()
	MouseA.clear_aCollisionNode()




"""
Gestion de l'action Dormir :
	Lors clic sur porte de la cabine : 
	Player marche vers la porte -> animation entre dans la cabine -> transition_in -> actualisation du bateau
	-> texte : Un_Jour_Passe -> transition_out -> animation sort de la cabine
"""



func _on_Porte_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton && Input.is_action_pressed("ui_left_mouse")):
		if ImportData.jour >= 5 && ImportData.jour <= 9 :
			if PA.get_PA() == 0:
				change_action(DORMIR)
			else:
				_encart("Jade", "J'ai une montagne de choses à faire et l'énergie pour le faire... AU BOULOT !")
				change_action(DEFAULT)
		else : 
			change_action(DORMIR)

func _on_Porte_mouse_entered():
	cursor_mode("dormir")
	
func _on_Porte_mouse_exited():
	cursor_mode("default")

func a_day_pass():
	day += 1
	ImportData.jour += 1
	$Bateau/WalkArea.reboot()
	PNJsort.new_day()
	setup_nav2D_plant()
	PA.set_PA(int(ImportData.PAJ[str(ImportData.jour)].PA))
	#$CanvasLayer/Transition/Jour.text = "Jour "+str(day)
	#$CanvasLayer/Transition/Jour.visible = true
	$CanvasLayer/Transition.waitForClick = true
	plante_XP_up()
	plante_PV_down()
	
	
	if ImportData.jour == 10:
		arrose_plrs_plantes(5)

func arrose_plrs_plantes(n = 0):
	aGarden.sort_custom(MyCustomSorter, "sort_ascending")
	for i in range(aGarden.size()):
		if aGarden[i].pv > 0 && n > 0:
			aGarden[i].hydrat()
			n -= 1

func plante_PV_down():
	for i in range(aGarden.size()):
		aGarden[i].pv -= 1
		if aGarden[i].pv > 0 && aGarden[i].pv < 2 :
			aGarden[i].deshydrat()
		
		if aGarden[i].pv <= 0:
			aGarden[i].fane()

func plante_XP_up():
	for i in range(aGarden.size()):
		aGarden[i].xp -= 1
		if aGarden[i].xp == 0:
			aGarden[i].LVL_up()




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
		transitionJours.start(day)
		$CanvasLayer/Transition.transitionCiel = true
		fondu("transition_out")
		
	if t == "transition_in_fin":
		transitionJours.stop()
		$CanvasLayer/Transition.transitionCiel = false
		fondu("transition_out")
		
	if t == "transition_out":
		start_new_day()
		menuInventaire.Add_New_Seed(ImportData.jour)
		pass
		#$CanvasLayer/Transition/Jour.visible = false
		
	if t == "transition_out_fin":
		$CanvasLayer/Transition.transitionCiel = false
		fondu("transition_in")

func start_new_day():
	var nbText = 0
	var dicTexture = {}
	for key in ImportData.plant_data:
		if ImportData.plant_data[key].Available == ImportData.jour :
			nbText += 1
			dicTexture["key"+ str(nbText)] = "res://Assets/Plante/Icone/icon_%s.png" %key
	if !dicTexture.empty():
		_encart("", "De nouvelles graines sont à votre disposition :", dicTexture)



"""
gestion des feedbacks DESTINATION et PLANTER
"""



func create_ui_destination(pos, anim):
	if get_node_or_null("Bateau/YSort/UI_Destination") == null :
		var UI_Destination = load("res://Scenes/Objet/UI_Destination.tscn").instance()
		$Bateau/YSort.add_child(UI_Destination)
		get_node("Bateau/YSort/UI_Destination").play(anim)
		get_node("Bateau/YSort/UI_Destination").set_global_position(pos)
	else :
		get_node("Bateau/YSort/UI_Destination").set_global_position(pos)

func destroy_ui_destination():
	if get_node_or_null("Bateau/YSort/UI_Destination") != null :
		get_node("Bateau/YSort/UI_Destination").queue_free()




"""
Gestion du Carnet
"""




func Open_Carnet():
	match action : 
		DEFAULT :
			if !menuEntretenir.is_open():
				var Carnet = load("res://Assets/UI/Carnet/Scene_Carnet/ScMenuLivre.tscn").instance()
				$CanvasLayer.add_child(Carnet)
				Carnet.set_scale(Vector2(0.9,0.9))
				Carnet.connect("Close_Carnet", self, "Close_Carnet")
				change_action(CARNET)

func Close_Carnet():
	change_action(DEFAULT)



"""
Gestion des fonctions Debug
"""

func print_garden():
	var array = ""
	for i in range(aGarden.size()):
		array += "\ni="+str(i)+" [" + str(aGarden[i].get_name()) + "] : " + aGarden[i].get_child(0).get_name()

	$CanvasLayer/DebugLabel.text = "Jardin : " + str(aGarden.size()) + array


func debug():
	$CanvasLayer/DebugLabel2.text = "Animation en cours : " + str(Player.state) + "\nAction en cours : " + str(action) + "\nZoom : x" + str(round(Cam.get_zoom().x*100)/100)


class MyCustomSorter:
	static func sort_ascending(a, b):
		if a.pv < b.pv:
			return true
		return false
