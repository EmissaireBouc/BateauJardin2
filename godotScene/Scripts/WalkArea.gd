extends Navigation2D

onready var walkableArea = $NavigationPolygonInstance.get_navigation_polygon().duplicate()
onready var NaviPoly = get_node("NavigationPolygonInstance")
"""
Au début du jeu : 
	-> Mémoriser la forme du Nav2D.
	-> Lorsque tous les éléments de jeu sont placés : mettre à jour le Nav 2D.
Chaque jour :
	-> En fonction des plantes arrachées et du nouveau placement des PNJ, recommencer le découpage depuis le Nav2D initial.
"""


func _ready():
	update_navigation_polygon(get_parent().get_parent().get_node("Bateau/YSort/Cabine/Sprite/CollisionPolygon2D").get_global_transform(),get_parent().get_parent().get_node("Bateau/YSort/Cabine/Sprite/CollisionPolygon2D").get_polygon())


func update_navigation_polygon(t, p):
	var newpolygon = PoolVector2Array()
	var polygon = NaviPoly.get_navigation_polygon()
	var polygon_transform = t
	var polygon_bp = p
	for vertex in polygon_bp:
		newpolygon.append(polygon_transform.xform(vertex))
	polygon.add_outline(newpolygon)
	polygon.make_polygons_from_outlines()
	NaviPoly.set_navigation_polygon(polygon)
	get_node("NavigationPolygonInstance").enabled = false
	get_node("NavigationPolygonInstance").enabled = true


func reboot():
	var original_walkableArea = walkableArea.duplicate()
	NaviPoly.set_navigation_polygon(original_walkableArea)
	get_node("NavigationPolygonInstance").enabled = false
	get_node("NavigationPolygonInstance").enabled = true
	update_navigation_polygon(get_parent().get_parent().get_node("Bateau/YSort/Cabine/Sprite/CollisionPolygon2D").get_global_transform(),get_parent().get_parent().get_node("Bateau/YSort/Cabine/Sprite/CollisionPolygon2D").get_polygon())
