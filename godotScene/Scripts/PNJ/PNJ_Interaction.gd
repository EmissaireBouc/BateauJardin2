extends YSort

var NomPersonnage
var index_dialogueArray = 0
var NumDial = 0
var talking = false
var DisPNG = 0
var DialGroupe = 0
var DialGroupe2 = 0


"""
A propos de Spot_PNJ :
	Spot_PNJ correspond aux 8 positions que les PNJ peuvent occuper. En l'état, c'est loin d'être une
	méthode efficiente. Elle est à retravailler. 
"""

export (Array) var  Spot_PNJ = [["A1", Vector2(-3311,-465)],["A4", Vector2(-2946,514)],["B1", Vector2(-2105,-488)],["E1", Vector2(232,-787)],["E4", Vector2(-1364,465)],["F4", Vector2(-120,465)],["G3", Vector2(896,512)]]
var Lieu_PNJ = [["D1", Vector2(-704,-384), Vector2(-320,-768), Vector2(-896,-768)],["F2", Vector2(704,192), Vector2(1088,64), Vector2(704,-192)],["C3", Vector2(-1792,512), Vector2(-1344,384), Vector2(-1792,192)]]
var Save_Lieu_PNJ = []

onready var BoiteDialogue = get_parent().get_parent().get_parent().get_node("CanvasLayer/Dialogues/BoiteDialogue")
onready var Dialogues = get_parent().get_parent().get_parent().get_node("CanvasLayer/Dialogues")

signal Engage_Conversation
signal Change_Cursor
signal Nav2D_Update
signal Fin_Conversation




func _ready():
	Save_Lieu_PNJ = Lieu_PNJ.duplicate(true)
	initiate()
	BoiteDialogue.connect("Texte_Suivant", self, "Texte_Suivant")


"""
A chaque changement de jour : 
	- Les signaux entre les scènes PNJ et PNJSort sont déconnectés de façon à ne pas créer d'erreurs
	- Les scènes PNJ sont supprimées.
	- Les PNJ présents ce nouveau jour sont instanciés par initiate()
	- Les signaux sont reconnectés
"""

func new_day():
	disconnect_child_node()
	for i in range(get_child_count()):
		get_child(i).queue_free()
	initiate()

func initiate():
	PNJ_Setup()
	connect_child_node()

func connect_child_node():
	for i in range (get_child_count()):
		get_child(i).connect("character_input",self, "on_Character_input")
		get_child(i).get_node("Area2D").connect("mouse_entered", self, "Change_Cursor", ["parler"])
		get_child(i).get_node("Area2D").connect("mouse_exited", self, "Change_Cursor", ["default"])

func disconnect_child_node():
	for i in range (get_child_count()):
		get_child(i).disconnect("character_input", self, "on_Character_input")
		get_child(i).get_node("Area2D").disconnect("mouse_entered", self, "Change_Cursor")
		get_child(i).get_node("Area2D").disconnect("mouse_exited", self, "Change_Cursor")


func PNJ_Setup():

	# On récupère les personnages présents ce nouveau jour

	var nbPNJ = ImportData.dialogue_data[str(ImportData.jour)].keys()
	ImportData.nbrPNJ = nbPNJ.size()
	DialGroupe = 0
	

	for i in range(nbPNJ.size()):

		# Création du nouveau noeud PNJ

		var nvPNJ = load ("res://Scenes/PNJ/%s" %nbPNJ[i] + ".tscn").instance()
		add_child(nvPNJ)
		var jr = ImportData.PosPNJ[nbPNJ[i]].keys()
		var coord = ImportData.PosPNJ[nbPNJ[i]].values()
		nvPNJ.emplacement = coord[jr.find(str(ImportData.jour))]

		# Attribution des positions depuis les tableaux Spot_PNJ et Lieu_PNJ

		if nvPNJ.emplacement == "D1" || nvPNJ.emplacement == "F2" || nvPNJ.emplacement == "C3": # Si plusieurs PNJ discutent ensemble
			for j in range(Lieu_PNJ.size()):
				if str(Lieu_PNJ[j][0]) == nvPNJ.emplacement:
					nvPNJ.position = Lieu_PNJ[j][1]
					Lieu_PNJ[j].remove(1) # Retire la position assignée du pool de positions
		else: # Si PNJ seul
			for k in range (Spot_PNJ.size()):
				if str(Spot_PNJ[k][0]) == nvPNJ.emplacement:
					nvPNJ.position = Spot_PNJ[k][1]

		# Une fois les positions assignées : reinitialisation du tableau Lieu_PNJ pour le jour suivant

		if i == nbPNJ.size() - 1 :
			Lieu_PNJ = Save_Lieu_PNJ.duplicate(true)

		# Redécoupage de l'aire de marche en fonction de l'area2D du nouveau PNJ

		var Nav2DCol =  nvPNJ.get_node("Area2D/Nav2DCol")
		emit_signal("Nav2D_Update",Nav2DCol.get_global_transform(), Nav2DCol.get_polygon())
		

