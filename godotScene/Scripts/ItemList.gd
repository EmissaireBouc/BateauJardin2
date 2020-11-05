extends ItemList

export var iconModulate = Color(0.9,0.9,0.9,0.9)
"""
A l'ouverture de l'inventaire, itération dans le dictionnaire plant_data (importData.gd). Si une plante
est disponible (available), le bouton associé devient visible
"""

func setup_ItemList():
	modulate_icon()


func add_graine(plante):
	create_item(plante)
	modulate_icon()

func create_item(plante):
	var texture = load("res://Assets/Plante/Icone/%s" %"icon_"+ plante +".png")
	add_item(ImportData.plant_data[plante].Alias, texture)



func modulate_icon():
	for i in range(get_item_count()):
			if get_item_icon_modulate(i) != iconModulate:
				set_item_icon_modulate(i,iconModulate)


func return_selected_item():
	if is_anything_selected():
		var array = []
		array = get_selected_items()
		return get_item_text(array[0])
	else: 
		return

func unselect_graine():
	if is_anything_selected():
		unselect_all()
		modulate_icon()


