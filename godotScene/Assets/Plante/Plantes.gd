extends AnimatedSprite

export (String) var Plante 

export (int) var pv
export (int) var xp
export (int) var lvl = 1
var rng = RandomNumberGenerator.new()
var shader_vent

func _ready():
	$Goutte/AnimationPlayer.play("Modulate_humide") #set_self_modulate(Color(0.5,1,1,1))
	update_status()
	initialize_shader()

func update_status():
	
	if lvl > 0 :
		play("lvl"+str(lvl))
	else :
		play("lvl1")

	if pv <= 0 :
		fane()

	if pv > 0 && pv <= 3 :
		deshydrat()

func fane():
	play("fanelvl"+str(lvl))

func setup(plantName):
	Plante = plantName
	pv = ImportData.plant_data[Plante].PV
	xp = ImportData.plant_data[Plante].XP
	lvl = ImportData.plant_data[Plante].LVL

	play("lvl1")
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
	if pv > 0:

		if pv == 1 :
			$Goutte.self_modulate = Color(1,1,1,1)

		pv += ImportData.plant_data[Plante].PV

		if pv > 3 && $Goutte/AnimationPlayer.get_assigned_animation() == "Modulate_sec":
			$Goutte/AnimationPlayer.play("Modulate_humide")


func deshydrat():
	if pv == 1 :
		$Goutte.self_modulate = Color(0.90,0.16,0.16,1)
	else :
		$Goutte.self_modulate = Color(1,1,1,1)
	if pv > 1 && pv <= 3 :
		$Goutte/AnimationPlayer.play("Modulate_sec")





func _on_Area2D_area_shape_entered(_area_id, _area, _area_shape, _self_shape):
	pass

func _on_Area2D_area_shape_exited(_area_id, _area, _area_shape, _self_shape):
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Disparition":
		queue_free()
	pass # Replace with function body.
