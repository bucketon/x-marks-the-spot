extends Node

@export var levels: Array[String]

var currentLevel = 0
var highestUnlockedLevel = 0

func loadLevelAtIndex(index: int):
	get_tree().change_scene_to_file(levels[index])
	
func progress():
	loadData()
	currentLevel += 1
	if currentLevel > highestUnlockedLevel: highestUnlockedLevel = currentLevel
	loadLevelAtIndex(currentLevel)
	saveData()
	

func retry():
	loadData()
	loadLevelAtIndex(currentLevel)
	

func startNewGame():
	loadData()
	currentLevel = 0
	loadLevelAtIndex(currentLevel)
	saveData()
	

func continueGame():
	loadData()
	loadLevelAtIndex(currentLevel)
	

func saveData():
	var save_dict = {
		"currentLevel" = currentLevel,
		"highestUnlockedLevel" = highestUnlockedLevel,
	}
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_dict))
	
func loadData():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
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
		
		currentLevel = dict["currentLevel"]
		highestUnlockedLevel = dict["highestUnlockedLevel"]
	

func goToMainMenu():
	get_tree().change_scene_to_file("res://menu.tscn")
	
