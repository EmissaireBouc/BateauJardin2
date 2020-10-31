extends Control

onready var choix1 : Button = get_node("Zone/MarginContainer/HBoxContainer/Choix1")
onready var choix2 : Button = get_node("Zone/MarginContainer/HBoxContainer/Choix2")

signal choix_done

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
				$Zone/texte.add_image(get_resized_texture(t,32,32))
				$Zone/texte.add_text("  ")

		$Zone/Tween.interpolate_property(
			$Zone/texte, "percent_visible", 0, 1, 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
			)
		$Zone/Tween.start()

func chargement_dialog_choix(n, p, c1, c2):

	choix1.text = c1
	choix2.text = c2
	choix1.visible = true
	choix2.visible = true

	$Zone/indicateur.visible = false

	$Zone/nom.bbcode_text = n
	$Zone/texte.bbcode_text = p
#	$Zone/texte.percent_visible = 0
#	$Zone/Tween.interpolate_property(
#	$Zone/texte, "percent_visible", 0, 1, 1,
#		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
#		)
#	$Zone/Tween.start()



func _on_Tween_tween_completed(_object, _key):

		$Zone/indicateur.visible = true

func _on_indicateur_pressed():
	queue_free()




func get_resized_texture(t: Texture, width: int = 0, height: int = 0):
	var image = t.get_data()
	if width > 0 && height > 0:
		image.resize(width, height)
	var itex = ImageTexture.new()
	itex.create_from_image(image)
	return itex


func _on_Choix1_pressed():
	emit_signal("choix_done", choix1.text)
	queue_free()


func _on_Choix2_pressed():
	emit_signal("choix_done", choix2.text)
	queue_free()