"""
Gestion des dialogues
"""

func on_Character_input(n, d, c):
	if !talking:
		NomPersonnage = n
		NumDial = d
		DisPNG = c
		talking = true
		emit_signal("Engage_Conversation", get_node_character(n).position)
		print("Numero du Dialogue: ", NumDial)
		print("Verification des Dialolgues en groupe: ",DialGroupe)

#Conversation de groupe

	if ImportData.jour == 0 && ImportData.PosPNJ[NomPersonnage]['0'] == "F2" && DialGroupe <= 1:
		DialGroupe += 1
	if ImportData.jour == 3 && ImportData.PosPNJ[NomPersonnage]['3'] == "D1" && DialGroupe <= 1:
		DialGroupe += 1
	if ImportData.jour == 5 && NomPersonnage == 'Mecanicienne' && DialGroupe <= 1:
		DialGroupe += 1
	if ImportData.jour == 7 && ImportData.PosPNJ[NomPersonnage]['7'] == "C3" && DialGroupe <= 1:
		DialGroupe += 1
	if ImportData.jour == 7 && NomPersonnage == 'Mecanicienne' && DialGroupe <= 1:
		DialGroupe += 1
	if ImportData.jour == 8 && ImportData.PosPNJ[NomPersonnage]['8'] == "C3" && DialGroupe <= 1:
		DialGroupe += 1
	if ImportData.jour == 11 && ImportData.PosPNJ[NomPersonnage]['13'] == "D1" && DialGroupe <= 1:
		DialGroupe += 1
	if ImportData.jour == 11 && ImportData.PosPNJ[NomPersonnage]['13'] == "C3" && DialGroupe2 <= 1:
		DialGroupe2 += 1
	

func lancer_dialogue():
	if ImportData.jour == 0 && ImportData.PosPNJ[NomPersonnage]['0'] == "F2" && DialGroupe == 2:
		NumDial = 1
	if ImportData.jour == 3 && ImportData.PosPNJ[NomPersonnage]['3'] == "D1" && DialGroupe == 2:
		NumDial = 1
	if ImportData.jour == 5 && NomPersonnage == 'Gabiere' && DialGroupe == 0:
		NumDial = 0
	if ImportData.jour == 5 && NomPersonnage == 'Gabiere' && DialGroupe == 1:
		NumDial = 1
		DialGroupe = 0
	if ImportData.jour == 7 && ImportData.PosPNJ[NomPersonnage]['7'] == "C3" && DialGroupe == 2:
		NumDial = 1
#	if ImportData.jour == 7 && NomPersonnage == 'Gabiere' && DialGroupe == 0:
#		NumDial = 0
	if ImportData.jour == 7 && NomPersonnage == 'Gabiere' && DialGroupe == 1:
		NumDial = 1
#		DialGroupe = 0
	if ImportData.jour == 8 && ImportData.PosPNJ[NomPersonnage]['8'] == "C3" && DialGroupe == 2:
		NumDial = 1
	if ImportData.jour == 11 && ImportData.PosPNJ[NomPersonnage]['13'] == "D1" && DialGroupe == 2:
		NumDial = 1
	if ImportData.jour == 11 && ImportData.PosPNJ[NomPersonnage]['13'] == "C3" && DialGroupe2 == 2:
		NumDial = 1
		
	if NumDial == 0:
		BoiteDialogue.DialogueArray = ImportData.dialogue_data[str(ImportData.jour)][NomPersonnage].Dialogue1
	else:
		BoiteDialogue.DialogueArray = ImportData.dialogue_data[str(ImportData.jour)][NomPersonnage].Dialogue2
		
