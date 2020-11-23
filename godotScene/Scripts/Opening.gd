extends Control


func _ready():
	OS.center_window()
	OS.window_maximized = true
	$Transition.animation("transition_out")
	$Gama.set_material(preload("res://Assets/Mask/InvertedColor.material"))



func _on_Transition_transition_over(t):
	if t == "transition_out" :
		$Timer.start(2)

	if t == "transition_in_debut" :
		$Transition.animation("transition_out")
		$Godot.visible = false
		$Gama.visible = true

	if t == "transition_in_fin" :
		get_tree().change_scene("res://Scenes/Systeme/Ecran_Titre.tscn")


func _on_Timer_timeout():
	$Transition.animation("transition_in")
