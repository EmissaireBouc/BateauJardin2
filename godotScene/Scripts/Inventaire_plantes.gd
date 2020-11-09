extends Control

var itemID

onready var itemlist : ItemList = get_node("AnimationPlayer/TextureRect/ItemList")
onready var illustration : Sprite = get_node("AnimationPlayer/TextureRect/Illustration")
onready var txtIllu : Label = get_node("AnimationPlayer/TextureRect/Label")
signal item_selected
signal plant_abort




func _ready():
	itemlist.setup_ItemList()
	
	

func open():
	if !visible:
#		itemlist.unselect_graine()
		visible = true
		$AnimationPlayer.play("Apparition")
		Add_Seeds(ImportData.jour)
		$AnimationPlayer/TextureRect/B_Valider.set_modulate(Color(0.8,0.8,0.8,1))

func Add_Seeds(jour):

#	Reinitialisation de la liste des graines

	itemlist.clear()

#	Itération dans plant_data pour peupler la liste

	for key in ImportData.plant_data :
		if  ImportData.plant_data[key].Available <= jour:
			itemlist.add_graine(key)

	

func close():
	$AnimationPlayer.play("Fermeture")



func is_open():
	if visible:
		return true
	else:
		return false

func is_item_selected():
	if itemlist.return_selected_item() == null:
		return false
	else:
		return true



func get_selected_item():
	for key in ImportData.plant_data :
		if ImportData.plant_data[key].Alias == itemlist.return_selected_item():
			return key



func _on_ItemList_item_selected(index):
	if itemID != index:
		itemlist.modulate_icon()
		$ClicGraine.play()
	var texture = load("res://Assets/UI/Carnet/Illustration/Plantes/%s" %"illu_" + get_selected_item() + ".png")
	illustration.texture = get_resized_texture(texture, 150,150) 
	illustration.visible = true
	txtIllu.text = ImportData.plant_data[get_selected_item()].Name
	txtIllu.visible = true
	itemID = index
	itemlist.set_item_icon_modulate(index, Color(1.1,1.1,1.1,1.1))
	$AnimationPlayer/TextureRect/B_Valider.set_modulate(Color(1,1,1,1))


func get_resized_texture(t: Texture, width: int = 0, height: int = 0):
	var image = t.get_data()
	if width > 0 && height > 0:
		image.resize(width, height)
	var itex = ImageTexture.new()
	itex.create_from_image(image)
	return itex

func _on_B_Valider_pressed():
	if is_item_selected():
		emit_signal("item_selected")
		close()
	else :
		pass

func _on_B_Annuler_pressed():
	emit_signal("plant_abort")
	close()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Fermeture":
		visible = false
		illustration.visible = false
		txtIllu.visible = false
