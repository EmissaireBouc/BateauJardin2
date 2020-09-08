extends Sprite

export var NomPersonnage = "Navigatrice"
export var NumDial = 0
#signal _on_Character_input

#func _on_Area2D_input_event(viewport, event, shape_idx):
#	if Input.is_action_pressed("ui_left_mouse"):
#		emit_signal("_on_Character_input")
