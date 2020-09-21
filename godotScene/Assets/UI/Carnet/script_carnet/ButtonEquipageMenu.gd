extends TextureButton

var PageToLoad
var nomPersonnage
var nom


func _ready():
	self.texture_normal = load("res://Assets/UI/Carnet/Illustration/Equipage/%s" %"illu_" + nom + ".png")
	$Label.text = nomPersonnage
