extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.grab_focus.call_deferred()
