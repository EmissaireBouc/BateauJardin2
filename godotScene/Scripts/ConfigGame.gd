extends Control


func _ready():
	$Transition.animation("transition_out")
	ImportData.jour = 0

	var texture = Texture
	texture = load("res://Assets/UI/Curseur/curseur_default.png")
	Input.set_custom_mouse_cursor(texture)

func _on_Transition_transition_over(t):
	$Node2D/Bateau/Node2D.play("Apparition")
	$Node2D/Bateau/BateauRotation.play("Boucle")
	$Node2D/Bateau/BateauY.play("Boucle")

