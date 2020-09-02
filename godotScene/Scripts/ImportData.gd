extends Node

var plant_data
var equipage_data
var text
var dialogue_data

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

	var dialoguedata_file = File.new()
	dialoguedata_file.open("res://Assets/Data/DialoguesData.json",File.READ)
	var dialoguedata_json = JSON.parse(dialoguedata_file.get_as_text())
	dialoguedata_file.close()
	dialogue_data = dialoguedata_json.result
	print(dialogue_data)
