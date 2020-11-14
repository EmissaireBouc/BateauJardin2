extends Label
var PA


func PA_down(d):
	PA -= d
	PA_update()

func PA_up(d):
	PA += d
	PA_update()

func set_PA():
	if ImportData.jour <= ImportData.get_last_day():
		PA = ImportData.PAJ[str(ImportData.jour)].PA
	else : PA = 10
	PA_update()

func get_PA():
	return PA

func PA_update():
	text = "PA : "+str(PA)

