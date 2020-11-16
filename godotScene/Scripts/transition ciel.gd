extends Node2D


var jour = 0
var day = 0
onready var main = get_node("/root/ScenePrincipale")
var anim_speed = 1
var en_cours = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.connect("animation_finished",self, "fin_anim")
	$Timer.connect("timeout", self, "nuit")
	$Timer.wait_time = 2

func _input(event):
	if en_cours:
		if event.is_action_pressed("ui_accept") || event.is_action_pressed("ui_left_mouse") || event.is_action_pressed("ui_right_mouse"):
			skip_anim()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):	
	pass


func start(jr, d, new_anim_speed = 1):
	$soleil.position = Vector2(156,838)
	get_node("../").visible = true
	jour = jr
	day = d
	$Timer.start()
	anim_speed = new_anim_speed
	en_cours = true


func stop():
	get_node("../").visible = false
	en_cours = false


func nuit() :
	$AnimationPlayer.play("nuitTombe",-1,anim_speed)


func fin_anim(anim):
	if anim == "nuitTombe":
		if day == 0 :
			if jour == 7 || jour == 10 : #|| jour == 11:
				$AnimationPlayer.play("aubeRateLeReveil",-1,anim_speed)
			else :
				$AnimationPlayer.play("aube",-1,anim_speed)
		else :
				$AnimationPlayer.play("aube",-1,anim_speed)

	if anim == "aube":
		main._on_Transition_transition_over("transition_out_fin")
	if anim == "aubeRateLeReveil":
		if jour == 7  :
			main._on_Transition_transition_over("transition_out_fin")
		elif jour == 10 : # || jour == 11:
			main.a_day_pass()
			start(ImportData.jour, main.day, anim_speed)
			
			
func skip_anim():
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.play($AnimationPlayer.current_animation,-1,5.0)
	anim_speed = 5.0
