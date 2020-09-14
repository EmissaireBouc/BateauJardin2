extends MarginContainer

func setup(nom, prenom, aka, genre, pronom, fonction, histoire):
	$PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/NomPersonnage/HBoxContainer/Nom.text = nom + "  " + prenom
	$PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/NomPersonnage/HBoxContainer/Aka.text = aka
	$PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/InformationPersonnage/HBoxContainer/Genre.text = genre
	$PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/InformationPersonnage/HBoxContainer/Pronom.text = pronom
	$PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/InformationPersonnage/HBoxContainer/Fonction.text = fonction
	$PanelContainer/VBoxContainer/HistoirePersonnage/Description.text = histoire
