extends Control

onready var cacheFond = $"MarginContainer2/MarginContainer/VBoxContainer/VBoxContainer/Cahce Fond/Checkbox"
onready var color_modif_mat = preload("res://Assets/UI/Options/couleur_options_mat.tres")
var a_reactiver = null

var importData = ImportData

func _ready():
	$MarginContainer2/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/HSlider.value = ImportData.volume
	_update_position_sliders()
	$MarginContainer2/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer3/PleinEcran.pressed = OS.window_fullscreen
	if importData.fond_cache == false :
		cacheFond.pressed = false
	if importData.fond_cache == true :
		cacheFond.pressed = true

func _on_Retour_pressed():
	if(a_reactiver != null):
		a_reactiver.visible = true
		a_reactiver = null
	queue_free()



func _on_PleinEcran_toggled(button_pressed):
	OS.window_fullscreen = button_pressed
	OS.center_window()



func _on_OptionButton_item_selected(id):
	if id == 0 :
		OS.window_size = Vector2(1920,1080)
		
	if id == 1 :
		OS.window_size = Vector2(1680,1050)
	if id == 2 :
		OS.window_size = Vector2(1280,1024)
	OS.center_window()



func _on_HSlider_value_changed(value):
	ImportData.volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), log(ImportData.volume)*20)
	
func _contrast_slider(value):
	color_modif_mat.set_shader_param("contrast",value)

func _luminosite_slider(value):
	color_modif_mat.set_shader_param("brightness",value)
	
func _saturation_slider(value):
	color_modif_mat.set_shader_param("saturation",value)
	
func _hue_slider(value):
	color_modif_mat.set_shader_param("hue_modif",value)

func _reinitialiser_couleurs():
	color_modif_mat.set_shader_param("contrast",1)
	color_modif_mat.set_shader_param("brightness",0)
	color_modif_mat.set_shader_param("saturation",1)
	color_modif_mat.set_shader_param("hue_modif",0)
	_update_position_sliders()

func _update_position_sliders():
	$MarginContainer2/MarginContainer/VBoxContainer/VBoxContainer/luminosite/HSlider.value = color_modif_mat.get_shader_param("brightness")
	$MarginContainer2/MarginContainer/VBoxContainer/VBoxContainer/contraste/HSlider.value = color_modif_mat.get_shader_param("contrast")
	$MarginContainer2/MarginContainer/VBoxContainer/VBoxContainer/saturation/HSlider.value = color_modif_mat.get_shader_param("saturation")
	$MarginContainer2/MarginContainer/VBoxContainer/VBoxContainer/teinte/HSlider.value = color_modif_mat.get_shader_param("hue_modif")

#Cache Fond#
func _on_Checkbox_toggled(button_pressed):
	if cacheFond.pressed == true :
		importData.fond_cache = true
		color_modif_mat.set_shader_param("saturation",3)
		_update_position_sliders()
	if cacheFond.pressed == false :
		importData.fond_cache = false
		_reinitialiser_couleurs()
