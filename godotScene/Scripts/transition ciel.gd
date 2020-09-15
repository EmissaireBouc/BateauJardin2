extends Node2D


var jour = 0
onready var main = get_node("/root/ScenePrincipale")


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.connect("animation_finished",self, "fin_anim")
	$Timer.connect("timeout", self, "nuit")
	$Timer.wait_time = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	pass


func start(day):
	get_node("../").visible = true
	jour = day
	$Timer.start()

func stop():
	get_node("../").visible = false

func nuit() :
	$AnimationPlayer.play("nuitTombe")

func fin_anim(anim):
	if anim == "nuitTombe":
		if jour == 7 || jour == 10 || jour == 11:
			$AnimationPlayer.play("aubeRateLeReveil")
		else :
			$AnimationPlayer.play("aube")
	if anim == "aube":
		main._on_Transition_transition_over("transition_out_fin")
	if anim == "aubeRateLeReveil":
		if jour == 7  :
			main._on_Transition_transition_over("transition_out_fin")
		elif jour == 10 || jour == 11:
			main.a_day_pass()
			start(main.day)
			
