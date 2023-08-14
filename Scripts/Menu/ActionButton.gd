extends Button

export(String) var ActionName := ""

var actionPressed := false

func _ready():
	connect("button_down", self, "btnDown")
	connect("button_up", self, "btnUp")
	connect("hide", self, "onHide")
	
func btnDown():
	actionPressed = true
	Input.action_press(ActionName)

func btnUp():
	actionPressed = false
	Input.action_release(ActionName)

func _exit_tree():
	if actionPressed:
		btnUp()

func onHide():
	if actionPressed:
		btnUp()
