extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Tween.interpolate_property(
			self, "modulate", Color(1,1,1,0), Color(1,1,1,1), 1.3,
			$Tween.TRANS_EXPO, $Tween.EASE_OUT
			)
	$Tween.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextureButton_pressed():
	queue_free()
