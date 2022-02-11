extends Node2D

onready var importData = ImportData

func _ready():
	if importData.fond_cache == true and self.visible :
		self.visible = false
		get_tree().set_group("Decor", "visible", false)
	if importData.fond_cache == false and !self.visible :
		self.visible = true
		get_tree().set_group("Decor", "visible", true)

func _process(delta):
	if importData.fond_cache == true and self.visible :
		self.visible = false
		get_tree().set_group("Decor", "visible", false)
	if importData.fond_cache == false and !self.visible :
		self.visible = true
		get_tree().set_group("Decor", "visible", true)
