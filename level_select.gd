extends Node2D

func _ready():
	var highestUnlock = $LevelManager.getHighestUnlockedLevel()
	print("highest Unlock: " + str(highestUnlock))
	for i in $ItemList.item_count:
		print("iterating... " + str(i))
		$ItemList.set_item_disabled(i, i > highestUnlock+1)
