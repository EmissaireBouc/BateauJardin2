extends Control


func _ready():
	$Tween.interpolate_property(
			self, "modulate", Color(1,1,1,0), Color(1,1,1,1), 1.3,
			$Tween.TRANS_EXPO, $Tween.EASE_OUT
			)
	$Tween.start()


func _on_TextureButton_pressed():
	queue_free()
