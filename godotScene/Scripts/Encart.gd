extends Control

onready var bouttons : HBoxContainer = get_node("Marge1/Marge2/Marge3/HBoxContainer")

onready var txtNom : RichTextLabel = get_node("Marge1/Marge2/Marge2-1/MargeH1/MargeV1/nom")
onready var txtInfo : RichTextLabel = get_node("Marge1/Marge2/Marge2-1/MargeH1/MargeV1/texte")
onready var portrait : TextureRect = get_node("Marge1/Marge2/Marge2-1/MargeH1/Portrait")
onready var btnNext : TextureButton = get_node("Marge1/Marge2/indicateur")
onready var tween : Tween = get_node("Marge1/Marge2/Tween")

signal choix_done
signal encart_done

func _ready():
	pass

func chargement_dialog(n, p):

	portrait.visible = false
	txtNom.visible = false
	txtInfo.bbcode_text = p

	set_pos("Bottom")
	animationTexte()
	show_portrait(n)



func chargement_syst_info(n, p, btn = [], var pos:String = "Middle"):
	
	btnNext.visible = false
	portrait.visible = false
	txtNom.visible = false

	for i in range(btn.size()):
		var nvBouton = load("res://Scenes/btn_Encart.tscn").instance()
		bouttons.add_child(nvBouton)
		nvBouton.text = btn[i]
		nvBouton.connect("pressed", self, "_on_Choix1_pressed", [nvBouton.text])

	txtInfo.bbcode_text = p

	set_pos(pos)

	if n == "Jade":
		show_portrait(n)

func show_portrait(n):
	portrait.visible = true
	txtNom.visible = true
	txtNom.text = n
	animationTexte()

func set_pos(pos):
	
	if pos == "Middle":
#		set_position(Vector2(0,(get_viewport().size.y/2) - (get_rect().size.y/2)))

		tween.interpolate_property(
			self, "rect_position:y", get_viewport().size.y/3-get_rect().size.y, (get_viewport().size.y/2) - (get_rect().size.y/2), 1.7,
			tween.TRANS_EXPO, tween.EASE_OUT
			)
		tween.start()

		tween.interpolate_property(
			self, "modulate", Color(1,1,1,0), Color(1,1,1,1), 1.7,
			tween.TRANS_SINE, tween.EASE_OUT
			)
		tween.start()
		$AudioStreamPlayer.play()

	if pos == "Bottom":
		set_position(Vector2(0,(get_viewport().size.y) - (get_rect().size.y)))

	show()




func animationTexte():

	txtInfo.percent_visible = 0

	tween.interpolate_property(
		txtInfo, "percent_visible", 0, 1, 1,
		tween.TRANS_LINEAR, tween.EASE_IN_OUT
		)
	tween.start()



func _on_Tween_tween_completed(_object, _key):
	if bouttons.get_child_count() == 0:
		btnNext.visible = true


func _on_indicateur_pressed():
	emit_signal("encart_done")


func _on_Choix1_pressed(t):
	emit_signal("choix_done", t)
	for i in range(bouttons.get_child_count()):
		bouttons.get_child(i).queue_free()
