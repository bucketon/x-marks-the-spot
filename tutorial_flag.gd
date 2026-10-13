extends PanelContainer

@export var level: int

func _ready() -> void:
	pass
	

func completeTutorial():
	var save_data: Array[bool]
	save_data[level] = true
	var save_file = FileAccess.open("user://tutorialFlags.save", FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_data))
	

func checkTutorial() -> bool:
	if not FileAccess.file_exists("user://tutorialFlags.save"):
		return false# Error! We don't have a save to load.
	
	var save_file = FileAccess.open("user://tutorialFlags.save", FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object.
		var save_data = json.data
		return save_data[level]
		
	return false
