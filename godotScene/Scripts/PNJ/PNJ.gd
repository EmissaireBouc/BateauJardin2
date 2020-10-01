extends AnimatedSprite

export var NomPersonnage = ""
#export var NumDial = 0

signal character_input

func _on_Area2D_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_pressed("ui_left_mouse"):
		emit_signal("character_input", NomPersonnage)

