extends Control

var page = 1
signal fin_tuto

func _ready():
	set_scale(Vector2(0.9,0.9))

func _on_PagePrecedente_pressed():
	if page > 1:
		page -= 1
		update()


func _on_PageSuivante_button_down():
	if page < 3:
		page += 1
		update()


func _on_Quitter_pressed():
	if ImportData.jour == 0:
		emit_signal("fin_tuto")
	queue_free()

func update():
	$MarginContainer/NumeroPage.text = str(page) + "/3"

	if page == 3:
		$CenterContainer/Page1.visible = false
		$CenterContainer/Page2.visible = false
		$CenterContainer/Page3.visible = true
		$MarginContainer3.visible = false
	else :
		$MarginContainer3.visible = true
	
	if page == 2:
		$MarginContainer4.visible = false
		$CenterContainer/Page1.visible = false
		$CenterContainer/Page2.visible = true
		$CenterContainer/Page3.visible = false
	
	if page == 1:
		$CenterContainer/Page1.visible = true
		$CenterContainer/Page2.visible = false
		$CenterContainer/Page3.visible = false
		$MarginContainer4.visible = false
	else :
		$MarginContainer4.visible = true
