extends Control

#var Nom = String("Nom_Par_Defaut")
#var sentenceToPlay = String("Texte_Par_Defaut")


#func init(n, p, dicTxt = {}):
#	Nom = n
#	sentenceToPlay = p
#	chargement_dialog(dicTxt)
	
		
func chargement_dialog(n, p, dicTxt = {}):
		$Zone/indicateur.visible = false

		$Zone/nom.bbcode_text = n
		$Zone/texte.bbcode_text = p
		$Zone/texte.percent_visible = 0

		if !dicTxt.empty():
			$Zone/texte.newline()
			$Zone/texte.newline()
			$Zone/texte.push_align(1)
			for key in dicTxt :
				var t = Texture
				t = load(dicTxt[key])
				$Zone/texte.add_image(t)
				$Zone/texte.add_text("  ")

		$Zone/Tween.interpolate_property(
			$Zone/texte, "percent_visible", 0, 1, 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
			)
		$Zone/Tween.start()

func _on_Tween_tween_completed(_object, _key):

		$Zone/indicateur.visible = true


func _on_indicateur_pressed():
	queue_free()
