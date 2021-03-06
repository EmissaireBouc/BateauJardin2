extends YSort
var plantesArray = []
var currentPlantOutlined:String = ""
var plantSelected = false

onready var mask_transparent: Area2D = get_parent().get_node("MasqueTransparent")
onready var tween: Tween = get_parent().get_node("Tween")

signal debug
signal debug_plant_description

"""
	constructeur nouvelle plante
		reçoit en paramètre nom, position, propriétés(pv,xp,lvl)
"""

func add_new_plant(plante, POS, PV, XP, LVL):
	var plante_scene = load ("res://Assets/Plante/Scene/%s" %plante + ".tscn").instance()
	add_child(plante_scene)
	plante_scene.setup(POS, PV, XP, LVL)

#	Fonction debug
	print_garden()

"""
	gestion surlignage et selection
"""

func mouseOverlapped(fonction, plante):

	if fonction == "entered":

		if plantSelected :

			if currentPlantOutlined != plante:
				plantesArray.push_back(plante)

		else:

			if currentPlantOutlined != "":
				if get_node_or_null(currentPlantOutlined) != null :
					get_node(currentPlantOutlined).set_material(get_node(currentPlantOutlined).shader_vent)
					transparence_On(get_node(currentPlantOutlined))
				else :
					print("null_1")

			plantesArray.push_front(plante)
			get_node(plante).set_material(preload("res://Assets/Mask/Outline.tres"))
			currentPlantOutlined = plante
			transparence_Off(get_node(plante))
			mask_transparent.global_position = get_node(plante).get_global_position()
	
	emit_signal("debug_plant_description", plante, get_node(plante).pv, get_node(plante).xp, get_node(plante).lvl )
	if fonction == "exited":

		if !plantSelected :

			if currentPlantOutlined == plante :
				get_node(plante).set_material(get_node(plante).shader_vent)
				currentPlantOutlined = ""

			
			plantesArray.erase(plante)

			if !plantesArray.empty() :
				if get_node_or_null(plantesArray[0]) != null:
					get_node(plantesArray[0]).set_material(preload("res://Assets/Mask/Outline.tres"))
					currentPlantOutlined = plantesArray[0]
					mask_transparent.global_position = get_node(plantesArray[0]).get_global_position()
				else : 
					plantesArray.erase(plantesArray[0])
					print("null_2")

			else:
				mask_transparent.global_position = Vector2(-6000,-900)
		else :
			if currentPlantOutlined != plante:
				plantesArray.erase(plante)

func select_Plant():
	plantSelected = true

func clear_Plant_Selected():

	plantSelected = false
	
	if self.has_node(currentPlantOutlined):
		get_node(currentPlantOutlined).set_material(get_node(currentPlantOutlined).shader_vent)

	plantesArray.erase(plantesArray[0])
	currentPlantOutlined = ""
	mask_transparent.global_position = Vector2(-6000,-900)
	
	
	if !plantesArray.empty():
		if get_node_or_null(plantesArray[0]) != null:
			get_node(plantesArray[0]).set_material(preload("res://Assets/Mask/Outline.tres"))
			currentPlantOutlined = plantesArray[0]
			mask_transparent.global_position = get_node(plantesArray[0]).get_global_position()
			transparence_Off(get_node(plantesArray[0]))


"""
	gestion de la transparence
"""

func _on_Area2D_area_shape_entered(_area_id, area, _area_shape, _self_shape):

	if area.get_parent().get_name() != currentPlantOutlined:
		transparence_On(area.get_parent())

	elif area.get_parent().modulate != Color(1,1,1,1):
		transparence_Off(area.get_parent())

func _on_MasqueTransparent_area_shape_exited(_area_id, area, _area_shape, _self_shape):

	if area != null:
		if area.get_parent().modulate != Color(1,1,1,1):
			transparence_Off(area.get_parent())

func transparence_On(plante):
	
	tween.interpolate_property(
			plante, "modulate", Color(1,1,1,1), Color(1,1,1,0.1), 0.7,
			tween.TRANS_LINEAR, tween.EASE_IN_OUT
			)
	tween.start()

func transparence_Off(plante):

	tween.interpolate_property(
			plante, "modulate", plante.modulate, Color(1,1,1,1), 0.7,
			tween.TRANS_LINEAR, tween.EASE_IN_OUT
			)
	tween.start()


"""
	gestion menu ENTRETENIR
"""



func plante_PV_up(plant):
	get_node(plant).hydrat()
	clear_Plant_Selected()

func plante_Remove(plant):
	get_node("%s/AnimationPlayer" %plant).play("Disparition")
	get_node("%s/Area2D" %plant).queue_free()

#	print_garden()
	clear_Plant_Selected()



"""
	gestion evenement narratif
"""



func arrose_plrs_plantes(n = 5):
	var aGarden = get_children()
	aGarden.sort_custom(MyCustomSorter, "sort_ascending")
	for i in range(aGarden.size()):
		if aGarden[i].pv > 0 && n > 0:
			aGarden[i].hydrat()
			n -= 1

func kill_some_plants(n = 10):
	var aGarden = get_children()
	aGarden.sort_custom(MyCustomSorter, "sort_ascending")
	for i in range(aGarden.size()):
		if aGarden[i].pv > 0 && n > 0:
			aGarden[i].pv = -10
			aGarden[i].update_status()
			n -= 1



"""
	gestion mise a jour des plantes (un jour passe)
"""



func plante_PV_down():
	for i in range(get_child_count()):
		get_child(i).pv -= 1
		if get_child(i).pv > 0 && get_child(i).pv <= 3 :
			get_child(i).deshydrat()
		
		if get_child(i).pv <= 0:
			get_child(i).fane()

func plante_XP_up():
	for i in range(get_child_count()):
		if get_child(i).pv > 0:
			get_child(i).xp -= 1
		if get_child(i).xp == 0:
			get_child(i).LVL_up()


"""
	get/set
"""

func return_select_plant():
	return get_node(currentPlantOutlined)

class MyCustomSorter:
	static func sort_ascending(a, b):
		if a.pv < b.pv:
			return true
		return false

"""
	DEBUG
"""

func print_garden():
	var array = ""
	for i in range(get_child_count()):
		array += "\ni="+str(i)+" [" + str(get_child(i).get_name()) + "] : " + get_child(i).get_child(0).get_name()

	emit_signal("debug", "Jardin : " + str(get_child_count()) + array)
