extends Camera2D

var Czoom = Vector2(2,2)
var a = Vector2()
export (bool) var SquareX_Camera = false

func _ready():
	a = Czoom

func _physics_process(delta):
	var px = get_parent().global_position.x
	var py = get_parent().global_position.y-200
	
	if SquareX_Camera == true :
		global_position = Vector2(px, lerp(py, py + (-1 * ((py * py)/30)), 1.2 * delta))
	else:
		global_position = Vector2(px, py)

	Czoom = Vector2(lerp(Czoom.x, clamp(a.x,0.5,5), 1.5 * delta), lerp(Czoom.y, clamp(a.y,0.5,5), 1.5 * delta))
	set_zoom(Czoom)
	
func _input(_event):
#	if Input.is_action_pressed("ui_scroll_down") || Input.is_action_pressed("ui_scroll_up"):
#
#		if Input.is_action_pressed("ui_scroll_down")&& a >= Vector2(0,0):
#			a -= Vector2(0.15,0.15)
#
#		if Input.is_action_pressed("ui_scroll_up") && a <= Vector2(2,2):
#			a += Vector2(0.15,0.15)
	pass

func zoom_in():
	a = Vector2(1.25,1.25)

func zoom_out():
	a = Vector2(2,2)

