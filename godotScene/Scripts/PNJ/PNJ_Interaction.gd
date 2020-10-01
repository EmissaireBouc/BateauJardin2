extends YSort

var NomPersonnage
var index_dialogueArray = 0
var NumDial = 0
var talking = false


"""
A propos de Spot_PNJ :
	Spot_PNJ correspond aux 8 positions que les PNJ peuvent occuper. En l'état, c'est loin d'être une
	méthode efficiente. Elle est à retravailler. 
"""

export (Array) var  Spot_PNJ = [Vector2(-968,-608), Vector2(-392,-616), Vector2(860,-564), Vector2(1264,-80), Vector2(1376,608), Vector2(520,80), Vector2(-72,603), Vector2(-704,552)]
var Save_Spot_PNJ = []

onready var BoiteDialogue = get_parent().get_parent().get_parent().get_node("CanvasLayer/Dialogues/BoiteDialogue")
onready var Dialogues = get_parent().get_parent().get_parent().get_node("CanvasLayer/Dialogues")

signal Engage_Conversation
signal Change_Cursor
signal Nav2D_Update
signal Fin_Conversation




func _ready():
	Save_Spot_PNJ = Spot_PNJ.duplicate(true)
	initiate()
	BoiteDialogue.connect("Texte_Suivant", self, "Texte_Suivant")


func PNJ_Setup():
	var nbPNJ = ImportData.dialogue_data[str(ImportData.jour)].keys()
	for i in range(nbPNJ.size()):
		var nvPNJ = load ("res://Scenes/PNJ/%s" %nbPNJ[i] + ".tscn").instance() #Remplacer "Navigatrice" par : nbPNJ[i] lorsque toutes les scènes seront créées
		add_child(nvPNJ)
		nvPNJ.position = PNJ_Position(i, nbPNJ.size())
		var Nav2DCol =  nvPNJ.get_node("Area2D/Nav2DCol")
		emit_signal("Nav2D_Update",Nav2DCol.get_global_transform(), Nav2DCol.get_polygon())

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


func on_Character_input(n):
	if !talking:
		NomPersonnage = n
		emit_signal("Engage_Conversation")
		talking = true
		print(NumDial)

func Change_Cursor(newCursor):
	emit_signal("Change_Cursor",newCursor)

func lancer_dialogue():
	if NumDial == 0:
		BoiteDialogue.DialogueArray = ImportData.dialogue_data[str(ImportData.jour)][NomPersonnage].Dialogue1
	else:
		BoiteDialogue.DialogueArray = ImportData.dialogue_data[str(ImportData.jour)][NomPersonnage].Dialogue2
	get_node_character(NomPersonnage).play("TALK")
	parle()

func parle():

	"""
		Je pense comprendre d'où vient le bug des dialogues 
		En fait il y a plusieurs choses :
		À chaque fois que on clique sur le bouton "dialogue suivant", on lance le dialogue suivant, ça incrémente index_dialogueArray et ça finit par faire tout planter. ça, je crois que c'est réglé et push
		Les noms des PNJ étaient mal indiqués, c'est réglé aussi.
		Mais ce que je ne peux pas régler, c'est la ligne :
		
		```if index_dialogueArray <= BoiteDialogue.DialogueArray.size()-1: ```
		
		BoiteDialogue.DialogueArray est en fait égal au nombre de dialogues de la journée du personnage en clé + l'élément 'ID:0' présent dans toutes les clés. Son contenu est par exemple pour Suzanne : "Dialogue1", "Dialogue2", "Dialogue3" et "ID:0". Donc
		```BoiteDialogue.DialogueArray.size() = 4``` en ajoutant le -1 de l'index, ```BoiteDialogue.DialogueArray.size()-1 = 3```
		
		Vu que le nombre de ligne de dialogue du [dialogue1] de Suzanne est égale à 4 (0 ,1, 2 ,3), son dialogue fonctionne. Mais c'est un pur hasard. Pour les autres, c'est variable en fonction du nombre d'éléments qui composent le tableau. Des fois ça marche, des fois ça marche pas. 
		
		Pour régler ça, il faut évidemment que index_dialogueArray soit <= _au nombre de lignes de dialogue qui doivent être jouées pendant la conversation._
		Sachant que ce nombre varie en fonction que l'on soit sur le [dialogue1] ou sur le [dialogue2] (d'ailleurs Suzanne a trois dialogues ce qui ne devrait pas être le cas vu que le programme ne le permet pas) et bien c'est un vrai sac de nœud. 
	"""

	if index_dialogueArray <= BoiteDialogue.DialogueArray.size()-1:
		if NumDial == 0:
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
	talking = false
	Dialogues.visible = false
	index_dialogueArray = 0
	emit_signal("Fin_Conversation")

#	if NumDial == 0:
#		NumDial += 1


func get_node_character(n):
	for i in range(get_child_count()):
		if get_child(i).NomPersonnage == n :
			return(get_child(i))


"""
PNJ_Position définit une position aléatoire parmi 8 définie dans Spot_PNJ
Elle ne permet pour le moment pas de définir des regroupements de personnage
"""

func PNJ_Position(n, nb):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var alea = rng.randi()%Spot_PNJ.size()
	var pos_aleatoire = Spot_PNJ[alea]
	Spot_PNJ.remove(alea)
	
	if n == nb-1:
		Spot_PNJ = Save_Spot_PNJ.duplicate(true)

	return(pos_aleatoire)
