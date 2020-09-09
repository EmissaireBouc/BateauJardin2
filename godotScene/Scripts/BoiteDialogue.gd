extends Control

var InformationsDial = String("")
var NomPerso = String("oui")
var DialoguePerso = String("")
var DialogueArray = []

var index_dialogueArray = 0
var termine = false

func _ready():
	chargement_dialog()

func _process(_delta):
	$"indicateur".visible = termine
	if Input.is_action_pressed("ui_left_mouse"):
		chargement_dialog()
		
func chargement_dialog():
		termine = false
		$nom.bbcode_text = NomPerso
		$texte.bbcode_text = DialoguePerso
		$texte.percent_visible = 0
		$Tween.interpolate_property(
			$texte, "percent_visible", 0, 1, 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
			)
		$Tween.start()

func _on_Tween_tween_completed(_object, _key):
		termine = true
