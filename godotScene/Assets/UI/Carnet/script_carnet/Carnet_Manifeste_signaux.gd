extends HBoxContainer

func setup_pages(page1, page2):

	$PageGauche.page = page1
	$PageGauche.setup()
	$PageDroite.page = page2
	$PageDroite.setup()
