extends MarginContainer

func _ready():
	get_parent().get_parent().get_parent().get_node("Bateau/YSort/Plante").connect("debug",self,"print_garden")

func print_garden(strJardin):
	get_parent().get_node("DebugLabel").text = strJardin

func _on_CB_Graines_pressed():
	ImportData.All_Plant_Available()

func _on_CB_PA_pressed():
	get_parent().get_parent().get_node("PA").set_new_PA()

func _on_CB_DebugPannel_toggled(button_pressed):
	get_parent().get_node("DebugLabel").visible = button_pressed
	get_parent().get_node("DebugLabel2").visible = button_pressed
	get_parent().get_node("DebugLabel3").visible = button_pressed
	get_parent().get_parent().get_node("PA").visible = button_pressed


func _on_newPA_text_entered(new_text):
	get_parent().get_parent().get_node("PA").set_new_PA(int(new_text))

func _on_CB_Camera_toggled(button_pressed):
	get_parent().get_parent().get_parent().get_node("Bateau/YSort/Player/Camera2D").SquareX_Camera = button_pressed


func _on_LineEdit_text_entered(new_text):

	if int(new_text) <= ImportData.get_last_day() :
		ImportData.jour = int(new_text)
		get_parent().get_parent().get_parent().chargement_jour()

func _on_HSlider_value_changed(value):
	get_parent().get_parent().get_parent().get_node("Bateau/YSort/Player").speed = value

func _on_SpinBox_value_changed(value):
	for i in range(get_parent().get_parent().get_parent().get_node("Bateau/YSort/Plante").get_child_count()):
		get_parent().get_parent().get_parent().get_node("Bateau/YSort/Plante").get_child(i).set_lvl(value)

func _on_HSlider2_value_changed(value):
	get_parent().get_parent().get_parent().get_node("Bateau/YSort/Player/Camera2D").a = Vector2(value, value)



func _on_LoadDaySlow_text_entered(new_text):
	if int(new_text) <= ImportData.get_last_day() :
		ImportData.jour = int(new_text)
		get_parent().get_parent().get_parent().fondu("transition_in")
