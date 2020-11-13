extends YSort
var plantesArray = []
var currentPlantOutlined:String = ""
var plantSelected = false
var transparence = true
var transparenceArray = []

var aGarden = []

onready var mask_transparent: Area2D = get_parent().get_node("MasqueTransparent")
onready var tween: Tween = get_parent().get_node("Tween")

signal debug
signal debug_plant_description

"""
	constructeur nouvelle plante
		reçoit en paramètre le nom, la position et les propriétés(pv,xp,lvl) de la plante à créer
"""

func add_new_plant(plante, POS, PV, XP, LVL):
	var plante_scene = load ("res://Assets/Plante/Scene/%s" %plante + ".tscn").instance()
	add_child(plante_scene)
	plante_scene.setup(POS, PV, XP, LVL)
	aGarden.push_front(plante_scene)
	
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
				get_node(currentPlantOutlined).set_material(get_node(currentPlantOutlined).shader_vent)

			plantesArray.push_front(plante)
			get_node(plante).set_material(preload("res://Assets/Mask/Outline.tres"))
			currentPlantOutlined = plante
			mask_transparent.global_position = get_node(plante).get_global_position()
	
	emit_signal("debug_plant_description", plante, get_node(plante).pv, get_node(plante).xp, get_node(plante).lvl )
	if fonction == "exited":

		if !plantSelected :

			if currentPlantOutlined == plante :
				get_node(plante).set_material(get_node(plante).shader_vent)
				currentPlantOutlined = ""

			
			plantesArray.erase(plante)

			if !plantesArray.empty():
				get_node(plantesArray[0]).set_material(preload("res://Assets/Mask/Outline.tres"))
				currentPlantOutlined = plantesArray[0]
				mask_transparent.global_position = get_node(plantesArray[0]).get_global_position()

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

func _on_MasqueTransparent_area_shape_exited(_area_id, area, _area_shape, _self_shape):


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
	for i in range(aGarden.size()):
		if aGarden[i] == get_node(plant):
			aGarden.remove(i)
			get_node("%s/AnimationPlayer" %plant).play("Disparition")
			break
#	print_garden()
	clear_Plant_Selected()



"""
	gestion evenement narratif
"""



func arrose_plrs_plantes(n = 0):
	aGarden.sort_custom(MyCustomSorter, "sort_ascending")
	for i in range(aGarden.size()):
		if aGarden[i].pv > 0 && n > 0:
			aGarden[i].hydrat()
			n -= 1

func kill_some_plants(n = 5):
	aGarden.sort_custom(MyCustomSorter, "sort_ascending")
	for i in range(aGarden.size()):
		if aGarden[i].pv > 0 && n > 0:
			aGarden[i].pv = 0
			aGarden[i].update_status()
			n -= 1



"""
	gestion mise a jour des plantes (un jour passe)
"""



func plante_PV_down():
	for i in range(aGarden.size()):
		aGarden[i].pv -= 1
		if aGarden[i].pv > 0 && aGarden[i].pv <= 3 :
			aGarden[i].deshydrat()
		
		if aGarden[i].pv <= 0:
			aGarden[i].fane()

func plante_XP_up():
	for i in range(aGarden.size()):
		if aGarden[i].pv > 0:
			aGarden[i].xp -= 1
		if aGarden[i].xp == 0:
			aGarden[i].LVL_up()


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
	for i in range(aGarden.size()):
		array += "\ni="+str(i)+" [" + str(aGarden[i].get_name()) + "] : " + aGarden[i].get_child(0).get_name()

	emit_signal("debug", "Jardin : " + str(aGarden.size()) + array)
