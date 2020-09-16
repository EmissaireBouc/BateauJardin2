extends Control

#var InformationsDial = String("")
var NomPerso = String("Nom_Par_Defaut")
var DialoguePerso = String("Texte_Par_Defaut")
var DialogueArray = []
signal Texte_Suivant

#var index_dialogueArray = 0
var termine = false

func _ready():
	chargement_dialog()

#func _process(_delta):
#	$"indicateur".visible = termine
#	if Input.is_action_pressed("ui_left_mouse"):
#		chargement_dialog()
		
func chargement_dialog():
		$indicateur.visible = false
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
		$indicateur.visible = true


func _on_indicateur_pressed():
	emit_signal("Texte_Suivant")
