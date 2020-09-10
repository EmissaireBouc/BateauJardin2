extends YSort

var NomPersonnage
var index_dialogueArray = 0
var NumDial = 0
var talking = false

onready var BoiteDialogue = get_parent().get_parent().get_parent().get_node("CanvasLayer/Dialogues/BoiteDialogue")
onready var Dialogues = get_parent().get_parent().get_parent().get_node("CanvasLayer/Dialogues")

signal Engage_Conversation



func _ready():
	connect_child_node()
	BoiteDialogue.connect("TexteSuivant", self, "AfficherNouvelleLigne")

func connect_child_node():
	for i in range (get_child_count()):
		get_child(i).connect("character_input", self, "on_Character_input")

func on_Character_input(n):
	if !talking:
		NomPersonnage = n
		emit_signal("Engage_Conversation")
		talking = true





func lancer_dialogue():
	BoiteDialogue.DialogueArray = ImportData.dialogue_data[str(ImportData.jour)][NomPersonnage]
	get_node("%s" %NomPersonnage).play("TALK")
	parle()

func parle():

	if index_dialogueArray < BoiteDialogue.DialogueArray.size()-1:
		" Pour afficher les noms: "
		if NumDial == 0:
			BoiteDialogue.NomPerso = ImportData.dialogue_data[str(ImportData.jour)][NomPersonnage].Dialogue1[index_dialogueArray].Nom
		else:
			BoiteDialogue.NomPerso = ImportData.dialogue_data[str(ImportData.jour)][NomPersonnage].Dialogue2[index_dialogueArray].Nom
		
		" Pour afficher les dialogues: "
		if NumDial == 0:
			BoiteDialogue.DialoguePerso = ImportData.dialogue_data[str(ImportData.jour)][NomPersonnage].Dialogue1[index_dialogueArray].Text
		else:
			BoiteDialogue.DialoguePerso = ImportData.dialogue_data[str(ImportData.jour)][NomPersonnage].Dialogue2[index_dialogueArray].Text

		index_dialogueArray +=1

		Dialogues.visible = true
		BoiteDialogue.chargement_dialog()

	else: # Ferme la scène Dialogue, réinitialise l'index, incrémente NumDial
		fin_dialogue()

func AfficherNouvelleLigne():
	parle()

func fin_dialogue():
	get_node("%s" %NomPersonnage).play("IDLE")
	talking = false
	Dialogues.visible = false
	index_dialogueArray = 0

	if NumDial == 0:
		NumDial += 1
	
