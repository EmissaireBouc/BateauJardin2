extends Sprite

var playerZone = false
var NomPersonnage
var NumDial 
var index_dialogueArray = 0

onready var BoiteDialogue = get_parent().get_parent().get_parent().get_node("CanvasLayer/Dialogues/BoiteDialogue")
onready var Dialogues = get_parent().get_parent().get_parent().get_node("CanvasLayer/Dialogues")

func _ready():
	get_node("Area2D").connect("body_entered",self,"on_body_entered")
	get_node("Area2D").connect("body_exited",self,"on_body_exited")
	"z_index = position.y"

""" Lorsque Player chevauche aire de collision de PNJ :
On instancie la variable DialogueArray de Boite de dialogue avec la valeur contenue dans dialogue_data(NomPersonnage) """

func on_body_entered(body):
	if body.name == "Player":
		playerZone = true
		BoiteDialogue.DialogueArray = ImportData.dialogue_data[str(ImportData.jour)]
		"print(ImportData.dialogue_data[str(ImportData.jour)][NomPersonnage].Dialogue1[index_dialogueArray].Nom)"
		"print(ImportData.dialogue_data[str(ImportData.jour)][NomPersonnage].Dialogue1[index_dialogueArray].Text)"
	if NumDial == 1:
		index_dialogueArray = 0

func on_body_exited(body):
	if body.name == "Player":
		playerZone = false
		Dialogues.visible = false
		BoiteDialogue.index_dialogueArray = 0
		
""" Lorsque Lea joueurse appuie sur Espace :
	-> parle()
		Si index_dialogue est inférieur à la taille du tableau de dialogue DialogueArray
		alors instancier la variable BoiteDialogue.Dialogue avec l'élément contenu dans le tableau à l'index index_dialogue
		index dialogue s'incrémente de 1 """
		
func _input(event):
	if event.is_action_pressed("ui_accept") && playerZone:
		parle()

func parle():
	if BoiteDialogue.index_dialogueArray <= BoiteDialogue.DialogueArray.size()-1:
		" Pour afficher les noms: "
		if NumDial == 0:
			BoiteDialogue.NomPerso = ImportData.dialogue_data[str(ImportData.jour)][NomPersonnage].Dialogue1[index_dialogueArray].Nom
		else:
			BoiteDialogue.DialoguePerso = ImportData.dialogue_data[str(ImportData.jour)][NomPersonnage].Dialogue2[index_dialogueArray].Text
		" Pour afficher les dialogues: "
		if NumDial == 0:
			BoiteDialogue.DialoguePerso = ImportData.dialogue_data[str(ImportData.jour)][NomPersonnage].Dialogue1[index_dialogueArray].Text
		else:
			BoiteDialogue.DialoguePerso = ImportData.dialogue_data[str(ImportData.jour)][NomPersonnage].Dialogue2[index_dialogueArray].Text
		BoiteDialogue.index_dialogueArray += 1
		index_dialogueArray +=1
		Dialogues.visible = true
	else:
		Dialogues.visible = false
		if NumDial == 0:
			NumDial += 1
