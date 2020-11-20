extends Node2D

onready var plantesContainer = get_node("../Bateau/YSort/Plante")
onready var control = get_node("/root/ScenePrincipale")

var num_fichier = "1"



func _ready():
	num_fichier = String(ImportData.fichier_sauvegarde)



func save():
	var file = File.new()
	if file.open("user://saved_game_"+num_fichier+".sav",File.WRITE) != 0:
		print("error opening file")
		return
	var data = {"jour" : ImportData.jour }
	
	file.store_line(to_json(data))
	var plantes = plantesContainer.get_children()
	for p in plantes :
		data = p.save()
		file.store_line(to_json(data))
	file.close()



func _load():
	var file = File.new()
	if ! file.file_exists("user://saved_game_"+num_fichier+".sav") :
		print ("no file found")
		return
		

	# charge
	if file.open("user://saved_game_"+num_fichier+".sav", file.READ) != 0:
		print ("error opening file")
		return
	while file.get_position() < file.get_len():
		var line_data = parse_json(file.get_line())
		if line_data.has("fichier vide"):
			return
		if line_data.has("jour") :
			ImportData.jour = int(line_data["jour"])
		else :
			plantesContainer.add_new_plant(line_data["name"] , Vector2(float(line_data["positionX"]) , float(line_data["positionY"])) , int(line_data["PV"]) , int(line_data["XP"]) , int(line_data["LVL"]))
