extends AnimatedSprite

export (String) var Plante 

export (int) var pv
export (int) var xp
export (int) var lvl
var rng = RandomNumberGenerator.new()
var shader_vent

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

	if pv > 0 && pv <= 2 :
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

func initialize_shader():
	rng.randomize()
	get_material().set_shader_param("Speed",rng.randf_range(1,2))
	get_material().set_shader_param("maxStrength",rng.randf_range(0.2,0.8))
	get_material().set_shader_param("interval",rng.randf_range(1,2))
	get_material().set_shader_param("strengthScale",rng.randf_range(10,40))
	shader_vent = get_material()

func hydrat():
	pv += 5
	if pv > 2 :
		set_self_modulate(Color(1,1,1,1))


func deshydrat():
	set_self_modulate(Color(0.6,0.6,0.6,1))



func _on_Area2D_area_shape_entered(_area_id, _area, _area_shape, _self_shape):
	pass

func _on_Area2D_area_shape_exited(_area_id, _area, _area_shape, _self_shape):
	pass