#	if ImportData.jour == 5 && NomPersonnage == 'Gabiere' && NumDial == 2:
#		BoiteDialogue.DialogueArray = ImportData.dialogue_data[str(ImportData.jour)][NomPersonnage].Dialogue3
	
	get_node_character(NomPersonnage).play("TALK")
	
	parle()
	print(NomPersonnage)

func parle():
		
	if index_dialogueArray <= BoiteDialogue.DialogueArray.size()-1:
		if  NumDial == 0:
			BoiteDialogue.NomPerso = ImportData.dialogue_data[str(ImportData.jour)][NomPersonnage].Dialogue1[index_dialogueArray].Nom
			BoiteDialogue.DialoguePerso = ImportData.dialogue_data[str(ImportData.jour)][NomPersonnage].Dialogue1[index_dialogueArray].Text
		else:
			BoiteDialogue.NomPerso = ImportData.dialogue_data[str(ImportData.jour)][NomPersonnage].Dialogue2[index_dialogueArray].Nom
			BoiteDialogue.DialoguePerso = ImportData.dialogue_data[str(ImportData.jour)][NomPersonnage].Dialogue2[index_dialogueArray].Text
		
		index_dialogueArray +=1

		Dialogues.visible = true
		BoiteDialogue.chargement_dialog()
		

	else: # Ferme la scène Dialogue, réinitialise l'index, incrémente NumDial
		fin_dialogue()

func Texte_Suivant():
	parle()

func fin_dialogue():
	get_node_character(NomPersonnage).play("IDLE")
	check_group(NomPersonnage)
	get_node_character(NomPersonnage).Dialogue = 1
	get_node_character(NomPersonnage).Disparition += 1
	talking = false
	Dialogues.visible = false
	index_dialogueArray = 0
	emit_signal("Fin_Conversation")
		
	if NumDial == 0:
		ImportData.DialJour += 1
	disparitionPNG()

func check_group(n):
	
	for i in range (get_child_count()):
		if get_child(i).emplacement == get_node_character(n).emplacement:
			get_child(i).Dialogue = 1

func disparitionPNG():
	if ImportData.jour == 3 && NomPersonnage == 'Mecanicienne' && get_node_character(NomPersonnage).Disparition == 1:
		get_node_character(NomPersonnage).get_node("Area2D/AnimationPlayer").play('disparition')
	
	if ImportData.jour == 3 && NomPersonnage == 'Cartographe' && get_node_character(NomPersonnage).Disparition >= 1:
		get_node_character(NomPersonnage).get_node("Area2D/AnimationPlayer").play('disparition3')
	
	if ImportData.jour == 5 && NomPersonnage == 'Mecanicienne' && get_node_character(NomPersonnage).Disparition == 1:
		get_node_character(NomPersonnage).get_node("Area2D/AnimationPlayer").play('disparition')
	
	if ImportData.jour == 7 && NomPersonnage == 'Mecanicienne' && get_node_character(NomPersonnage).Disparition == 1:
		get_node_character(NomPersonnage).get_node("Area2D/AnimationPlayer").play('disparition')
	
	if ImportData.jour == 7 && NomPersonnage == 'Gabiere' && get_node_character(NomPersonnage).Disparition == 2:
		get_node_character(NomPersonnage).get_node("Area2D/AnimationPlayer").play('disparition')
	
	if ImportData.jour == 7 && NomPersonnage == 'Vigie' && get_node_character(NomPersonnage).Disparition == 1:
		get_node_character(NomPersonnage).get_node("Area2D/AnimationPlayer").play('disparition')

func get_node_character(n):
	for i in range(get_child_count()):
		if get_child(i).NomPersonnage == n :
			return(get_child(i))

func Change_Cursor(newCursor):
	emit_signal("Change_Cursor",newCursor)

func get_dialogue_done():
	var nb = 0
	for i in range(get_child_count()):
		nb += get_child(i).Dialogue
	return(nb)
