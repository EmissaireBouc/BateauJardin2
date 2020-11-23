extends AnimatedSprite

export var NomPersonnage = ""
var Dialogue = 0
var emplacement = ""
var Disparition = 0

signal character_input

func _on_Area2D_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_pressed("ui_left_mouse"):
		if !$Area2D/AnimationPlayer.is_playing():
			emit_signal("character_input", NomPersonnage, Dialogue, Disparition)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "disparition":
		$Area2D.emit_signal("mouse_exited")
		queue_free()


