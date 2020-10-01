extends Node

var plant_data
var equipage_data
var text
var dialogue_data
var PAJ
var jour = 0

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
	dialoguedata_file.open("res://Assets/Data/DialogueTest.json",File.READ)
	var dialoguedata_json = JSON.parse(dialoguedata_file.get_as_text())
	dialoguedata_file.close()
	dialogue_data = dialoguedata_json.result
	
	var PAJ_file = File.new()
	PAJ_file.open("res://Assets/Data/PointsActions.json",File.READ)
	var PAJ_json = JSON.parse(PAJ_file.get_as_text())
	PAJ_file.close()
	PAJ = PAJ_json.result
	
