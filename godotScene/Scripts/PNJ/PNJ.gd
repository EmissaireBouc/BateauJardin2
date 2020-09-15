extends AnimatedSprite

export var NomPersonnage = ""
export var NumDial = 0

signal character_input
signal Change_Cursor

func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("ui_left_mouse"):
		emit_signal("character_input", NomPersonnage)


func _on_Area2D_mouse_entered():
	emit_signal("Change_Cursor", "parler")


func _on_Area2D_mouse_exited():
	emit_signal("Change_Cursor", "default")
