extends Node2D


var jour = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.connect("animation_finished",self, "fin_anim")
	$Timer.connect("timeout", self, "nuit")
	start(10)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	pass


func start(day):
	jour = day
	$Timer.start()


func nuit() :
	$AnimationPlayer.play("nuitTombe")

func fin_anim(anim):
	if anim == "nuitTombe":
		if jour == 7 || jour == 10 || jour == 11:
			$AnimationPlayer.play("aubeRateLeReveil")
		else :
			$AnimationPlayer.play("aube")
	if anim == "aube":
		emit_signal("transition_over", "transition_out")
	if anim == "aubeRateLeReveil":
		if jour == 7  :
			emit_signal("transition_over", "transition_out")
		elif jour == 10 || jour == 11:
			# change day
			jour += 1
			start(jour)
			
