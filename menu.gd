extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button2.grab_focus.call_deferred()
	var volume = getVolume()
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), volume)
	

func loadLevelSelect():
	get_tree().change_scene_to_file("res://level_select.tscn")
	
func quitGame():
	get_tree().quit()
	

func getVolume() -> float:
	if not FileAccess.file_exists("user://settings.save"):
		return 0.75 # Error! We don't have a save to load. Return default value.
	
	var save_file = FileAccess.open("user://settings.save", FileAccess.READ)
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
		var dict = json.data
		
		# apply the loaded values
		return dict["volume"]
	
	return 0.75 # didn't find any data, return default.
	
