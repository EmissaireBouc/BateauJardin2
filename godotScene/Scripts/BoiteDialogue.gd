extends Control

var InformationsDial = String("")
var NomPerso = String("") 
var DialoguePerso = String("")
var DialogueArray = []

var index_dialogue = 0
var termine = false

func _ready():
	chargement_dialog()

func _process(delta):
	$"indicateur".visible = termine
	if Input.is_action_just_pressed("ui_accept"):
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

func _on_Tween_tween_completed(object, key):
		termine = true
