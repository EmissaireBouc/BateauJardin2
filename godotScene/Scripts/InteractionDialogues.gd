extends Sprite

var talking = false
var NomPersonnage
var NumDial
var index_dialogueArray = 0
signal _on_Character_input

onready var BoiteDialogue = get_parent().get_parent().get_parent().get_parent().get_node("CanvasLayer/Dialogues/BoiteDialogue")
onready var Dialogues = get_parent().get_parent().get_parent().get_parent().get_node("CanvasLayer/Dialogues")

#func _ready():
#
#	get_node("Area2D").connect("input_event",self,"character_event")
#	BoiteDialogue.connect("TexteSuivant", self, "AfficherNouvelleLigne")


""" 
Lorsque Player chevauche aire de collision de PNJ :
	On instancie la variable DialogueArray de Boite de dialogue avec la valeur contenue dans dialogue_data(NomPersonnage) 
"""

func character_event(_event, _viewport, _shape_idx):
	if Input.is_action_pressed("ui_left_mouse") && !talking:
		emit_signal("_on_Character_input")
		talking = true

#func on_body_entered(body):
#	if body.name == "Player":
#
#		"print(ImportData.dialogue_data[str(ImportData.jour)][NomPersonnage].Dialogue1[index_dialogueArray].Nom)"
#		"print(ImportData.dialogue_data[str(ImportData.jour)][NomPersonnage].Dialogue1[index_dialogueArray].Text)"


#func on_body_exited(body):
#	if body.name == "Player":
#		playerZone = false
#		Dialogues.visible = false
#		BoiteDialogue.index_dialogueArray = 0
		
""" 
Lorsque Lea joueurse appuie sur Espace :
	-> parle()
		Si index_dialogue est inférieur à la taille du tableau de dialogue DialogueArray
		alors instancier la variable BoiteDialogue.Dialogue avec l'élément contenu dans le tableau à l'index index_dialogue
		index dialogue s'incrémente de 1 
"""

func lancer_dialogue():
	BoiteDialogue.DialogueArray = ImportData.dialogue_data[str(ImportData.jour)][NomPersonnage]
	parle()

func AfficherNouvelleLigne():
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
		talking = false
		Dialogues.visible = false
		index_dialogueArray = 0
		if NumDial == 0:
			NumDial += 1
