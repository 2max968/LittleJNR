extends Label

var time := 0.0;

func _ready():
	pass # Replace with function body.

func _process(delta):
	time += delta * 100;
	var iSeconds : int = int(time) / 100;
	var iHundrets : int = int(time) % 100;
	var sSenconds : String = str(iSeconds)
	var sHundrets : String = str(iHundrets)
	if(sSenconds.length() < 2):
		sSenconds = '0' + sSenconds
	if(sHundrets.length() < 2):
		sHundrets = '0' + sHundrets;
	text = sSenconds + ':' + sHundrets;
	
