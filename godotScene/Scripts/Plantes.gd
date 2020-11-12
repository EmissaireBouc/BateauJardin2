extends YSort
var plantesArray = []
var currentPlantOutlined:String = ""
var plantSelected = false
var transparence = true
var transparenceArray = []

onready var mask_transparent: Area2D = get_parent().get_node("MasqueTransparent")
onready var tween: Tween = get_parent().get_node("Tween")

func _ready():
	for i in range(get_child_count()):
		get_child(i).connect("mouseOverlapped", self, "mouseOverlapped") 

func connect_child(nodeName):
	get_object(nodeName).connect("mouseOverlapped", self, "mouseOverlapped") 

func get_object(byName):
	for i in range(get_child_count()):
		if get_child(i).get_name() == byName :
			return(get_child(i))
			
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


func return_select_plant():
	return get_node(currentPlantOutlined)

func clear_Plant_Selected():

	plantSelected = false
	
	if self.has_node(currentPlantOutlined):
		get_object(currentPlantOutlined).set_material(get_object(currentPlantOutlined).shader_vent)

	plantesArray.erase(plantesArray[0])
	currentPlantOutlined = ""
	mask_transparent.global_position = Vector2(-6000,-900)
	
	
	if !plantesArray.empty():
		get_object(plantesArray[0]).set_material(preload("res://Assets/Mask/Outline.tres"))
		currentPlantOutlined = plantesArray[0]
		mask_transparent.global_position = get_node(plantesArray[0]).get_global_position()
		transparence_Off(get_node(plantesArray[0]))



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

#func transparence_Disabled():
#	for i in range(transparenceArray.size()):
#		transparence_Off(get_node(transparenceArray[i]))
#
#func transparence_Enabled():
#	for i in range(transparenceArray.size()):
#		transparence_On(get_node(transparenceArray[i]))
