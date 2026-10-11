extends Node2D

func openMap():
	$minimap.visible = false
	$bigmap.visible = true
	
func closeMap():
	$minimap.visible = true
	$bigmap.visible = false
