extends Node2D


func _ready():
	
	for key in ImportData.plant_data:
		get_node(key).lvl = ImportData.plant_data[key].LVL
		get_node(key).pv = ImportData.plant_data[key].PV
		get_node(key).xp = ImportData.plant_data[key].XP
#		print(key + str(get_node(key).lvl))
		get_node(key).update_status()


func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		for i in range(get_child_count()):
			if get_child(i).get_name() != "Camera2D":
				get_child(i).pv = 3 
				get_child(i).update_status()

	if Input.is_action_just_pressed("ui_down"):
		for i in range(get_child_count()):
			if get_child(i).get_name() != "Camera2D":
				get_child(i).pv = 0 
				get_child(i).update_status()

	if Input.is_action_just_pressed("ui_left"):
		for i in range(get_child_count()):
			if get_child(i).get_name() != "Camera2D":
				if get_child(i).lvl > 0:
					get_child(i).lvl -=1
					get_child(i).update_status()
	
	if Input.is_action_just_pressed("ui_right"):
		for i in range(get_child_count()):
			if get_child(i).get_name() != "Camera2D":
				if get_child(i).lvl < 3:
					get_child(i).lvl +=1
					get_child(i).update_status()

