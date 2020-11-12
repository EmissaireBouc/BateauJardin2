extends AnimatedSprite


const ETAT_CRITIQUE = Color(0.90,0.16,0.16,1)
const ETAT_NORMAL = Color(1,1,1,1)

export (String) var Plante 
export (int) var pv
export (int) var xp
export (int) var lvl = 1
var rng = RandomNumberGenerator.new()
var shader_vent

signal mouseOverlapped

func _ready():
	update_status()
	initialize_shader()

func update_status():
	
	if lvl > 0 :
		play("lvl"+str(lvl))
	else :
		play("lvl1")

	if pv <= 0 :
		fane()
	elif pv > 0 && pv <= 3 :
		deshydrat()

func fane():
	play("fanelvl"+str(lvl))
	$Goutte.self_modulate = ETAT_CRITIQUE

func setup(plantName):
	Plante = plantName
	pv = ImportData.plant_data[Plante].PV
	xp = ImportData.plant_data[Plante].XP
	lvl = ImportData.plant_data[Plante].LVL
	$Goutte.self_modulate = ETAT_NORMAL
	play("lvl1")
	if pv > 3 : $Goutte/AnimationPlayer.play("Modulate_humide")
	else : $Goutte/AnimationPlayer.play("Modulate_sec")
	
	initialize_shader()

func LVL_up():
	if lvl < 3:
		lvl += 1
		xp = ImportData.plant_data[Plante].XP
		update_status()
	else:
		xp = 100

func set_lvl(value):
	lvl = value
	update_status()

func initialize_shader():
	rng.randomize()
	get_material().set_shader_param("Speed",rng.randf_range(1,2))
	if get_material().get_shader_param("maxStrength") != 0:
		get_material().set_shader_param("maxStrength",rng.randf_range(0.2,0.8))
	get_material().set_shader_param("interval",rng.randf_range(1,2))
	get_material().set_shader_param("strengthScale",rng.randf_range(10,40))
	shader_vent = get_material()

func hydrat():
	if pv >= 1:
		$Goutte.self_modulate = ETAT_NORMAL
		pv += ImportData.plant_data[Plante].PV
		if pv > 3 : #&& $Goutte/AnimationPlayer.get_assigned_animation() == "Modulate_sec":
			$Goutte/AnimationPlayer.play("Modulate_humide")
	else: 
		$Goutte.self_modulate = ETAT_CRITIQUE

func deshydrat():
	if pv <= 1 :
		$Goutte.self_modulate = ETAT_CRITIQUE
	else :
		$Goutte.self_modulate = ETAT_NORMAL
	if pv > 1 && pv <= 3 :
		$Goutte/AnimationPlayer.play("Modulate_sec")





func _on_Area2D_area_shape_entered(_area_id, area, _area_shape, _self_shape):
	
	pass

func _on_Area2D_area_shape_exited(_area_id, area, _area_shape, _self_shape):
	
	pass



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Disparition":
		queue_free()
	pass # Replace with function body.


func _on_Area2D_mouse_entered():
	emit_signal("mouseOverlapped", "entered",get_name())


func _on_Area2D_mouse_exited():
	emit_signal("mouseOverlapped", "exited", get_name())


func save():
	var save_data_plante = {
	"name": Plante,
	"PV": pv,
	"XP": xp,
	"LVL": lvl,
	"positionX" : position.x,
	"positionY" : position.y
	}
	return save_data_plante
	
