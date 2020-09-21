extends MarginContainer

func setup(nom, PV, XP, Description):
	var pvText = get_node("PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/InformationHerbe/HBoxContainer/VBoxContainer/PV")
	var xpText = get_node("PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/InformationHerbe/HBoxContainer/VBoxContainer/XP")
	$PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/NomHerbe/HBoxContainer/Nom.text = nom
	$PanelContainer/VBoxContainer/DescriptionHerbe/Description.text = Description
	$PanelContainer/VBoxContainer/HBoxContainer/Illustration.texture = load("res://Assets/UI/Carnet/Illustration/Plantes/%s" %"illu_" + nom + ".png")
	if PV >= 0 && PV < 3 :
		pvText.text = "Arrosage : Important"
	if PV >= 3 && PV < 6 :
		pvText.text = "Arrosage : Régulier"
	if PV >= 6 :
		pvText.text = "Arrosage : Occasionnel"

	if XP >= 0 && XP < 3 :
		xpText.text = "Pousse : Rapide"
	if XP >= 3 && XP < 5 :
		xpText.text = "Pousse : Moyenne"
	if XP >= 5 :
		xpText.text = "Pousse : Lente"

	
	
