extends HBoxContainer

signal BackToMenu


func _on_RetourAuMenu_pressed():
	emit_signal("BackToMenu")
	queue_free()
