extends Label

export (bool) var AllSeedsAvailable = false


func _ready():
	if AllSeedsAvailable :
		for key in ImportData.plant_data:
			ImportData.plant_data[key].Available = 0
			

func _on_gMouseCollider_debug(nom, pv, lvl, xp):
	text = "Nom : " + nom + "\nPv : " + str(pv) + "\nLvl : " + str(lvl) + "\nXp : " + str(xp)
