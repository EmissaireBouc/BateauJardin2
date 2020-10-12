extends MarginContainer

func setup(nom, prenom, aka, pronom, fonction, histoire):
	$PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/NomPersonnage/HBoxContainer/Nom.text = setup_nom(nom, prenom, aka)
	$PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/InformationPersonnage/HBoxContainer/Pronom.text = pronom.capitalize()+ " / "
	$PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/InformationPersonnage/HBoxContainer/Fonction.text = fonction
	$PanelContainer/VBoxContainer/HistoirePersonnage/Description.text = histoire
	$PanelContainer/VBoxContainer/HBoxContainer/PanelContainer/Illustration.texture = load("res://Assets/UI/Carnet/Illustration/Equipage/%s" %"illu_" + nom + ".png")


func setup_nom(n, p, a):
	var nom = ""
	nom = n.to_upper() + "  " + p 
	if a != "na":
		nom = nom + " (" + a + ")"
	return nom
