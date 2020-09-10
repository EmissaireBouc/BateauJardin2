extends Node2D


var compteur = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	if Input.is_action_just_pressed("ciel"):
		if compteur == 0:
			$AnimationPlayer.play("nuitTombe")
			compteur = 1
		else :
			$AnimationPlayer.play("aube")
			compteur = 0
