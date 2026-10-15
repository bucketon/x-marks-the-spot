extends PanelContainer

@export var level:int
signal closed
signal opened

func _ready():
	$PanelContainer/Button.grab_focus.call_deferred()
	if level == 0: return
	
	var flags = TutorialFlags.flags.duplicate()
	if TutorialFlags.flags.size() < level+1: TutorialFlags.flags.resize(level+1)
	TutorialFlags.flags.insert(level, true)
	if flags == null:
		opened.emit()
		return
		
	if level >= flags.size():
		opened.emit()
		return
		
	if flags[level]:
		closed.emit()
	else:
		opened.emit()

func showPopup():
	visible = true
	
