extends Label

func _ready() -> void:
	if PlayerInfo.lastScore != -1:
		show()
		text = "Score: %d" % PlayerInfo.lastScore
	else:
		hide()
