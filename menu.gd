extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.grab_focus.call_deferred()
	
func loadLevelSelect():
	get_tree().change_scene_to_file("res://level_select.tscn")
	
func quitGame():
	get_tree().quit()
