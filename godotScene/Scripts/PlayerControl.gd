extends AnimatedSprite


export (int) var speed = 100
var move_direction = 30 #prend un angle en degré
var state #défini l'état du personnage (marche, idle, interact)
var path : PoolVector2Array
var destination = Vector2()
var animManager = [0]


signal Open_Carnet
signal Change_Cursor

onready var nav2D : Navigation2D = get_parent().get_parent().get_parent().get_node("Bateau/WalkArea")

enum{IDLE, MOVE, PLANT, PLANT_BACK, OPEN_INV, SPRAY, CUT}

signal anim_over

func _ready():
	destination = position
	change_state(IDLE)

func _process(delta):
	
	match state:
		IDLE:
			animation_loop("IDLE")
		MOVE:
			var move_distance = speed * delta
			move_along_path(move_distance)
			animation_loop("WALK")
			
		PLANT:
			animation_loop("PLANT")
		PLANT_BACK:
			#animation_loop("PLANT",true)
			pass
		OPEN_INV:
			animation_loop("OPEN_INV")
		SPRAY:
			animation_loop("SPRAY")
		CUT:
			animation_loop("CUT")


func change_state(newstate, dest = get_global_mouse_position()):
# Change l'état du PJ (marche, idle, plant...)
	state = newstate

	
	match state:
		IDLE:
			animation_loop("IDLE")
		MOVE:
			moving_PJ(dest)
			animation_loop("WALK")
		PLANT:
			animation_loop("PLANT")
		PLANT_BACK:
			animation_loop("PLANT", true)
		OPEN_INV:
			animation_loop("OPEN_INV")
		SPRAY:
			animation_loop("SPRAY")
		CUT:
			animation_loop("CUT")


func moving_PJ(pos):
#Défini le chemin (tableau Vector2) qu'empruntera le PJ

	var new_path = nav2D.get_simple_path(self.get_global_position(), pos)
	get_parent().get_node("Line2D").points = new_path
	self.path = new_path



func move_along_path(distance):
# Déplacement PJ sur le chemin tracé grâce à Navigation 2D
	var starting_point : = position

	for _i in range(path.size()):
		var distance_to_next : = starting_point.distance_to(path[0])
		move_direction = rad2deg(path[0].angle_to_point(position))
		if (distance <= distance_to_next):
			position = starting_point.linear_interpolate(path[0], distance / distance_to_next)
			break
		path.remove(0)

		if(path.size() == 0):
			_on_Player_animation_finished()



func _on_Player_animation_finished():
	if state != 1:
		emit_signal("anim_over", state)
	elif state == 1 && path.size()==0:
		emit_signal("anim_over", state)


func animation_loop(mode, backward = false):
# gestion de l'animation du PJ
	
	var anim_direction = ""
	var anim_mode = mode
	var animation

	if move_direction <= 40 and move_direction >= -40 :
		anim_direction = "E"
	elif move_direction <= 100 and move_direction >= 40 :
		anim_direction = "S"
	elif move_direction <= 180 and move_direction >= 100 :
		anim_direction = "W"
	elif move_direction <= -100 :
		anim_direction = "W"
	elif move_direction <= -40 and move_direction >= -100 :
		anim_direction = "N"
	animation = anim_mode +"_"+ anim_direction

	self.play(animation, backward)

	son(anim_mode)

func son(anim_mode):
	if anim_mode == "WALK":
		if frame == 1 or frame == 5:
			if !$Pas1.is_playing() && !$Pas2.is_playing():
				var rng = RandomNumberGenerator.new()
				rng.randomize()
				var alea = rng.randi()%2+1
				get_node("Pas%s" %alea).play()

	if anim_mode == "CUT":
		if frame == 4:
			if !$Couper.is_playing():
				$Couper.play()


	if anim_mode == "SPRAY":
		if frame == 3:
			if !$Arroser.is_playing():
				$Arroser.play()
	
	if anim_mode == "PLANT":
		if frame == 3:
			if !$Planter.is_playing():
				$Planter.play()


func _on_Area2D_mouse_entered():
	emit_signal("Change_Cursor","add", "lire")


func _on_Area2D_mouse_exited():
	emit_signal("Change_Cursor","remove", "lire")

#func _on_Area2D_input_event(_viewport, _event, _shape_idx):
#	if Input.is_action_pressed("ui_left_mouse"):
#		emit_signal("Open_Carnet")
