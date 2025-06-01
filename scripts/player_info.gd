extends Node

var highScore: int = 0
var highestRound: int = 0
var lastScore: int = -1

func _ready() -> void:
	load_data()
	
func save_data() -> void:
	var save_file = FileAccess.open("user://game_data.save", FileAccess.WRITE)
	var scoreString = JSON.stringify(highScore)
	var roundString = JSON.stringify(highestRound)
	save_file.store_line(scoreString)
	save_file.store_line(roundString)
	save_file.close()
	
func load_data() -> void:
	if not FileAccess.file_exists("user://game_data.save"):
		print("No saved data found")
		highScore = 0
		return
	var save_file = FileAccess.open("user://game_data.save", FileAccess.READ)
	highScore = JSON.parse_string(save_file.get_line())
	printt("Read", highScore)
	highestRound = JSON.parse_string(save_file.get_line())
	printt("Read", highestRound)
	
