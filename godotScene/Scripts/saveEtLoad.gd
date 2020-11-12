extends Node2D

onready var plantesContainer = get_node("../Bateau/YSort/Plante")
onready var control = get_node("/root/ScenePrincipale")

var num_fichier = "1"


# Called when the node enters the scene tree for the first time.
func _ready():
	num_fichier = String(ImportData.fichier_sauvegarde)
	if ImportData.is_loading :
		#save()
		_load()
	

func save():
	var file = File.new()
	if file.open("res://saves/saved_game_"+num_fichier+".sav",File.WRITE) != 0:
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
	if ! file.file_exists("res://saves/saved_game_"+num_fichier+".sav") :
		print ("no file found")
		return
		
	# supprime les plantes déjà là	
	var plantes = plantesContainer.get_children()
	for i in control.aGarden:
		control.aGarden.remove(i)
	for p in plantes :
		p.queue_free()
	#get_node("/root/ScenePrincipale").aGarden = []

	# charge
	if file.open("res://saves/saved_game_"+num_fichier+".sav", file.READ) != 0:
		print ("error opening file")
		return
	while file.get_position() < file.get_len():
		var line_data = parse_json(file.get_line())
		if line_data.has("fichier vide"):
			return
		if line_data.has("jour") :
			ImportData.jour = line_data["jour"]
		else :
			var new_plante_scene = load("res://Assets/Plante/Scene/"+ line_data["name"] + ".tscn")
			var new_plante = new_plante_scene.instance()
			new_plante.pv = int(line_data["PV"])
			new_plante.lvl = int(line_data["LVL"])
			new_plante.xp = int(line_data["XP"])
			new_plante.Plante = line_data["name"]
			plantesContainer.add_child(new_plante)
			new_plante.position = Vector2(float(line_data["positionX"]),float(line_data["positionY"]))
			new_plante.update_status()
			control.aGarden.push_front(new_plante)
		# charge le bon jour
		control.get_node("CanvasLayer/Debug/DebugLabel4").text = "JOUR : " + str(ImportData.jour)
		ImportData.DialJour = 0
		ImportData.ChangDial = 0
		control.get_node("Bateau/YSort/PNJ").new_day()
		control.get_node("Bateau/WalkArea").reboot()
		control.get_node("CanvasLayer/PA").set_PA(int(ImportData.PAJ[str(ImportData.jour)].PA))
		control.get_node("CanvasLayer/Transition").waitForClick = true
		control.start_new_day()
		
