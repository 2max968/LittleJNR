extends Node

const INPUT_ACTIONS := ["move_jump", "move_left", "move_right", "move_sprint", 
					"move_up", "move_down", "move_jump_up", "move_jump_down", 
					"move_jump_right", "move_jump_left"]

const MOVE_JUMP = 1 << 0
const MOVE_LEFT = 1 << 1
const MOVE_RIGHT = 1 << 2
const MOVE_SPRINT = 1 << 3
const MOVE_UP = 1 << 4
const MOVE_DOWN = 1 << 5
const MOVE_JUMP_UP = 1 << 6
const MOVE_JUMP_DOWN = 1 << 7
const MOVE_JUMP_RIGHT = 1 << 8
const MOVE_JUMP_LEFT = 1 << 9

const ANALOG_THRES_ON := 0.6
const ANALOG_THRESH_OFF := 0.4

var digitalInputMask : int = 0
var analogInputMask : int = 0
var internalInputMask : int = 0
var currentInputMask : int = 0
var lastInputMask : int = 0
var lastAnalogX : float = 0
var lastAnalogY : float = 0
					
func GetInputActionList():
	return INPUT_ACTIONS

func _ready():
	pause_mode = Node.PAUSE_MODE_STOP
	process_priority = -10

func _physics_process(delta):
	# Store Inputmask from last frame
	lastInputMask = currentInputMask
	# Read new Inputmask
	digitalInputMask = 0
	for i in range(0, len(INPUT_ACTIONS)):
		if Input.is_action_pressed(INPUT_ACTIONS[i]):
			digitalInputMask |= (1 << i)
	
	# Apply touch inputs
	if Input.is_action_pressed("touch_left"):
		digitalInputMask |= MOVE_LEFT | MOVE_SPRINT
	if Input.is_action_pressed("touch_right"):
		digitalInputMask |= MOVE_RIGHT | MOVE_SPRINT
	
	# Read and apply analog inputs
	var analogX := Input.get_joy_axis(0, JOY_AXIS_0)
	var analogY := Input.get_joy_axis(0, JOY_AXIS_1)
	
	if analogX > ANALOG_THRES_ON and lastAnalogX <= ANALOG_THRES_ON:
		analogInputMask |= MOVE_RIGHT
	if analogX < ANALOG_THRESH_OFF and lastAnalogX >= ANALOG_THRESH_OFF:
		analogInputMask &= ~MOVE_RIGHT
	if analogX < -ANALOG_THRES_ON and lastAnalogX >= -ANALOG_THRES_ON:
		analogInputMask |= MOVE_LEFT
	if analogX > -ANALOG_THRESH_OFF and lastAnalogX <= -ANALOG_THRESH_OFF:
		analogInputMask &= ~MOVE_LEFT
		
	if analogY > ANALOG_THRES_ON and lastAnalogY <= ANALOG_THRES_ON:
		analogInputMask |= MOVE_DOWN
	if analogY < ANALOG_THRESH_OFF and lastAnalogY >= ANALOG_THRESH_OFF:
		analogInputMask &= ~MOVE_DOWN
	if analogY < -ANALOG_THRES_ON and lastAnalogY >= -ANALOG_THRES_ON:
		analogInputMask |= MOVE_UP
	if analogY > -ANALOG_THRESH_OFF and lastAnalogY <= -ANALOG_THRESH_OFF:
		analogInputMask &= ~MOVE_UP
		
	lastAnalogX = analogX
	lastAnalogY = analogY
	
	if RecordParser.demoLoaded:
		currentInputMask = internalInputMask
	else:
		currentInputMask = digitalInputMask | analogInputMask

func MaskOf(action : String) -> int:
	return 1 << INPUT_ACTIONS.find(action)

func IsActionPressedStr(action : String) -> bool:
	var ind := INPUT_ACTIONS.find(action)
	return (currentInputMask & (1 << ind)) != 0

func IsActionPressed(mask : int) -> bool:
	return (currentInputMask & mask) != 0

func IsActionJustPressedStr(action : String) -> bool:
	var ind := INPUT_ACTIONS.find(action)
	return ((currentInputMask & (1 << ind)) != 0) && ((lastInputMask & (1 << ind)) == 0)

func IsActionJustPressed(mask : int) -> bool:
	return ((currentInputMask & mask) != 0) && ((lastInputMask & mask) == 0)

func IsActionJustReleasedStr(action : String) -> bool:
	var ind := INPUT_ACTIONS.find(action)
	return ((currentInputMask & (1 << ind)) == 0) && ((lastInputMask & (1 << ind)) != 0)

func IsActionJustReleased(mask : int) -> bool:
	return ((currentInputMask & mask) == 0) && ((lastInputMask & mask) != 0)

func ActionPress(action : String):
	var ind := INPUT_ACTIONS.find(action)
	internalInputMask |= (1 << ind)

func ActionRelease(action : String):
	var ind := INPUT_ACTIONS.find(action)
	internalInputMask &= ~(1 << ind)
