extends Node

var plant_data
var equipage_data
var text

func _ready():
	var plantdata_file = File.new()
	plantdata_file.open("res://Assets/Data/PlanteData.json",File.READ)
	var plantdata_json = JSON.parse(plantdata_file.get_as_text())
	plantdata_file.close()
	plant_data = plantdata_json.result
	
	var equipage_file = File.new()
	equipage_file.open("res://Assets/Data/Equipage.json",File.READ)
	var equipage_json = JSON.parse(equipage_file.get_as_text())
	equipage_file.close()
	equipage_data = equipage_json.result
