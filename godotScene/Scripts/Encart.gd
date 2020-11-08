extends Control

onready var choix1 : Button = get_node("Marge1/Marge2/Marge3/HBoxContainer/Choix1")
onready var choix2 : Button = get_node("Marge1/Marge2/Marge3/HBoxContainer/Choix2")
onready var txtNom : RichTextLabel = get_node("Marge1/Marge2/Marge2-1/MargeH1/MargeV1/nom")
onready var txtInfo : RichTextLabel = get_node("Marge1/Marge2/Marge2-1/MargeH1/MargeV1/texte")
onready var portrait : TextureRect = get_node("Marge1/Marge2/Marge2-1/MargeH1/Portrait")
onready var btnNext : TextureButton = get_node("Marge1/Marge2/indicateur")
onready var tween : Tween = get_node("Marge1/Marge2/Tween")

signal choix_done
signal encart_done

func _ready():
	choix1.visible = false
	choix2.visible = false
	pass

func set_pos(pos):
	if pos == "Middle":
		$Marge1.set_position(Vector2(0,(get_viewport().size.y/2) - ($Marge1.get_rect().size.y/2)))

		tween.interpolate_property(
			self, "rect_position:y", 0-$Marge1.get_rect().size.y, 0, 1.3,
			tween.TRANS_EXPO, tween.EASE_OUT
			)
		tween.start()

		tween.interpolate_property(
			self, "modulate", Color(1,1,1,0), Color(1,1,1,1), 1.3,
			tween.TRANS_EXPO, tween.EASE_OUT
			)
		tween.start()
		show()
		$AudioStreamPlayer.play()

	if pos == "Bottom":
		$Marge1.set_position(Vector2(0,(get_viewport().size.y) - ($Marge1.get_rect().size.y)))


func chargement_dialog(n, p):

	choix1.visible = false
	choix2.visible = false
	portrait.visible = true
	txtNom.visible = true

	set_pos("Bottom")
	animationTexte(n, p)

func chargement_syst_info(n, p, c1 = "", c2 = ""):
	
	
	choix1.visible = false
	choix2.visible = false
	
	btnNext.visible = false
	portrait.visible = false
	txtNom.visible = false

	if c1 != "":
		choix1.text = c1
		choix1.visible = true


	if c2 != "":
		choix2.text = c2
		choix2.visible = true

	txtInfo.bbcode_text = p

	set_pos("Middle")


func animationTexte(n, p):

	txtNom.bbcode_text = n
	txtInfo.bbcode_text = p

	show()

	txtInfo.percent_visible = 0

	tween.interpolate_property(
		txtInfo, "percent_visible", 0, 1, 1,
		tween.TRANS_LINEAR, tween.EASE_IN_OUT
		)
	tween.start()



func _on_Tween_tween_completed(_object, _key):
	if choix1.text == "":
		btnNext.visible = true


func _on_indicateur_pressed():
	emit_signal("encart_done")



func _on_Choix1_pressed():
	emit_signal("choix_done", choix1.text)
	choix1.text = ""
	choix2.text = ""

func _on_Choix2_pressed():
	emit_signal("choix_done", choix2.text)
	choix1.text = ""
	choix2.text = ""
