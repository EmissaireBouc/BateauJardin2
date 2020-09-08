extends MarginContainer

func setup(nom, prenom, aka, genre, pronom, fonction, histoire):
	$PanelContainer/VBoxContainer/NomPersonnage/HBoxContainer/Nom.text = nom
	$PanelContainer/VBoxContainer/NomPersonnage/HBoxContainer/Prenom.text = prenom
	$PanelContainer/VBoxContainer/NomPersonnage/HBoxContainer/Aka.text = aka
	$PanelContainer/VBoxContainer/InformationPersonnage/HBoxContainer/Genre.text = genre
	$PanelContainer/VBoxContainer/InformationPersonnage/HBoxContainer/Pronom.text = pronom
	$PanelContainer/VBoxContainer/InformationPersonnage/HBoxContainer/Fonction.text = fonction
	$PanelContainer/VBoxContainer/HistoirePersonnage/Description.text = histoire
