extends Panel

func _ready():
	loadData()
	

func set_master_volume(volume:float):
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), volume)
	

func saveDataForwarder(_value:float):
	saveData()
	

func saveData():
	var save_dict = {
		"look_sensitivity" = $HSlider.value,
		"volume" = $HSlider2.value,
	}
	var save_file = FileAccess.open("user://settings.save", FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_dict))
	

func loadData():
	if not FileAccess.file_exists("user://settings.save"):
		return # Error! We don't have a save to load.
	
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
		$HSlider.value = dict["look_sensitivity"]
		$HSlider2.value = dict["volume"]
		

func grab_Focus():
	$HSlider.grab_focus.call_deferred()
	
