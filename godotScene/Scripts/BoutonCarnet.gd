extends TextureButton

onready var control = get_node("/root/ScenePrincipale")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Carnet_button_button_down():
	control.change_action(control.CARNET)
