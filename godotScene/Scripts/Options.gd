extends Control

onready var color_modif_mat = preload("res://Assets/UI/Options/couleur_options_mat.tres")

func _ready():
	$MarginContainer2/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/HSlider.value = ImportData.volume
	$MarginContainer2/MarginContainer/VBoxContainer/VBoxContainer/luminosite/HSlider.value = color_modif_mat.get_shader_param("brightness")
	$MarginContainer2/MarginContainer/VBoxContainer/VBoxContainer/contraste/HSlider.value = color_modif_mat.get_shader_param("contrast")
	$MarginContainer2/MarginContainer/VBoxContainer/VBoxContainer/saturation/HSlider.value = color_modif_mat.get_shader_param("saturation")
	$MarginContainer2/MarginContainer/VBoxContainer/VBoxContainer/teinte/HSlider.value = color_modif_mat.get_shader_param("hue_modif")
	
	$MarginContainer2/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer3/PleinEcran.pressed = OS.window_fullscreen


func _on_Retour_pressed():
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
	
		
